import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/chat/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity/connectivity.dart';

class LinkTextSpan extends TextSpan {

  LinkTextSpan({ TextStyle style, String url, String text, bool innerOpen=true }) : super(
      style: style,
      text: text ?? url,
      recognizer: TapGestureRecognizer()..onTap = () {
        launch(url, forceSafariVC: innerOpen);
      }
  );
}

class PlaceHolderCard extends StatelessWidget {

  const PlaceHolderCard(
  {Key key,
    this.text,
    this.height,
  }) : super(key: key);

  final String text;
  final height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:8, left: 24, right: 24),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            color: AppTheme.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          height: height,
          child: Center(
            child: Container(
              child: Text(
                  text,
                  style: AppTheme.body1,
              ),
            ),
          ),
        ),
    );
  }
}

List<TextSpan> processText(blockText){
  List<String> blockStrings = blockText.split('<');
  List<TextSpan> textLists = List();
  for(String blockString in blockStrings){
    if(blockString.contains('href=')){
      int startURL = blockString.indexOf('href=')+6;
      int endUrl = blockString.indexOf('">');
      String url = blockString.substring(startURL, endUrl);
      String link = blockString.substring(endUrl+2);
      textLists.add( LinkTextSpan(
        style: AppTheme.link,
        url: url,
        text: ' ' + link,
      ),);
    }
    else if (blockString.contains('i>') && !blockString.contains(('/'))){
      final italicStart = blockString.indexOf('i>')+2;
      textLists.add(TextSpan(
        style: AppTheme.body1Italic,
        text: ' ' + blockString.substring(italicStart),
      ));
    }
    else if (blockString.contains('b>') && !blockString.contains('/')){
      final boldStart = blockString.indexOf('b>')+2;
      textLists.add(TextSpan(
          style: AppTheme.body1Bold,
          text: ' ' + blockString.substring(boldStart)
      ));
    }
    else{
      if(blockString.startsWith('/')){
        blockString = blockString.substring(3);
      }
      textLists.add(TextSpan(
        style: AppTheme.body1,
        text: blockString,
      ),);
    }
  }

  return textLists;
}

List<String> getCommentIDs(data){
  List<String> commentIDs = new List();
  if (data['comments'] != null){
    for(String commentID in data['comments']){
      commentIDs.add(commentID);
    }
  }
  return commentIDs;
}

class PlatformViewVerticalGestureRecognizer
    extends VerticalDragGestureRecognizer {
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    _dragDistance = _dragDistance + event.delta;
    if (event is PointerMoveEvent) {
      final double dy = _dragDistance.dy.abs();
      final double dx = _dragDistance.dx.abs();

      if (dy > dx && dy > kTouchSlop) {
        // vertical drag - accept
        resolve(GestureDisposition.accepted);
        _dragDistance = Offset.zero;
      } else if (dx > kTouchSlop && dx > dy) {
        // horizontal drag - stop tracking
        stopTrackingPointer(event.pointer);
        _dragDistance = Offset.zero;
      }
    }
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}

void saveCurrentUser() async {
  SharedPreferences sharedPref;
  await SharedPreferences.getInstance().then((pref) {
    sharedPref = pref;
  });
  UserRepository _userRepository = UserRepository();
  var userRef = await _userRepository.getUser();
  print('userRef: $userRef');
  if(userRef != null && userRef.uid != null){
    var userDataRef = await Firestore.instance.collection('users').document(userRef.uid).get();
    print('userDataRef $userDataRef');
    if(userDataRef != null){
      Map userData = userDataRef.data;
      print('userData $userData');
      assert(userRef.uid == userDataRef.documentID);
      userData['uid'] = userRef.uid;
      userData['lastClaimTime'] = null;
      sharedPref.setString('currentUser', json.encode(userData));
    }

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((token) async {
      print('FCM Token: $token');
      await _userRepository.getUser().then((snap) {
        String uid = snap.uid;
        Firestore.instance.collection('users').document(uid).updateData({
          'notificationToken': FieldValue.arrayUnion([token])
        });
      });
    });

  }
}


void launchChat(context, userID, otherUserID, otherUsername, otherUserAvatar, {sharedBlogID, sharedMissionID}) async {
  print('Launch chat: $userID, $otherUserID, $otherUsername');

  if(userID == otherUserID){
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
    if(chat["otherUserID"] == otherUserID){
      localChats.add(chat);
      break;
    }
  }

  var remoteChatsRef = await Firestore.instance.collection('chat')
      .where('users', arrayContains: userID)
      .getDocuments()
      .catchError((e) {
    print(e);
  });
  List remoteChats = List();
  for(var doc in remoteChatsRef.documents) {
    Map chat = Map.from(doc.data);
    if(chat['users'].contains(otherUserID)){
      chat['id'] = doc.documentID;
      remoteChats.add(chat);
    }
  }

  if(localChats.length != 1 || remoteChats.length != 1){
    //TODO merge chats
    mergeChats(context, localChats, remoteChats);
    Navigator.of(context).pop();
  }

  if(localChats.isNotEmpty){
    print('going local! ');
    Map localChat = localChats[0];
    Map remoteChat = remoteChats[0];
    if(localChat['id'] != remoteChat['id']){
      //TODO merge chats
      mergeChats(context, localChat['id'], remoteChat['id']);
      Navigator.of(context).pop();
    }

    // When local chat exists
    Map chat = localChats[0];
    String chatID = chat['id'];

    chat['avatar'] = otherUserAvatar;
    chat['displayName'] = otherUsername;
    chat['delete'] = false;

    chatJson[index] = json.encode(chat);
    sharedPref.setStringList('chatlist', chatJson);

    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Chat(chatID: chatID, otherUsername: otherUsername, ),
        )
    );
  }
  else{
    print('going remote! ');
    // 在firestore新建chat document，使用transaction来保障不会重复创建
    String chatID;
    if(remoteChats.isEmpty){
      print('create');
      await Firestore.instance.runTransaction((transaction) async {
        var documentRef = Firestore.instance.collection('chat').document();
        await transaction.set(documentRef, {
          'users': [
            userID,
            otherUserID,
          ],
          'lastMessageTime': DateTime.now(),
          'lastMessageContent': '',
        });
        chatID = documentRef.documentID;
      }).catchError((err) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('创建聊天失败'),
                content: Text('数据库错误'),
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
    }
    else {
      print('remote exist');
      chatID = remoteChats[0]['id'];
    }

    // 将聊天存入本地
    List<String> chatJson;
    chatJson = sharedPref.getStringList('chatlist');

    chatJson.add(json.encode({
      'id': chatID,
      'otherUserID': otherUserID,
      'lastMessageContent': '',
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
      'avatar': otherUserAvatar,
      'displayName': otherUsername,
      'delete': false,
    }));
    sharedPref.setStringList('chatlist', chatJson);
    // 进入聊天界面
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => Chat(chatID: chatID, otherUsername: otherUsername,),
        )
    );
  }
}


void mergeChats(context, localChatID, remoteChatID) {
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text('开启聊天出现错误，请截屏联系开发人员'),
        content: Text('localID: $localChatID, remoteID: $remoteChatID'),
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