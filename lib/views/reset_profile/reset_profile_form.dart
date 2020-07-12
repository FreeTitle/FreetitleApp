import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/bloc/authentication_bloc/bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/reset_profile/reset_profile.dart';
import 'package:flushbar/flushbar.dart';

class ResetProfileForm extends StatefulWidget {

  ResetProfileForm({Key key, this.username, this.statement, this.campus}) : super(key : key);

  final String username;
  final String statement;
  final String campus;

  State<ResetProfileForm> createState() => _ResetPUsernameForm();
}

class _ResetPUsernameForm extends State<ResetProfileForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();
  final TextEditingController _campusController = TextEditingController();
  UserRepository _userRepository;
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
    _usernameController.text = widget.username;
    _statementController.text = widget.statement;
    _campusController.text = widget.campus;
    _userRepository = UserRepository();
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
                        icon: Icon(Icons.verified_user, color: Theme.of(context).accentColor),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: '用户名',
                        labelStyle: Theme.of(context).textTheme.bodyText1
                      ),
                      autocorrect: false,
                      autofocus: false,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isUsernameValid ? '长度为3-15且由字母,数字组成' : null;
                      },
                    ),
                    SizedBox(height: 24.0),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _statementController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.edit, color: Theme.of(context).accentColor),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Statement',
                        labelStyle: Theme.of(context).textTheme.bodyText1
                      ),
                      autocorrect: false,
                      autofocus: false,
                      autovalidate: true,
                    ),
                    SizedBox(height: 24.0,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _campusController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.school, color: Theme.of(context).accentColor),
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        labelText: 'Campus',
                        labelStyle: Theme.of(context).textTheme.bodyText1
                      ),
                      autocorrect: false,
                      autofocus: false,
                      autovalidate: true,
                    ),
                    SizedBox(height: 24.0,),
                    ResetProfileButton(
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

  void _onFormSubmitted() async {
    String userID;
    await _userRepository.getUser().then((snap) {
      userID = snap.uid;
    });

    await Firestore.instance.collection('users').document(userID).updateData({
      'statement': _statementController.text,
    });

    await Firestore.instance.collection('users').document(userID).updateData({
      'campus': _campusController.text,
    });

    _modifyAccountBloc.dispatch(
      Submitted(
          username: _usernameController.text,
          password: '',
          email: ''
      ),
    );
  }
}