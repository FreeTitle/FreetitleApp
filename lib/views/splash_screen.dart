import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:freetitle/views/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';

class SplashScreenPage extends StatefulWidget {

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  afterSplash(){
    BlocProvider.of<AuthenticationBloc>(context).dispatch(
      AppStarted(),
    );

    print("Splash Page: ${BlocProvider.of<AuthenticationBloc>(context).state}");
    return IndexPage();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: afterSplash(),
        title: new Text(
          '浮樂态度 FreeTitle\n艺术留学生的App',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        image: Image.asset('assets/logo.png'),
        loadingText: Text(
          "加载中...",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () {
          //广告区
        },
        loaderColor: Colors.red);
  }
}