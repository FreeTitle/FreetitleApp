import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/views/reset_email/reset_email.dart';
import 'package:freetitle/views/reset_password/reset_password.dart';
import 'package:freetitle/views/reset_username/reset_username.dart';

//class SettingTab extends StatelessWidget{
//  const SettingTab(
//  {Key key,
//    this.text,
//    this.callback,
//    this.textColor,
//  }) : super(key: key);
//
//  final String text;
//  final textColor;
//  final VoidCallback callback;
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.all(8),
//      child: Container(
//          height: 50,
//          decoration: BoxDecoration(
//            color: AppTheme.white,
//            borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(8.0),
//                bottomLeft: Radius.circular(8.0),
//                bottomRight: Radius.circular(8.0),
//                topRight: Radius.circular(8.0)),
//            boxShadow:  <BoxShadow>[
//              BoxShadow(
//                  color: AppTheme.grey.withOpacity(0.2),
//                  offset: Offset(1.1, 1.1),
//                  blurRadius: 10.0
//              ),
//            ],
//          ),
//          child: Material(
//            child: InkWell(
//              onTap: () {
//                callback();
//                Navigator.pop(context);
//              },
//              child: Center(
//                child: Text(
//                  text,
//                  style: TextStyle(
//                      color: textColor
//                  ),
//                ),
//              ),
//            ),
//          )
//      ),
//    );
//  }
//}

class SettingsPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    List<Widget> settingsList = List();
    settingsList.add(Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
            boxShadow:  <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0
              ),
            ],
          ),
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return ResetPasswordScreen();
                  }),
                );
              },
              child: Center(
                child: Text(
                  '修改密码',
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
            ),
          )
      ),
    ));
    settingsList.add(Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
            boxShadow:  <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0
              ),
            ],
          ),
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return ResetEmailScreen();
                  }),
                );
              },
              child: Center(
                child: Text(
                  '修改邮箱',
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
            ),
          )
      ),
    ));
    settingsList.add(Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
            boxShadow:  <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0
              ),
            ],
          ),
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return ResetUsernameScreen();
                  }),
                );
              },
              child: Center(
                child: Text(
                  '修改用户名',
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
            ),
          )
      ),
    ));
    settingsList.add(SizedBox(height: 30,));
    settingsList.add(Padding(
      padding: EdgeInsets.all(8),
      child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0)),
            boxShadow:  <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0
              ),
            ],
          ),
          child: Material(
            child: InkWell(
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context).dispatch(
                  LoggedOut(),
                );
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  'Sign out',
                  style: TextStyle(
                      color: Colors.red
                  ),
                ),
              ),
            ),
          )
      ),
    ));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppTheme.white,
        title: Text('设置', style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: ListView.builder(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: settingsList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index){
              return settingsList[index];
            }
        ),
      ),
    );
  }
}