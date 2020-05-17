import 'package:flutter/material.dart';

class ResetPasswordButton extends StatelessWidget {
  final VoidCallback _onPressed;

  ResetPasswordButton({Key key, VoidCallback onPressed})
    : _onPressed = onPressed,
      super(key : key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
//      color: Theme.of(context).accentColor,
      child: Text('重置密码', style: Theme.of(context).textTheme.bodyText1,),
    );
  }
}