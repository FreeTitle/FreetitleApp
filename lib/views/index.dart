import 'package:flutter/material.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:freetitle/views/chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/login/login_screen.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/drawer/navi_drawer.dart';
import 'package:freetitle/views/home/home_screen.dart';


class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}


class _IndexPageState extends State<IndexPage> {
  int _pageIndex = 0;
  final List<Widget> _children = [
    NaviDrawer(),
    Chat(),
    Profile(),
  ];

  onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
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
                    return NaviDrawer();
                  } else {
                    return LoginScreen();
                  }
                } else if (state is Authenticated) return _children[_pageIndex];
              }),
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                // sets the background color of the `BottomNavigationBar`
                canvasColor: Colors.white,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: AppTheme.primary,
            ),
              child: new BottomNavigationBar(
                currentIndex: _pageIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('主页'),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      title: Text('消息'),
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
                  ),
                ],
                onTap: onTabTapped,
              ),
          ),
      ),
    );

  }
}