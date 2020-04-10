import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/reset_username/reset_username.dart';
import 'package:flushbar/flushbar.dart';

class ResetUsernameForm extends StatefulWidget {
  State<ResetUsernameForm> createState() => _ResetPUsernameForm();
}

class _ResetPUsernameForm extends State<ResetUsernameForm> {
  final TextEditingController _usernameController = TextEditingController();
  ModifyAccountBloc _modifyAccountBloc;

  bool get isPopulated => _usernameController.text.isNotEmpty;

  bool isResetUsernameButtonEnabled(ModifyAccountState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _modifyAccountBloc = BlocProvider.of<ModifyAccountBloc>(context);
    _usernameController.addListener(_onUsernameChanged);
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
        if(state.failure_ERROR_USERNAME_ALREADY_IN_USE){
          returnDialog('用户名已被注册', '此用户名已被注册，请重新输入', 5);
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
                      keyboardType: TextInputType.text,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.verified_user),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: '用户名',
                      ),
                      autocorrect: false,
                      autofocus: false,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isUsernameValid ? '长度为3-15且由字母,数字组成' : null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    ResetUsernameButton(
                      onPressed: isResetUsernameButtonEnabled(state) ? _onFormSubmitted : null,
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
    _usernameController.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    _modifyAccountBloc.dispatch(
      UsernameChanged(username: _usernameController.text),
    );
  }

  void _onFormSubmitted() {
    _modifyAccountBloc.dispatch(
      Submitted(
          username: _usernameController.text,
          password: '',
          email: ''
      ),
    );
  }
}