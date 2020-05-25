import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({Key key,
    this.otherAvatar,
    this.otherUsername,
    this.otherUserID,
    this.sharedBlogID,
    this.sharedMissionID,
  }) : super(key: key);
  final String otherAvatar;
  final String otherUsername;
  final String otherUserID;
  final String sharedBlogID;
  final String sharedMissionID;

  _ContactCard createState() => _ContactCard();
}

class _ContactCard extends State<ContactCard>{

  UserRepository _userRepository;
  String userID;
  bool isLaunchButtonEnabled;
  @override
  void initState(){
    _userRepository = UserRepository();
    isLaunchButtonEnabled = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () async {

                // 检查是否联网 保证不会多次创建聊天
                var connectivityResult = await (Connectivity().checkConnectivity());
                if(connectivityResult == ConnectivityResult.none){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('创建聊天失败'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('好'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }
                  );
                }

                await _userRepository.getUser().then((snap) {
                  userID = snap.uid;
                });

                // disable launch button 保障不会重复点击
                if(!isLaunchButtonEnabled){
                  return;
                }
                isLaunchButtonEnabled = false;
                // 如果这两个id中的一个不为null，则用户在发送blog或mission
                if(widget.sharedBlogID != null || widget.sharedMissionID != null){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('是否发送内容？'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('否'),
                            onPressed: () {
                              isLaunchButtonEnabled = true;
                              setState(() {

                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('是'),
                            onPressed: () async {
                              if(userID == widget.otherUserID){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('请不要发送消息给自己哦'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('好'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                );
                                return;
                              }

                              // 检查是否联网 保证不会多次创建聊天
                              var connectivityResult = await (Connectivity().checkConnectivity());
                              if(connectivityResult == ConnectivityResult.none){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('创建聊天失败'),
                                        content: Text('网络错误'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('好'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    }
                                );
                              }

                              // Create my ChatUser object
                              String name, avatar;
                              await Firestore.instance.collection('users').document(userID).get().then((snap) {
                                name = snap.data['displayName'];
                                avatar = snap.data['avatarUrl'];
                              });
                              ChatUser user = ChatUser(name: name, avatar: avatar, uid: userID);

                              //  Get local chats
                              List localChats = List();
                              SharedPreferences sharedPref;
                              await SharedPreferences.getInstance().then((pref) {
                                sharedPref = pref;
                              });
                              List<String> chatJson = List();
                              chatJson = sharedPref.getStringList('chatlist');
                              int index;
                              for(index = 0;index < chatJson.length;index++) {
                                Map chat = json.decode(chatJson[index]);
                                if(chat["otherUserID"] == widget.otherUserID){
                                  localChats.add(chat);
                                  break;
                                }
                              }

                              // Get remote chats
                              var remoteChatsRef = await Firestore.instance.collection('chat')
                                  .where('users', arrayContains: userID)
                                  .getDocuments()
                                  .catchError((e) {
                                print(e);
                              });
                              List remoteChats = List();
                              for(var doc in remoteChatsRef.documents) {
                                Map chat = Map.from(doc.data);
                                if(chat['users'].contains(widget.otherUserID)){
                                  chat['id'] = doc.documentID;
                                  remoteChats.add(chat);
                                }
                              }

                              if(localChats.length != 1 || remoteChats.length != 1){
                                //TODO merge chats
                                mergeChats(context, localChats, remoteChats);
                                Navigator.of(context).pop();
                              }

                              String chatID;

                              ChatMessage message;
                              String messageText;
                              String errMessage;
                              if(widget.sharedBlogID != null){
                                message = ChatMessage(text: "shareblogid=${widget.sharedBlogID}", user: user);
                                messageText = "shareblogid=${widget.sharedBlogID}";
                                errMessage = 'Blog发送失败';
                              }
                              else if(widget.sharedMissionID != null){
                                message = ChatMessage(text: "sharemissionid=${widget.sharedMissionID}", user: user);
                                messageText = "sharemissionid=${widget.sharedMissionID}";
                                errMessage = 'Mission发送失败';
                              }

                              if(localChats.isNotEmpty){
                                Map localChat = localChats[0];
                                Map remoteChat = remoteChats[0];
                                if(localChat['id'] != remoteChat['id']){
                                  //TODO merge chats
                                  mergeChats(context, localChat['id'], remoteChat['id']);
                                  Navigator.of(context).pop();
                                }

                                Map chat = localChats[0];
                                chatID = chat['id'];
                              }else {
                                if(remoteChats.isEmpty){
                                  var documentRef = Firestore.instance.collection('chat').document();
                                  await Firestore.instance.runTransaction((transaction) async {
                                    await transaction.set(documentRef, {
                                      'users': [
                                        userID,
                                        widget.otherUserID,
                                      ],
                                      'lastMessageTime': DateTime.now(),
                                      'lastMessageContent': '',
                                    });
                                    chatID = documentRef.documentID;
                                  });
                                }
                                else {
                                  chatID = remoteChats[0]['id'];
                                }
                              }

                              await Firestore.instance.runTransaction((transaction) async {
                                var messageRef = Firestore.instance.collection('chat').document(chatID).collection('messages').reference().document();
                                var chatRef = Firestore.instance.collection('chat').document(chatID);
                                await transaction.set(messageRef, message.toJson());
                                await transaction.update(chatRef, {
                                  'lastSenderId': userID,
                                  'lastMessageContent': messageText,
                                });
                              }).catchError((err) {
                                print(err);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(errMessage),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('好'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    }
                                );
                              });

                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    }
                  );
                }
                else{
                  launchChat(context, userID, widget.otherUserID, widget.otherUsername, widget.otherAvatar);
                }
                isLaunchButtonEnabled = true;
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(80.0)),
                          child: Image.network(widget.otherAvatar, fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      children: <Widget>[
                        widget.otherUsername.length < 20 ? Text(widget.otherUsername) : Text(widget.otherUsername.substring(0,19)+'...'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider()
          ],
        )
    );
  }
}