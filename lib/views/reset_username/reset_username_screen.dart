import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/reset_username/reset_username.dart';
import 'package:provider/provider.dart';

class ResetUsernameScreen extends StatefulWidget {

  State<ResetUsernameScreen> createState() => _ResetUsernameScreenState();
}

class _ResetUsernameScreenState extends State<ResetUsernameScreen> {
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
          title: Text('修改用户名', style: TextStyle(color: Colors.black),)
      ),
      body: Center(
        child: BlocProvider<ModifyAccountBloc>(
          bloc: _modifyAccountBloc,
          child: ResetUsernameForm(),
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