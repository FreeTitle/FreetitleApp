import 'dart:io';

import 'package:flutter/material.dart';
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

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print("onBackgroundMessage: $message");
    //_showBigPictureNotification(message);
    return Future<void>.value();
  }

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);

    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: true));

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );

    firebaseMessaging.getToken().then((token){
      print('FCM Token: $token');
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
    return BlocProvider(
      bloc: _authenticationBloc,
      child: Provider<UserRepository>.value(
        value: _userRepository,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FreeTitle',
          theme: ThemeData(
//          primarySwatch: Colors.blue,
            accentColor: Colors.blue,
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