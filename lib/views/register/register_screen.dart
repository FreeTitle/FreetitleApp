import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/register/register.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {

  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterBloc _registerBloc;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _registerBloc = RegisterBloc(
        userRepository: Provider.of<UserRepository>(context),
      );
    });
    return Scaffold(
      appBar: AppBar(title: Text('注册')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          bloc: _registerBloc,
          child: RegisterForm(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registerBloc.dispose();
    super.dispose();
  }
}
