import 'package:flutter/material.dart';
import 'package:freetitle/views/chat/chat_list_view.dart';
import 'package:freetitle/views/profile/get_my_profile.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:freetitle/views/chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/login/login_screen.dart';
import 'package:freetitle/app_theme.dart';
//import 'package:freetitle/views/drawer/navi_drawer.dart';
import 'package:freetitle/views/home/home_screen.dart';
import 'package:freetitle/views/search/search.dart';

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
    ChatListView(),
    SearchView(),
    GetMyProfile(),
  ];

  onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
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
                canvasColor: Colors.white,
                // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                primaryColor: AppTheme.primary,
            ),
              child: new BottomNavigationBar(
                currentIndex: _pageIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('主页'),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      title: Text('私信'),
                  ),
//            BottomNavyBarItem(
//              icon: Icon(Icons.business),
//              title: Text('社区'),
//              activeColor: Colors.blue,
//            ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    title: Text('发现'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
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