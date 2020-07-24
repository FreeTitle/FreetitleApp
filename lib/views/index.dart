import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util/util.dart';
import 'package:freetitle/views/messages/messages_screen.dart';
import 'package:freetitle/views/projects/projects_screen.dart';
import 'package:freetitle/views/my_view/my_view.dart';
import 'package:freetitle/views/my_view/team_management.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/bloc/authentication_bloc/bloc.dart';
import 'package:freetitle/views/login/login_screen.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/home/home_screen.dart';
import 'package:freetitle/views/search/search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState(){
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
                return IndexedStack(
                  children: <Widget>[
                    HomeScreen(),
                    state is Authenticated ? ProjectsScreen() : LoginScreen(),
                    state is Authenticated ? MessagesScreen() : LoginScreen(),
                    state is Authenticated ? MyView() : LoginScreen(),
                  ],
                  index: _pageIndex,
                );
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
                    icon: Icon(Icons.work),
                    title: Text('Projects', style: Theme.of(context).textTheme.bodyText1,),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    title: Text('Messages', style: Theme.of(context).textTheme.bodyText1,),
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