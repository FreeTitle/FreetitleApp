import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/reset_profile/reset_profile.dart';
import 'package:provider/provider.dart';

class ResetProfileScreen extends StatefulWidget {
  ResetProfileScreen({Key key, this.username, this.statement, this.label, this.campus}) : super(key : key);

  final String username;
  final String statement;
  final String label;
  final String campus;

  State<ResetProfileScreen> createState() => _ResetProfileScreenState();
}

class _ResetProfileScreenState extends State<ResetProfileScreen> {
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
          title: Text('修改账户')
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: BlocProvider<ModifyAccountBloc>(
          bloc: _modifyAccountBloc,
          child: ResetProfileForm(username: widget.username, statement: widget.statement, campus: widget.campus,),
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