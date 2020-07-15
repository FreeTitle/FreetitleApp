import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:freetitle/views/my_view/team_management.dart';
import 'package:freetitle/views/my_view/title_view.dart';
import 'package:freetitle/views/my_view/user_card.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/settings/settings.dart';
import 'package:freetitle/views/my_view/my_info_tab.dart';

class MyView extends StatefulWidget {
  MyViewState createState() => MyViewState();
}

class MyViewState extends State<MyView> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: '基本信息'),
    Tab(text: '团队'),
  ];
  var userType;

  UserRepository _userRepository;
  String userID;
  Map userData;

  @override
  void initState(){
    _userRepository = UserRepository();
    super.initState();
  }

  Future<bool> getData() async {
    await _userRepository.getUser().then((snap) {
      userID = snap.uid;
    });

    await Firestore.instance.collection('users').document(userID).get().then((snap) {
      userData = snap.data;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(userData['isGroupAccount'] != null && userData['isGroupAccount'] == true){
            userType = "团队";
          }
          else{
            userType = "我的";
          }
          return DefaultTabController(
              length: 2,
              initialIndex: 1,
              child: Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(userType),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
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
                    ),
                  ],
                  bottom: TabBar(
                    labelColor: Theme.of(context).highlightColor,
                    unselectedLabelColor: Theme.of(context).accentColor,
                    indicatorColor: Theme.of(context).highlightColor,
                    tabs: myTabs,
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    MyInfo(userID: userID,),
                    userType == "团队" ?
                    TeamManagement(userID: userID,) : Container(),
                  ],
                ),
              )
          );
        }
        else {
          return Container(
            color: Theme.of(context).primaryColorDark,
            child: Center(
              child: Text('Loading...'),
            ),
          );
        }
      },
    );
  }
}

