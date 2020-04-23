import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:freetitle/views/mission/mission_list_view.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Chat extends StatefulWidget{

  const Chat(
  { Key key,
    @required this.chatID,
    @required this.otherUsername,
    this.indexState,
//    this.sharedBlogID,
//    this.sharedMissionID,
  }): assert(chatID != null), super(key:key);
  
  final String chatID;
  final String otherUsername;
//  final String sharedBlogID;
//  final String sharedMissionID;
  final indexState;

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<Chat> {

  ChatUser user;
  String uid;
  String name;
  String avatar;

//  Future<bool> _getRemoteChat;
//  Future<bool> _getLocalChat;

  SharedPreferences sharedPref;

  List<ChatMessage> messages;

  @override
  void initState() {
    if(widget.indexState != null){
      if(widget.indexState.unreadMessages != null){
        if(widget.indexState.unreadMessages.containsKey(widget.chatID)){
          widget.indexState.unreadMessages[widget.chatID] = 0;
        }
      }
    }
    getRemoteChat();
    getLocalChat();
    messages = List();
    super.initState();
  }

  Future<bool> getLocalChat() async {
    await SharedPreferences.getInstance().then((pref) {
      sharedPref = pref;
    });
    String jsonUser = sharedPref.getString('currentUser');
    Map currentUser = json.decode(jsonUser);
    uid = currentUser['uid'];
    name = currentUser['displayName'];
    avatar = currentUser['avatarUrl'];
    user = ChatUser(name: name, avatar: avatar, uid: uid);
    return true;
  }

  Future<bool> getRemoteChat() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    await Firestore.instance.collection('users').document(uid).get().then((snap) {
      name = snap.data['displayName'];
      avatar = snap.data['avatarUrl'];
    });
    user = ChatUser(name: name, avatar: avatar, uid: uid);

    return true;
  }

  void saveLocalChat(List<ChatMessage> messages) async {
    List<String> jsonMessages = List();
    messages.forEach((message) {
      final color = message.user.color;
      final containerColor = message.user.containerColor;
      message.user.containerColor = null;
      message.user.color = null;
      jsonMessages.add(json.encode(message.toJson()));
      message.user.containerColor = containerColor;
      message.user.color = color;
    });
    sharedPref.setStringList('chat${widget.chatID}', jsonMessages);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        brightness: Brightness.dark,
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
      body: FutureBuilder<bool>(
        future: getLocalChat(),
        builder: (BuildContext context, AsyncSnapshot<bool> localSnapshot) {
          if(localSnapshot.connectionState == ConnectionState.done) {
            print(user);
            return FutureBuilder(
              future: getRemoteChat(),
              builder: (BuildContext context, AsyncSnapshot<bool> remoteSnapshot){
                if(remoteSnapshot.connectionState == ConnectionState.done){
                  return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState){
                        default:
                          if(snapshot.hasData){
                            List<DocumentSnapshot> items = snapshot.data.documents;
                            List<ChatMessage> messages = List();
                            ChatMessage message;

                            items.forEach((m) {
                              if(m.data['user']['uid'] == uid){
                                message = ChatMessage.fromJson(m.data);
                                message.user.containerColor = AppTheme.primary;
                                messages.add(message);
                              }
                              else{
                                message = ChatMessage.fromJson(m.data);
                                message.user.containerColor = AppTheme.secondary;
                                messages.add(message);
                              }
                            });
                            messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                            saveLocalChat(messages);
                            return ChatScreen(chatID: widget.chatID, user: user, avatar: avatar, messages: messages,);
                          }
                          else{
                            return ChatScreen(chatID: widget.chatID, user: user, avatar: avatar, messages: messages,);
                          }
                      }
                    },
                  );
                }
                else{
                  // Load local chat
                  List jsonMessages = sharedPref.getStringList('chat${widget.chatID}');
                  ChatMessage message;
//                  List<ChatMessage> messages = List();
                  if(jsonMessages != null){
                    jsonMessages.forEach((jsonMessage) {
                      Map m = json.decode(jsonMessage);
                      if(m['user']['uid'] == uid){
                        message = ChatMessage.fromJson(m);
                        message.user.containerColor = AppTheme.primary;
                        messages.add(message);
                      }
                      else {
                        message = ChatMessage.fromJson(m);
                        message.user.containerColor = AppTheme.secondary;
                        messages.add(message);
                      }
                    });
                    return ChatScreen(chatID: widget.chatID, user: user, avatar: avatar, messages: messages,);
                  }
                  else{
                    return Center(
                      child: Text("Loading messages"),
                    );
                  }
                }
              },
            );
          }
          else {
            return Center(
              child: Text("Loading messages"),
            );
          }
        },
      )
    );
  }
}


class ChatScreen extends StatefulWidget {

  const ChatScreen(
  {Key key,
    this.chatID,
    this.user,
    this.avatar,
    this.messages,
  }) : super(key: key);

