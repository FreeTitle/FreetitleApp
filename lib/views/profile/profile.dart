import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/profile/title_view.dart';
import 'package:freetitle/views/profile/user_card.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:freetitle/views/profile/my_mission_list_view.dart';
import 'package:freetitle/app_theme.dart';

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
//    _userRepository.getUser().then((snap) => {
//      userID = snap.uid,
//      print(userID),
//    });
    super.initState();
  }

  Widget buildProfileList(userData){
    List<Widget> profileWidget = List();
    profileWidget.add(UserCard(userData: userData,));
    profileWidget.add(TitleView(
      titleTxt: 'Missions',
      subTxt: 'More',
    ));
    profileWidget.add(MyMissionListView(ownerID: userID, missionIDs: userData['missions'],));
    profileWidget.add(TitleView(
      titleTxt: 'Blogs',
      subTxt: 'More',
    ));
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

  Future<bool> getData() async {
    await _userRepository.getUser().then((snap) => {
      userID = snap.uid,
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
//      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                  Icons.settings
              ),
            )
          ],
        ),
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
            if(userID != null){
              return StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('users').document(userID).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                      return new Text('Loading');
                    default:
                      if(snapshot.data.data != null){
                        final userData = snapshot.data.data;
                        return buildProfileList(userData);
                      }
                      else{
                        return Center(
                          child: Text('User file broken'),
                        );
                      }
                  }
                },
              );
            }
            else{
              return Center(
                child: Text('User file is broken'),
              );
            }
          }
        ),
//      body: buildProfileList(),
    );
  }
}