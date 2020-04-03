import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:transparent_image/transparent_image.dart';

class Chat extends StatefulWidget{

  const Chat(
  { Key key,
    this.chatID,
    this.otherUsername,
    this.sharedBlogID,
  }):super(key:key);
  
  final String chatID;
  final String otherUsername;
  final String sharedBlogID;

  @override
  State<StatefulWidget> createState() {
    return _Chat();
  }
}

class _Chat extends State<Chat> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  ScrollController _scrollController;
  ChatUser user;
  String uid;
  String name;
  String avatar;
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> setupChat() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));

    UserRepository _userRepository = UserRepository();
    await _userRepository.getUser().then((snap) => {
      uid = snap.uid,
    });
    await Firestore.instance.collection('users').document(uid).get().then((snap) => {
      name = snap.data['displayName'],
      avatar = snap.data['avatarUrl'],
    });
    user = ChatUser(name: name, avatar: avatar, uid: uid);
    if(widget.sharedBlogID != null){
      ChatMessage message = ChatMessage(text: "shareblogid=${widget.sharedBlogID}", user: user);
      Firestore.instance.runTransaction((transaction) async {
        var documentRef = Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().document();
        await transaction.set(documentRef, message.toJson());
      });
    }

    return true;
  }

  void onSend(ChatMessage message){
    message.user.avatar = avatar;
    Firestore.instance.runTransaction((transaction) async {
      var documentRef = Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().document();
      await transaction.set(documentRef, message.toJson()).catchError((e){
        print(e);
      });
    });
  }

  Widget buildMessage(ChatMessage message) {
    if(message.text.startsWith('shareblogid=')){
      return Container(
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('blogs').document(message.text.substring(12)).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot.hasData){
              if(snapshot.data.data != null){
                return Container(
                  height: 300,
                  width: 318,
                  child: BlogCard(
                    blogID: message.text.substring(12),
                    blogData: snapshot.data.data,
                  ),
                );
              }
              else{
                return Container(
                  child: Center(
                    child: ParsedText(
                      text: '用户分享的博客不存在',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              }
            }
            else{
              return ParsedText(
                text: '用户分享的博客不存在',
                style: TextStyle(
                  color: Colors.black87,
                ),
              );
            }
          },
        ),
      );
    }
    else{
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: message.user.containerColor != null
                ? message.user.containerColor
                : Color.fromRGBO(225, 225, 225, 1),
            borderRadius: BorderRadius.circular(5.0),
          ),
          margin: EdgeInsets.only(
            bottom: 5.0,
          ),
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ParsedText(
                text: message.text,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              if (message.image != null)
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: FadeInImage.memoryNetwork(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.contain,
                    image: message.image,
                    placeholder: kTransparentImage,
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  DateFormat('HH:mm:ss').format(message.createdAt),
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: AppTheme.white,
        title: Text(widget.otherUsername, style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.black,),
            onPressed: () {

            },
          )
        ],
      ),
      body: FutureBuilder(
        future: setupChat(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                    return new Center(
                      child: Text('Loading'),
                    );
                  default:
                    if(snapshot.hasData){
                      List<DocumentSnapshot> items = snapshot.data.documents;
                      List<ChatMessage> messages = List();
                      ChatMessage message;
                      items.forEach((m) => {
                        if(m.data['user']['uid'] == uid){
                          message = ChatMessage.fromJson(m.data),
                          message.user.containerColor = AppTheme.primary,
                          messages.add(message),
                        }
                        else{
                          message = ChatMessage.fromJson(m.data),
                          message.user.containerColor = AppTheme.secondary,
                          messages.add(message),
                        }
                      });
                      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                      return DashChat(
                        key: _chatViewKey,
                        inverted: false,
                        onSend: onSend,
                        user: user,
                        height: Platform.isIOS ? MediaQuery.of(context).size.height - AppBar().preferredSize.height*2.5 : MediaQuery.of(context).size.height - AppBar().preferredSize.height*1.5,
                        inputDecoration: InputDecoration.collapsed(hintText: "Add message here..."),
                        dateFormat: DateFormat('yyyy-MMM-dd'),
                        timeFormat: DateFormat('HH:mm'),
                        messages: messages,
                        showUserAvatar: true,
                        showAvatarForEveryMessage: true,
                        scrollController: _scrollController,
                        scrollToBottom: false,
                        messageBuilder: buildMessage,
                        onPressAvatar: (ChatUser user) {
                          print("OnPressAvatar: ${user.name}");
                          Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => Profile(userID: user.uid, isMyProfile: false, userName: user.name,)
                              )
                          );
                        },
                        onLongPressAvatar: (ChatUser user) {
                          print("OnLongPressAvatar: ${user.name}");
                        },
                        inputMaxLines: 5,
                        messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
//                      messageContainerDecoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        color: AppTheme.primary,
//                      ),
                        alwaysShowSend: true,
                        inputTextStyle: TextStyle(fontSize: 16.0),
                        inputContainerStyle: BoxDecoration(
                          border: Border.all(width: 0.0),
                          color: Colors.white,
                        ),
                        onLoadEarlier: () {
                          print("loading...");
                        },
                        shouldShowLoadEarlier: false,
                        showTraillingBeforeSend: true,
                        trailing: <Widget>[
                          IconButton(
                            icon: Icon(Icons.photo),
                            onPressed: () async {
                              File result = await ImagePicker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                                maxHeight: 400,
                                maxWidth: 400,
                              );

                              if(result != null){
                                final FirebaseStorage _storage = FirebaseStorage(storageBucket: "gs://freetitle.appspot.com");
                                String filePath = 'chat_images/${DateTime.now()}.png';
                                final StorageReference storageRef = _storage.ref().child(filePath);

                                StorageUploadTask uploadTask = storageRef.putFile(result);
                                StorageTaskSnapshot download = await uploadTask.onComplete;
                                String url = await download.ref.getDownloadURL();

                                ChatMessage message = ChatMessage(text: "", user: user, image: url);

                                var documentRef = Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().document();
                                Firestore.instance.runTransaction((transaction) async {
                                  await transaction.set(
                                    documentRef,
                                    message.toJson(),
                                  );
                                });
                              }
                            },
                          )
                        ],
                      );
                    }
                    else{
                      return new Center(
                        child: Text('Some thing is wrong'),
                      );
                    }
                }
              },
            );
          }
          else{
            return Center(
              child: Text("Loading messages"),
            );
          }
        },
      )
    );
  }
}