  final chatID;
  final user;
  final avatar;
  final messages;
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.activity.velocity < -600.0){
        print(_scrollController.position.activity.velocity);
        var currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  void onSend(ChatMessage message){
    message.user.avatar = widget.avatar;

    var chatRef = Firestore.instance.collection('chat').document(widget.chatID);
    var messageRef = Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().document();
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(messageRef, message.toJson()).catchError((e){
        print(e);
      });
      await transaction.update(chatRef, {
        'lastMessageTime': message.createdAt,
        'lastSenderId': widget.user.uid,
        'lastMessageContent': message.image != null ? '[图片]' : message.text,
      }).catchError((e) {
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
//                Map blogData = snapshot.data.data;
                return Container(
                  height: 230,
                  width: 250,
                  child: ChatBlogCard(
                    blogID: message.text.substring(12),
                    blogData: snapshot.data.data,
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
                          text: '用户分享的博客不存在',
                          style: TextStyle(
                            color: Colors.black87,
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
            else{
              return ParsedText(
                text: '用户分享的Blog不存在',
                style: TextStyle(
                  color: Colors.black87,
                ),
              );
            }
          },
        ),
      );
    }
    else if(message.text.startsWith('sharemissionid=')) {
      return Container(
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('missions').document(message.text.substring(15)).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

            if(snapshot.hasData){
              if(snapshot.data.data != null) {
                return Container(
                  height: 230,
                  width: 250,
                  child: VerticalMissionCard(
                    missionData: snapshot.data.data,
                    missionID: message.text.substring(15),
                  ),
                );
              }
              else{
                return ParsedText(
                  text: '用户分享的Mission不存在_',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                );
              }
            }else{
              return ParsedText(
                text: '用户分享的Mission不存在',
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
                FadeInImage.memoryNetwork(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.contain,
                  image: message.image,
                  placeholder: kTransparentImage,
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
    return DashChat(
      key: _chatViewKey,
      inverted: false,
      onSend: onSend,
      user: widget.user,
      height: Platform.isIOS ? MediaQuery.of(context).size.height - AppBar().preferredSize.height*2.0 : MediaQuery.of(context).size.height - AppBar().preferredSize.height*1.5,
      inputDecoration: InputDecoration.collapsed(hintText: "Add message here..."),
      dateFormat: DateFormat('yyyy-MMM-dd'),
      timeFormat: DateFormat('HH:mm'),
      messages: widget.messages,
      showUserAvatar: true,
      avatarBuilder: (user) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipOval(
              child: Container(
                height: MediaQuery.of(context).size.width * 0.08,
                width: MediaQuery.of(context).size.width * 0.08,
                color: Colors.grey,
                child: Center(child: Text(user.name[0])),
              ),
            ),
            user.avatar != null && user.avatar.length != 0
                ? Center(
              child: ClipOval(
                child: FadeInImage.memoryNetwork(
                  image: user.avatar,
                  placeholder: kTransparentImage,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width * 0.08,
                  width: MediaQuery.of(context).size.width * 0.08,
                ),
              ),
            )
                : Container()
          ],
        );
      },
      showAvatarForEveryMessage: true,
      scrollController: _scrollController,
      scrollToBottom: false,
      messageBuilder: buildMessage,
      onPressAvatar: (ChatUser user) {
        print("OnPressAvatar: ${user.name}");
        Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => Profile(userID: user.uid, isMyProfile: false)
            )
        );
      },
      onLongPressAvatar: (ChatUser user) {
        print("OnLongPressAvatar: ${user.name}");
      },
      inputMaxLines: 5,
      messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
//      messageContainerDecoration: BoxDecoration(
//        borderRadius: BorderRadius.all(Radius.circular(10.0)),
//        color: AppTheme.primary,
//      ),
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

            if(result == null){
              return;
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('确认发送？'),
                  content: Image.file(result),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('否'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('发送'),
                      onPressed: () async {
                        if(result != null){
                          final FirebaseStorage _storage = FirebaseStorage(storageBucket: "gs://freetitle.appspot.com");
                          String filePath = 'chat_images/${DateTime.now()}.png';
                          final StorageReference storageRef = _storage.ref().child(filePath);

                          StorageUploadTask uploadTask = storageRef.putFile(result);
                          StorageTaskSnapshot download = await uploadTask.onComplete;
                          String url = await download.ref.getDownloadURL();

                          ChatMessage message = ChatMessage(text: "", user: widget.user, image: url);

                          var documentRef = Firestore.instance.collection('chat').document(widget.chatID).collection('messages').reference().document();
                          Firestore.instance.runTransaction((transaction) async {
                            await transaction.set(
                              documentRef,
                              message.toJson(),
                            );
                          });
                        }
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
            );
          },
        )
      ],
    );
  }
}

