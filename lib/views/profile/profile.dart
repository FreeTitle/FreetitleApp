import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/profile/userCard.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {

  UserRepository _userRepository;
  String userID;

  @override
  void initState(){
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap) => {
      userID = snap.uid,
    });
    super.initState();
  }

  Widget buildProfileList(){
    List<Widget> profileWidget = List();
    profileWidget.add(UserCard());
    return ListView.builder(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: profileWidget.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index){
        return profileWidget[index];
      }
    );
  }

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Colors.transparent,
//      statusBarIconBrightness: Brightness.dark,
//      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
//      systemNavigationBarColor: Colors.white,
//      systemNavigationBarDividerColor: Colors.grey,
//      systemNavigationBarIconBrightness: Brightness.dark,
//    ));
    return Scaffold(
//        body: StreamBuilder<DocumentSnapshot>(
//          stream: Firestore.instance.collection('users').document(userID).snapshots(),
//          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
//            if (snapshot.hasError)
//              return new Text('Error: ${snapshot.error}');
//            switch(snapshot.connectionState){
//              case ConnectionState.waiting:
//                return new Text('Loading');
//              default:
//                if(snapshot.data.data != null){
//                  print(snapshot.data.data);
//                }
//                return buildProfileList();
//            }
//          },
//        )
      body: buildProfileList(),
    );
  }
}