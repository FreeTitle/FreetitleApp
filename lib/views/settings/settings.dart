import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/bloc/authentication_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/views/reset_email/reset_email.dart';
import 'package:freetitle/views/reset_password/reset_password.dart';
import 'package:freetitle/views/settings/about_us.dart';

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
//      child: Material(
//          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow:  <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).primaryColorLight.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
//      ),
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
  void getAboutUsPage() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (context) {
        return AboutUsPage();
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> settingsList = List();
    settingsList.add(SettingTab(text: "修改账号", callback: getAccountSetting,));
    settingsList.add(SettingTab(text: '推送设置', callback: () {}));
    settingsList.add(SettingTab(text: 'About Us', callback: getAboutUsPage,));
    settingsList.add(SizedBox(height: 30,));
    settingsList.add(Padding(
      padding: EdgeInsets.all(8),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow:  <BoxShadow>[
              BoxShadow(
                  color:Theme.of(context).primaryColorLight.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0
              ),
            ],
          ),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('设置'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
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
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
//        backgroundColor: AppTheme.white,
        title: Text('账号设置'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
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