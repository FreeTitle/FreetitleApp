import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/reset_email/reset_email.dart';
import 'package:provider/provider.dart';

class ResetEmailScreen extends StatefulWidget {

  State<ResetEmailScreen> createState() => _ResetEmailScreenState();
}

class _ResetEmailScreenState extends State<ResetEmailScreen> {
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
//          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('修改邮箱')
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: BlocProvider<ModifyAccountBloc>(
          bloc: _modifyAccountBloc,
          child: ResetEmailForm(),
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