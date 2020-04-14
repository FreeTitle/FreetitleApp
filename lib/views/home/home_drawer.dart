import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/home/coin.dart';
import 'package:freetitle/views/login/login.dart';

class HomeDrawer extends StatefulWidget {

  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthenticationBloc>(context),
      builder: (BuildContext context, AuthenticationState state) {
        if (state is Uninitialized || state is Unauthenticated) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Welcome to FreeTitle', style: AppTheme.headline,),
                      SizedBox(height: 40,),
                      InkWell(
                        onTap: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => LoginScreen(),
                            )
                          );
                        },
                        child: Text('请登录', style:
                          TextStyle( // h5 -> headline
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 0.27,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                            color: AppTheme.darkerText,
                          ),
                        ),
                      )
                    ],
                  )
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                ),
              )
            ],
          );
        }
        else {
          return ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Welcome to FreeTitle', style: AppTheme.headline,),
                      SizedBox(height: 50,),
                      Text('快捷操作')
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Text('金币'),
                    SizedBox(width: 10,),
                    Icon(Icons.stars, color: Color(0xffd3a641),),
                  ],
                ),
                onTap: () {
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => CoinPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Text('上次阅读到'),
                    SizedBox(width: 10,),
                    Icon(Icons.book),
                  ],
                ),
                onTap: () {

                },
              )
            ],
          );
        }
      },
    );
  }
}