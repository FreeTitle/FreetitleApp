import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/register/register.dart';
import 'package:flushbar/flushbar.dart';
import 'package:freetitle/model/util/util.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _usernameController.addListener(_onUsernameChanged);
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
      bloc: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSuccess) {
          saveCurrentUser();
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.failure_ERROR_WEAK_PASSWORD) {
          returnDialog('注册', '您输入的密码太弱，请重新输入', 5);
        }
        if (state.failure_ERROR_INVALID_EMAIL)
          returnDialog('注册', '您输入的Email格式不对，请重新输入', 5);
        if (state.failure_ERROR_EMAIL_ALREADY_IN_USE)
          returnDialog('注册', '您输入的Email已经注册，请重新输入或返回登录', 5);
        if (state.failure_ERROR_USERNAME_ALREADY_IN_USE)
          returnDialog('注册', '您输入的用户名已经注册，请重新输入或返回登录', 5);
      },
      child: BlocBuilder(
        bloc: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
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
                      return !state.isUsernameValid ? '长度为3-15且由-,_,字母,数字组成' : null;
                    },
                  ),
                  SizedBox(height: 24.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      labelText: '密码',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid
                          ? '请至少包含一个字母和一个数字且总长度不小于8'
                          : null;
                    },
                  ),
                  SizedBox(height: 24.0),
                  RegisterButton(
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onUsernameChanged() {
    _registerBloc.dispatch(
      UsernameChanged(username: _usernameController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.dispatch(
      Submitted(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }
}
