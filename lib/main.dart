import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/bloc/authentication_bloc/bloc.dart';
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
          color: Theme.of(context).primaryColorDark,
          debugShowCheckedModeBanner: false,
          title: 'FreeTitle',
          theme: ThemeData(
//            brightness: Brightness.light,
              primaryColor: AppTheme.nearlyWhite,
              accentColor: Colors.black,
              highlightColor: Color(0xFF00BCD4),
              primaryColorLight: AppTheme.grey,
              primaryColorDark: AppTheme.white,
              appBarTheme: AppBarTheme(
                color: Colors.white,
              ),
              textTheme: TextTheme(
                headline1: TextStyle( // h5 -> headline
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 0.27,
                  color: Colors.black,
                ),
                headline2: TextStyle( // h6 -> title
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.18,
                  color: Colors.black,
                ),
                bodyText1: TextStyle( // body2 -> body1
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  letterSpacing: -0.05,
                  color: Colors.black,
                ),
                // Bold text
                bodyText2: TextStyle( // body2 -> body1
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: -0.05,
                  color: Colors.black,
                ),
                // Italic text
                subtitle1: TextStyle( // body2 -> body1
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  letterSpacing: -0.05,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              )
          ),
          darkTheme: ThemeData(
            primaryColor: Color(0xFF303030),
            accentColor: Colors.white,
            primaryColorDark: Colors.black,
            primaryColorLight: AppTheme.dark_grey,
            highlightColor: Color(0xFF00BCD4),
            appBarTheme: AppBarTheme(
              color: Colors.black,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            dividerColor: Colors.white,
            fontFamily: AppTheme.fontName,
            textTheme: TextTheme(
              headline1: TextStyle( // h5 -> headline
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 0.27,
                color: Colors.white,
              ),
              headline2: TextStyle( // h6 -> title
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.18,
                color: Colors.white,
              ),
              bodyText1: TextStyle( // body2 -> body1
                fontWeight: FontWeight.w400,
                fontSize: 16,
                letterSpacing: -0.05,
                color: Colors.white,
              ),
              // Bold text
              bodyText2: TextStyle( // body2 -> body1
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: -0.05,
                color: Colors.white,
              ),
              // Italic text
              subtitle1: TextStyle( // body2 -> body1
                fontWeight: FontWeight.w400,
                fontSize: 16,
                letterSpacing: -0.05,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
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