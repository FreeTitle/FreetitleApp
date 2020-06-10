import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/views/profile/profile_blog_list_view.dart';
import 'package:freetitle/views/my_view/title_view.dart';
import 'package:freetitle/views/my_view/user_card.dart';
import 'package:freetitle/views/profile/profile_mission_list_view.dart';


class MyInfo extends StatefulWidget {
  const MyInfo(
      {Key key,
        @required this.userID,
      }) : super(key: key);

  final String userID;

  @override
  State<StatefulWidget> createState() {
    return _MyInfoState();
  }
}

class _MyInfoState extends State<MyInfo> {

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