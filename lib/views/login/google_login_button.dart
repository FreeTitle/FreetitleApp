import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        icon: Icon(FontAwesomeIcons.google, color: Colors.white),
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).dispatch(
            LoginWithGooglePressed(),
          );
        },
        label: Text('使用谷歌账号登录', style: TextStyle(color: Colors.white)),

        color: Colors.redAccent,
      ),
    );
  }
}
