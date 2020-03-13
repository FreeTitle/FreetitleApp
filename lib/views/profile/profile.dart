import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:freetitle/views/profile/my_blog_list_view.dart';
import 'package:freetitle/views/profile/title_view.dart';
import 'package:freetitle/views/profile/user_card.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:freetitle/views/profile/my_mission_list_view.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/settings/settings.dart';

class Profile extends StatefulWidget {
  const Profile(
  {Key key,
    this.userID,
    this.isMyProfile,
    this.userName,
  }) : super(key: key);

  final String userID;
  final bool isMyProfile;
  final String userName;

  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {

  Widget buildProfileList(userData){

    final userID = widget.userID;

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
    profileWidget.add(MyBlogListView(ownerID: userID,));
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
//          top: MediaQuery.of(context).padding.top,
          bottom: 62 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: profileWidget,
        ),
      )
    );
  }

  Widget BuildAppBarIconButton(){
    if(widget.isMyProfile){
      return Padding(
        padding: EdgeInsets.only(right: 16),
        child: IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => SettingsPage(),
              ),
            );
          },
        ),
      );
    }
    else{
      return Padding(
        padding: EdgeInsets.only(right: 16),
        child: IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black,
          ),
          onPressed: () {

          },
        )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final userID = widget.userID;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.white,
          brightness: Brightness.light,
          title: Text(
            widget.isMyProfile ? '我' : widget.userName,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              color: Colors.black
            ),
          ),
          leading: widget.isMyProfile ? SizedBox() : IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            BuildAppBarIconButton(),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
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
        ),
//      body: buildProfileList(),
    );
  }
}