import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/chat/chat_list_view.dart';
import 'package:freetitle/views/mission/mission_detail.dart';
import 'package:freetitle/views/my_view/my_view.dart';
import 'package:freetitle/views/my_view/team_management.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/login/login_screen.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/home/home_screen.dart';
import 'package:freetitle/views/search/search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freetitle/views/blog/blog_detail.dart';
import 'package:freetitle/views/notification.dart';
import 'package:badges/badges.dart';
import 'dart:io';
import 'package:fluwx/fluwx.dart';
import 'package:flutter/services.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}


class _IndexPageState extends State<IndexPage> {
  int _pageIndex = 0;
  List<Widget> _children;

  onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  Map<String, int> unreadMessages;
  StreamController<Map> streamController;

  String getNumUnread() {
    if(unreadMessages.values.length == 0){
      return '0';
    }
    return unreadMessages.values.reduce((sum, element) => sum+element).toString();
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState(){
    unreadMessages = Map();
    streamController = StreamController.broadcast();

    _children = [
      Home(),
      ChatListScreen(indexState: this, stream: streamController.stream,),
      SearchView(),
      MyView(),
    ];

    final wx = registerWxApi(appId: 'wx3f39d58fd1321045', doOnIOS: true, doOnAndroid: true, universalLink: 'https://freetitle.us/');

    if(Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: false
          )
      );
    }

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> incomeMessage) {
        print('onMessage called: $incomeMessage');
        var message;
        if(Platform.isAndroid){
          message = incomeMessage['data'];
        }
        else{
          message = incomeMessage;
        }

        if(message['blog'] != null){
          try{
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(message['title']),
                  content: Text(message['body']),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('好的'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('去看看'),
                      onPressed: () {
                        Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => BlogDetail(blogID: message['blog'],)
                            )
                        );
                      },
                    ),
                  ],
                );
              }
            );
          } catch(e) {
            print('Error open blog from notification due to: $e');
          }
        }
        else if (message['mission'] != null){
          try{
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(message['title']),
                    content: Text(message['body']),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('好的'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('去看看'),
                        onPressed: () {
                          Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => MissionDetail(missionID: message['mission'],)
                              )
                          );
                        },
                      ),
                    ],
                  );
                }
            );
          } catch(e) {
            print('Error open mission from notification due to: $e');
          }
        }
        else if (message['chat'] != null) {
          print('recieve message id ${message['chat']}');
          if(unreadMessages.containsKey(message['chat'])){
            setState(() {
              unreadMessages[message['chat']] += 1;
            });
            streamController.add(unreadMessages);
          }
          else{
            setState(() {
              unreadMessages[message['chat']] = 1;
            });
            streamController.add(unreadMessages);
          }

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
          if(unreadMessages.containsKey(message['chat'])){
            unreadMessages[message['chat']] += 1;
          }
          else{
            unreadMessages[message['chat']] = 1;
          }
          setState(() {

          });
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
          if(unreadMessages.containsKey(message['chat'])){
            unreadMessages[message['chat']] += 1;
          }
          else{
            unreadMessages[message['chat']] = 1;
          }
          setState(() {

          });
        }
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    }).onError((err) {
      print('request error: $err');
    });

    saveCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: BlocBuilder(
              bloc: BlocProvider.of<AuthenticationBloc>(context),
              builder: (BuildContext context, AuthenticationState state) {
                print("Index Page: ${BlocProvider.of<AuthenticationBloc>(context).state}, Page_index: $_pageIndex");
                if (state is Uninitialized || state is Unauthenticated) {
                  if (_pageIndex == 0) {
                    return Home();
                  } else {
                    return LoginScreen();
                  }
                } else if (state is Authenticated) {
                  return _children[_pageIndex];
                }
              }),
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Theme.of(context).primaryColorDark,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: Theme.of(context).highlightColor,
//                unselectedWidgetColor: Theme.of(context).accentColor,
            ),
              child: new BottomNavigationBar(
                currentIndex: _pageIndex,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Theme.of(context).accentColor,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Home', style: Theme.of(context).textTheme.bodyText1,),
                  ),
                  BottomNavigationBarItem(
                      icon: getNumUnread() != '0' ? Badge(
                        badgeContent: Text(getNumUnread(), style: TextStyle(color: Colors.white, fontSize: 12),),
                        child: Icon(Icons.chat),
                      ) :  Icon(Icons.chat),
                      title: Text('Messages', style: Theme.of(context).textTheme.bodyText1,),
                  ),
//            BottomNavyBarItem(
//              icon: Icon(Icons.business),
//              title: Text('社区'),
//              activeColor: Colors.blue,
//            ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    title: Text('Explore', style: Theme.of(context).textTheme.bodyText1,),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text('My', style: Theme.of(context).textTheme.bodyText1,),
                  ),
                ],
                onTap: onTabTapped,
              ),
          ),
      ),
    );

  }
}