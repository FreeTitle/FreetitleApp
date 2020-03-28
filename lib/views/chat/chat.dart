import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Chat extends StatefulWidget{

  const Chat(
  { Key key,
    this.chatID,
  }):super(key:key);
  
  final String chatID;

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
  UserRepository _userRepository;
  @override
  void initState() {
    _userRepository = UserRepository();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> getUser() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));

    UserRepository _userRepository = UserRepository();
    await _userRepository.getUser().then((snap) => {
      uid = snap.uid,
    });
    await Firestore.instance.collection('users').document(uid).get().then((snap) => {
      name = snap.data['displayName'],
      avatar = snap.data['avatarUrl'],
    });
    return true;
  }

  void onSend(ChatMessage message){
    message.user.avatar = avatar;
    var documentRef = Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().document();
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentRef, message.toJson()).catchError((e){
        print(e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: AppTheme.white,
        title: Text("Chat", style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
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
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
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
                    user = ChatUser(name: name, avatar: avatar, uid: uid);
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
                      height: MediaQuery.of(context).size.height - AppBar().preferredSize.height*2.5,
                      inputDecoration: InputDecoration.collapsed(hintText: "Add message here..."),
                      dateFormat: DateFormat('yyyy-MMM-dd'),
                      timeFormat: DateFormat('HH:mm'),
                      messages: messages,
                      showUserAvatar: true,
                      showAvatarForEveryMessage: true,
                      scrollController: _scrollController,
                      scrollToBottom: true,
//                        messageBuilder: (ChatMessage message) {
//                          return Container;
//                        },
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
                      shouldShowLoadEarlier: true,
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

                              var documentRef = Firestore.instance.collection('messages').document();
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
        },
      )
    );
  }
}