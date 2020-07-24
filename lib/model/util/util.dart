import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

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
            color: Theme.of(context).primaryColorDark,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).primaryColorLight.withOpacity(0.8),
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
                  style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
    );
  }
}

//List<TextSpan> processText(blockText, context){
//  List<String> blockStrings = blockText.split('<');
//  List<TextSpan> textLists = List();
//  for(String blockString in blockStrings){
//    if(blockString.contains('href=')){
//      int startURL = blockString.indexOf('href=')+6;
//      int endUrl = blockString.indexOf('">');
//      String url = blockString.substring(startURL, endUrl);
//      String link = blockString.substring(endUrl+2);
//      textLists.add( LinkTextSpan(
//        style: AppTheme.link,
//        url: url,
//        text: ' ' + link,
//      ),);
//    }
//    else if (blockString.contains('i>') && !blockString.contains(('/'))){
//      final italicStart = blockString.indexOf('i>')+2;
//      textLists.add(TextSpan(
//        style: AppTheme.body1Italic,
//        text: ' ' + blockString.substring(italicStart),
//      ));
//    }
//    else if (blockString.contains('b>') && !blockString.contains('/')){
//      final boldStart = blockString.indexOf('b>')+2;
//      textLists.add(TextSpan(
//          style: Theme.of(context).textTheme.bodyText2,
//          text: ' ' + blockString.substring(boldStart)
//      ));
//    }
//    else{
//      if(blockString.startsWith('/')){
//        blockString = blockString.substring(3);
//      }
//      textLists.add(TextSpan(
//        style: Theme.of(context).textTheme.bodyText1,
//        text: blockString,
//      ),);
//    }
//  }
//
//  return textLists;
//}

//class PlatformViewVerticalGestureRecognizer
//    extends VerticalDragGestureRecognizer {
//  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
//      : super(kind: kind);
//
//  Offset _dragDistance = Offset.zero;
//
//  @override
//  void addPointer(PointerEvent event) {
//    startTrackingPointer(event.pointer);
//  }
//
//  @override
//  void handleEvent(PointerEvent event) {
//    _dragDistance = _dragDistance + event.delta;
//    if (event is PointerMoveEvent) {
//      final double dy = _dragDistance.dy.abs();
//      final double dx = _dragDistance.dx.abs();
//
//      if (dy > dx && dy > kTouchSlop) {
//        // vertical drag - accept
//        resolve(GestureDisposition.accepted);
//        _dragDistance = Offset.zero;
//      } else if (dx > kTouchSlop && dx > dy) {
//        // horizontal drag - stop tracking
//        stopTrackingPointer(event.pointer);
//        _dragDistance = Offset.zero;
//      }
//    }
//  }
//
//  @override
//  String get debugDescription => 'horizontal drag (platform view)';
//
//  @override
//  void didStopTrackingLastPointer(int pointer) {}
//}

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
      await sharedPref.setString('currentUser', json.encode(userData));
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

