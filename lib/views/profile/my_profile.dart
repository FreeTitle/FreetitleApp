import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:freetitle/views/profile/profile_blog_list_view.dart';
import 'package:freetitle/views/profile/title_view.dart';
import 'package:freetitle/views/profile/user_card.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:freetitle/views/profile/profile_mission_list_view.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/settings/settings.dart';

class MyProfile extends StatefulWidget {
  const MyProfile(
  {Key key,
    this.userID,
    this.userName,
  }) : super(key: key);

  final String userID;
  final String userName;

  @override
  State<StatefulWidget> createState() {
    return _MyProfile();
  }
}

class _MyProfile extends State<MyProfile> {

  Widget buildProfileList(userData){

    final userID = widget.userID;

    List<Widget> profileWidget = List();
    profileWidget.add(UserCard(userData: userData, userID: userID,));
    profileWidget.add(TitleView(
      titleTxt: 'My Missions',
      subTxt: '',
    ));
    profileWidget.add(ProfileHorizontalMissionListView(ownerID: userID, missionIDs: userData['missions'],));
    profileWidget.add(SizedBox(height: 10,));
    profileWidget.add(TitleView(
      titleTxt: 'My Blogs',
      subTxt: '',
    ));
    profileWidget.add(ProfileBlogListView(ownerID: userID,));
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
//          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: profileWidget,
        ),
      ),
      physics: ClampingScrollPhysics(),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final userID = widget.userID;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('users').document(userID).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(
                  child: Text('Loading...'),
                );
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
        ),
    );
  }
}

class GetMyProfile extends StatefulWidget {

  _GetMyProfile createState() => _GetMyProfile();
}

class _GetMyProfile extends State<GetMyProfile>{

  UserRepository _userRepository;
  String userID;

  @override
  void initState(){
    _userRepository = UserRepository();
    super.initState();
  }

  Future<bool> getData() async {
    await _userRepository.getUser().then((snap) {
      userID = snap.uid;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(userID != null){
            return MyProfile(userID: userID);
          }
          else{
            return Center(
              child: Text('Loading...'),
            );
          }
        }
    );
  }
}