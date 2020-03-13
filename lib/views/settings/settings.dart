import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingTab extends StatelessWidget{
  const SettingTab(
  {Key key,
    this.text,
    this.callback,
    this.textColor,
  }) : super(key: key);

  final String text;
  final textColor;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                callback();
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                      color: textColor
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}

class SettingsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    List<Widget> settingsList = List();
    settingsList.add(SettingTab(text: '修改密码', textColor: Colors.black, callback: null,));
    settingsList.add(SettingTab(text: '修改邮箱', textColor: Colors.black, callback: null,));
    settingsList.add(SettingTab(text: '修改用户名', textColor: Colors.black, callback: null,));
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
        backgroundColor: AppTheme.primary,
        title: Text('设置', style: TextStyle(color: Colors.white),),
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