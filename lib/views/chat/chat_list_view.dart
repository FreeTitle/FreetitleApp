import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/chat/chat_card.dart';
import 'package:freetitle/views/chat/contact_list_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatListScreen extends StatefulWidget{

  ChatListScreen({Key key, @required this.unreadMessages, this.callback}) : super(key : key);

  final unreadMessages;
  final callback;

  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>{
  String userID;
  UserRepository _userRepository;

  Future<bool> _getChatList;
  Future<bool> _getLocal;
  SharedPreferences sharedPref;
//  List chatData = List();
  Map<String, Map<String, dynamic>> chatData;
//  String messageID;
  bool refresh = true;

  @override
  void initState(){
    _userRepository = UserRepository();
    _getChatList = getChatList();
    _getLocal = getLocal();
    chatData = Map();
    super.initState();
  }

  Future<bool> getLocal() async {
    SharedPreferences.getInstance().then((pref) {
      sharedPref = pref;
    });
    return true;
  }

  Future<bool> getChatList() async {
    await _userRepository.getUser().then((snap) {
      if(snap != null)
        userID = snap.uid;
    });

    var possibleChats = await Firestore.instance.collection('chat')
        .where('users', arrayContains: userID)
        .getDocuments()
        .catchError((e) {
          print(e);
        });
    if (possibleChats.documents.isNotEmpty) {
      for(var doc in possibleChats.documents) {
        Map data = doc.data;
        String lastMessageContent;
        Timestamp lastMessageTime;
        String otherUserAvatar;
        String otherUserName;
        String otherUserID;
        
        lastMessageContent = data['lastMessageContent'];
        lastMessageTime = data['lastMessageTime'];
        if(lastMessageContent == null){
          lastMessageContent = '';
        }
        if(lastMessageContent.startsWith('shareblogid=')){
          lastMessageContent = '[Blog]';
        }
        if(lastMessageContent.startsWith('sharemissionid=')) {
          lastMessageContent = '[Mission]';
        }

        //私聊
        if(data['users'].length == 2) {
          for(var uid in data['users']){
            if(uid != userID){
              otherUserID = uid;
              await Firestore.instance.collection('users').document(uid).get().then((userSnap) {
                if(userSnap != null) {
                  otherUserAvatar = userSnap.data['avatarUrl'];
                  otherUserName = userSnap.data['displayName'];
                }
              });
            }
          }
        }
        // deleted chats should not display
        if(chatData.containsKey(doc.documentID) && chatData[doc.documentID]['delete'] == true){
          continue;
        }
        // chat other user initiated should not display
        if(lastMessageContent == ''){
          continue;
        }
        chatData[doc.documentID] = {
          'id': doc.documentID,
          'otherUserID': otherUserID,
          'lastMessageContent': lastMessageContent,
          'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
          'avatar': otherUserAvatar,
          'displayName': otherUserName,
          'delete': false,
        };

      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('私信', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).push(contactListRoute());
            },
          ),
          SizedBox(width: 10,),
        ],
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: FutureBuilder<bool>(
        future: _getLocal,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return FutureBuilder(
              future: getChatList(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  List<String> chatJson = List();

                  for(var id in chatData.keys.toList()) {
                    chatJson.add(json.encode(chatData[id]));
                  }

                  sharedPref.setStringList('chatlist', chatJson);
                  List chatDataValue = chatData.values.toList().where((chat) => chat['delete'] == false).toList();
                  chatDataValue.sort((a, b) => b['lastMessageTime'].compareTo(a['lastMessageTime']));
                  return ListView.builder(
                      itemCount: chatDataValue.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index){
                        Map unreadMessages = widget.unreadMessages;
                        int unreadNum = 0;
                        String messageID = chatDataValue[index]['id'];
                        if(unreadMessages.containsKey(messageID)){
                          unreadNum = unreadMessages[messageID];
                        }
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          child: ChatCard(
                            chatID: messageID,
                            latestMessage: chatDataValue[index]['lastMessageContent'],
                            latestTime: chatDataValue[index]['lastMessageTime'],
                            avatar: chatDataValue[index]['avatar'],
                            username: chatDataValue[index]['displayName'],
                            unreadNum: unreadNum,
                            callback: widget.callback,
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('是否删除评论？'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('否'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                              color: Colors.red,
                                              child: Text('是'),
                                              onPressed: () {
                                                chatData[messageID]['delete'] = true;
                                                List<String> chatJson = List();

                                                for(var id in chatData.keys.toList()) {
                                                  chatJson.add(json.encode(chatData[id]));
                                                }

                                                sharedPref.setStringList('chatlist', chatJson);
                                                setState(() {

                                                });
                                                Navigator.of(context).pop();
                                              }
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                            ),
                          ],
                        );
                        //ChatCard(chatID: messageIDs[index], otherUserID: otherUserIDs[index]);
                      }
                  );
                }
                else{
                  List<String> chatJson;
                  chatJson = sharedPref.getStringList('chatlist');
                  List chatList = List();
                  chatJson.forEach((chat) {
                    chatList.add(json.decode(chat));
                  });

                  chatList.forEach((chat) {
                    chatData[chat['id']] = chat;
                  });

                  chatList = chatList.where((chat) => chat['delete'] == false).toList();
                  chatList.sort((a, b) => b['lastMessageTime'].compareTo(a['lastMessageTime']));
                  return ListView.builder(
                    itemCount: chatList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      String messageID = chatList[index]['id'];
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        child: ChatCard(
                          chatID: chatList[index]['id'],
                          latestMessage: chatList[index]['lastMessageContent'],
                          latestTime: chatList[index]['lastMessageTime'],
                          avatar: chatList[index]['avatar'],
                          username: chatList[index]['displayName'],
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('是否删除评论？'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('否'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                            color: Colors.red,
                                            child: Text('是'),
                                            onPressed: () {
                                              chatData[messageID]['delete'] = true;
                                              List<String> chatJson = List();

                                              for(var id in chatData.keys.toList()) {
                                                chatJson.add(json.encode(chatData[id]));
                                              }

                                              sharedPref.setStringList('chatlist', chatJson);
                                              setState(() {

                                              });
                                              Navigator.of(context).pop();
                                            }
                                        )
                                      ],
                                    );
                                  }
                              );
                            },
                          ),
                        ],
                      );
                    }
                  );
                }
              },
            );
          }
          else {
            return SizedBox();
          }
        },
      )
    );
  }
}

Route contactListRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ContactListView(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

//class ChatListAppBar extends StatefulWidget {
//  ChatListAppBar({Key key, this.state}) : super(key : key);
//
//  final _ChatListScreenState state;
//
//  _ChatListAppBar createState() => _ChatListAppBar();
//}

//class _ChatListAppBar extends State<ChatListAppBar> {
//  @override
//  Widget build(BuildContext context) {
//    return AppBar(
//      centerTitle: true,
//      title: Text(widget.state.refresh == true ? '加载中...' : '私信', style: TextStyle(color: Colors.black)),
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.add, color: Colors.black,),
//          onPressed: () {
//            Navigator.of(context).push(contactListRoute());
//          },
//        ),
//        SizedBox(width: 10,),
//      ],
//      backgroundColor: Colors.white,
//      brightness: Brightness.light,
//    );
//  }
//}