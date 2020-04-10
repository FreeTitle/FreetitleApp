import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/reset_email/reset_email.dart';
import 'package:flushbar/flushbar.dart';

class ResetEmailForm extends StatefulWidget {
  State<ResetEmailForm> createState() => _ResetEmailForm();
}

class _ResetEmailForm extends State<ResetEmailForm> {
  final TextEditingController _emailController = TextEditingController();
  ModifyAccountBloc _modifyAccountBloc;

  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isResetEmailButtonEnabled(ModifyAccountState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _modifyAccountBloc = BlocProvider.of<ModifyAccountBloc>(context);
    _emailController.addListener(_onEmailChanged);
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
        if(state.failure_ERROR_EMAIL_ALREADY_IN_USE){
          returnDialog('此邮箱已被注册', '请重新输入', 5);
        }
        if(state.failure_ERROR_INVALID_CREDENTIAL){
          returnDialog('邮箱异常', '请重新输入', 5);
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
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Email',
                      ),
                      autocorrect: false,
                      autofocus: false,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isEmailValid ? 'Email格式不对' : null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    ResetEmailButton(
                      onPressed: isResetEmailButtonEnabled(state) ? _onFormSubmitted : null,
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
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _modifyAccountBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _modifyAccountBloc.dispatch(
      Submitted(
          password: '',
          email: _emailController.text,
          username: ''
      ),
    );
  }
}