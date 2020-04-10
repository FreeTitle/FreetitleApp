import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/reset_password/reset_password.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {

  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ModifyAccountBloc _modifyAccountBloc;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _modifyAccountBloc = ModifyAccountBloc(
        userRepository: Provider.of<UserRepository>(context)
      );
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('修改密码', style: TextStyle(color: Colors.black),)
      ),
      body: Center(
        child: BlocProvider<ModifyAccountBloc>(
          bloc: _modifyAccountBloc,
          child: ResetPasswordForm(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _modifyAccountBloc.dispose();
    super.dispose();
  }
}