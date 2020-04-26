import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/blog/blog_detail.dart';
import 'package:freetitle/views/notification.dart';
import 'package:freetitle/views/splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/simple_bloc_delegate.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';


void main(){
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  /**
   * _MyAppState is a private state widget
   */
  final UserRepository _userRepository = UserRepository();

  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authenticationBloc,
      child: Provider<UserRepository>.value(
        value: _userRepository,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FreeTitle',
          theme: ThemeData(
//            brightness: Brightness.light,
            primaryColor: AppTheme.white,
            accentColor: Colors.black,
              textTheme: TextTheme(
                headline: AppTheme.headline,
                body1: AppTheme.body1,
                body2: AppTheme.body2,
              )
          ),
          darkTheme: ThemeData(
            primaryColor: AppTheme.white,
            accentColor: Colors.black,
            textTheme: TextTheme(
              headline: AppTheme.headline,
              body1: AppTheme.body1,
              body2: AppTheme.body2,
            )
          ),
          home: SplashScreenPage(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}