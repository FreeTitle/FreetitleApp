import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _loginBloc = LoginBloc(
        userRepository: Provider.of<UserRepository>(context),
      );
    });
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(title: Text('登录')),
      body: BlocProvider<LoginBloc>(
        bloc: _loginBloc,
        child: LoginForm(),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
