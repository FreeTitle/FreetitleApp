import 'package:flutter/material.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:freetitle/views/chat/chat.dart';
import 'package:freetitle/views/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/login/login_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}


class _IndexPageState extends State<IndexPage> {
  int _pageIndex = 0;
  final List<Widget> _children = [
    Home(),
    Profile(),
    Chat()
  ];

  onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              } else if (state is Authenticated) return _children[_pageIndex];
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('主页'),
//              activeColor: Colors.grey,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text('日历'),
//                activeColor: Colors.grey
            ),
//            BottomNavyBarItem(
//              icon: Icon(Icons.chat),
//              title: Text('消息'),
//              activeColor: Colors.blue,
//            ),
//            BottomNavyBarItem(
//              icon: Icon(Icons.business),
//              title: Text('社区'),
//              activeColor: Colors.blue,
//            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('我的'),
//              activeColor: Colors.grey,
            ),
          ],
          onTap: onTabTapped,
        ));
  }
}