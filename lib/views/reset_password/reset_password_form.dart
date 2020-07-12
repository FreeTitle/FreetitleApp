import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/bloc/authentication_bloc/bloc.dart';
import 'package:freetitle/views/reset_password/reset_password.dart';
import 'package:flushbar/flushbar.dart';

class ResetPasswordForm extends StatefulWidget {
  State<ResetPasswordForm> createState() => _ResetPasswordForm();
}

class _ResetPasswordForm extends State<ResetPasswordForm> {
  final TextEditingController _passwordController = TextEditingController();
  ModifyAccountBloc _modifyAccountBloc;

  bool get isPopulated => _passwordController.text.isNotEmpty;

  bool isResetPasswordButtonEnabled(ModifyAccountState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }
  
  @override
  void initState() {
    super.initState();
    _modifyAccountBloc = BlocProvider.of<ModifyAccountBloc>(context);
    _passwordController.addListener(_onPasswordChanged);
  }

  void returnDialog(String title, String message, int time) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      showProgressIndicator: true,
      backgroundGradient: LinearGradient(
        colors: [Colors.blue, Colors.teal],
      ),
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
          color: Colors.blue[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      flushbarStyle: FlushbarStyle.FLOATING,
      title: title,
      message: message,
      duration: Duration(seconds: time),
    )..show(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _modifyAccountBloc,
      listener: (BuildContext context, ModifyAccountState state) {
        if(state.isSuccess){
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          Navigator.of(context).pop();
        }
        if(state.failure_ERROR_WEAK_PASSWORD){
          returnDialog('重置密码', '您输入的密码太弱，请重新输入', 5);
        }
        if(state.failure_ERROR_REQUIRES_RECENT_LOGIN){
          returnDialog('重置密码', '账号异常，请重新登录', 5);
        }
      },
      child: BlocBuilder(
        bloc: _modifyAccountBloc,
        builder: (BuildContext context, ModifyAccountState state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Theme.of(context).accentColor),
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      labelText: '密码',
                      labelStyle: Theme.of(context).textTheme.bodyText1
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid
                          ? '请至少包含一个字母和一个数字且总长度不小于8，不大于20'
                          : null;
                    },
                  ),
                  SizedBox(height: 24.0),
                  ResetPasswordButton(
                    onPressed: isResetPasswordButtonEnabled(state) ? _onFormSubmitted : null,
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }


  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    _modifyAccountBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _modifyAccountBloc.dispatch(
      Submitted(
        password: _passwordController.text,
        username: '',
        email: ''
      ),
    );
  }
}