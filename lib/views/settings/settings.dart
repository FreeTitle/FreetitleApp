import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/views/reset_email/reset_email.dart';
import 'package:freetitle/views/reset_password/reset_password.dart';

class SettingTab extends StatelessWidget{
  const SettingTab(
  {Key key,
    @required this.text,
    @required this.callback,
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

class SettingsPage extends StatefulWidget {


  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void getAccountSetting() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (context) {
        return AccountSettingPage();
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> settingsList = List();
    settingsList.add(SettingTab(text: "修改账号", callback: getAccountSetting,));
    settingsList.add(SettingTab(text: '推送设置', callback: () {}));
    settingsList.add(SettingTab(text: 'About Us', callback: () {}));
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
                  '登出',
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

class AccountSettingPage extends StatefulWidget {

  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage>{

  void getResetPassword() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (context) {
        return ResetPasswordScreen();
      }),
    );
  }

  void getResetEmail() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (context) {
        return ResetEmailScreen();
      }),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    List<Widget> settingsList = List();
    settingsList.add(SettingTab(text: "修改密码", callback: getResetPassword,));
    settingsList.add(SettingTab(text: '修改邮箱', callback: getResetEmail));
    
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
        title: Text('账号设置', style: TextStyle(color: Colors.black),),
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