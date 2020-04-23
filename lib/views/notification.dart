import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/views/mission/mission_detail.dart';
import 'package:freetitle/views/blog/blog_detail.dart';


Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("onBackgroundMessage: $message");
  //_showBigPictureNotification(message);
  return Future<void>.value();
}


void setUpNotification(context) {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false)
  );

  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  }).onError((err) {
    print('request error: $err');
  });
  _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    print('my token is $token');
  }).catchError((err) {
    print('get token error: $err');
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) {
      print('onMessage called: $message');
      if(message['blog'] != null){
        try{

        } catch(e) {
          print('Error open blog from notification due to: $e');
        }
      }
      else if (message['mission'] != null){
        try{

        } catch(e) {
          print('Error open mission from notification due to: $e');
        }
      }
      else if (message['chat'] != null) {
//          if(unreadMessages.containsKey(message['chat'])){
//            unreadMessages[message['chat']] += 1;
//          }
//          else{
//            unreadMessages[message['chat']] = 1;
//          }
//          setState(() {
//
//          });
      }
      return;
    },
    onResume: (Map<String, dynamic> message) {
      print('onResume called: $message');
      if(message['blog'] != null){
        try{
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => BlogDetail(blogID: message['blog'],)
              )
          );
        } catch(e) {
          print('Error open blog from notification due to: $e');
        }
      }
      else if (message['mission'] != null){
        try{
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MissionDetail(missionID: message['mission'],)
              )
          );
        } catch(e) {
          print('Error open mission from notification due to: $e');
        }
      }
      else if (message['chat'] != null) {
//          if(unreadMessages.containsKey(message['chat'])){
//            unreadMessages[message['chat']] += 1;
//          }
//          else{
//            unreadMessages[message['chat']] = 1;
//          }
//          setState(() {
//
//          });
      }
      return;
    },
    onLaunch: (Map<String, dynamic> message) {
      print('onLaunch called: $message');
      if(message['blog'] != null){
        try{
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => BlogDetail(blogID: message['blog'],)
              )
          );
        } catch(e) {
          print('Error open blog from notification due to: $e');
        }
      }
      else if (message['mission'] != null){
        try{
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MissionDetail(missionID: message['mission'],)
              )
          );
        } catch(e) {
          print('Error open mission from notification due to: $e');
        }
      }
      else if (message['chat'] != null) {
//          if(unreadMessages.containsKey(message['chat'])){
//            unreadMessages[message['chat']] += 1;
//          }
//          else{
//            unreadMessages[message['chat']] = 1;
//          }
//          setState(() {
//
//          });
      }
      return;
    },
  );
}
