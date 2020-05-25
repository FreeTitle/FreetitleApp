import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/authentication_bloc/bloc.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:freetitle/model/util.dart';

class LoginForm extends StatefulWidget {

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
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
      bloc: _loginBloc,
      listener: (BuildContext context, LoginState state) {
        if (state.Failure_ERROR_INVALID_EMAIL) {
            returnDialog('登录', '您的Email格式有误，请重新输入', 5);
        }
        if(state.Failure_ERROR_WRONG_PASSWORD)
          returnDialog('登录', '您输入的账号或密码错误，请重新输入', 5);
        if(state.Failure_ERROR_USER_NOT_FOUND)
          returnDialog('登录', '您输入的账号或密码错误，请重新输入', 5);
        if(state.Failure_ERROR_USER_DISABLED)
          returnDialog('登录', '您的账号已被禁用，请联系管理员', 5);
        if(state.Failure_ERROR_TOO_MANY_REQUESTS)
          returnDialog('登录', '您已发送过多请求，请稍后再试', 5);
        if(state.Failure_ERROR_OPERATION_NOT_ALLOWED)
          returnDialog('登录', '会员登录通道已关闭，请联系管理员', 5);
        if(state.isGoogleFailure)
          returnDialog('登录', '谷歌登录失败,请重试', 5);
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          saveCurrentUser();
          if(Navigator.canPop(context)){
            Navigator.of(context).pop();
          }
        }
      },
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Hero(
                        tag: 'hero',
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 48.0,
                          child: Image.asset('assets/logo.png'),
                        ),
                      ),
                      SizedBox(height: 48.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.email, color: Theme.of(context).accentColor),
                          labelText: 'Email',
                          labelStyle: Theme.of(context).textTheme.bodyText1,
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        ),
                        autovalidate: true,
                        autocorrect: false,
                        validator: (_) {
                          return !state.isEmailValid ? 'Email格式不正确' : null;
                        },
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          labelText: '密码',
                          labelStyle: Theme.of(context).textTheme.bodyText1
                        ),
                        obscureText: true,
                        autovalidate: true,
                        autocorrect: false,
                        validator: (_) {
                          return !state.isPasswordValid ? '密码错误' : null;
                        },
                      ),
                      SizedBox(height: 24.0),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            LoginButton(
                              onPressed: isLoginButtonEnabled(state)
                                  ? _onFormSubmitted
                                  : null,
                            ),
                            GoogleLoginButton(),
                            CreateAccountButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Navigator.canPop(context) ? Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top-20,),
                    child: SizedBox(
                      width: AppBar().preferredSize.height-8,
                      height: AppBar().preferredSize.height-8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
//                          child: Container(
//                            decoration: new BoxDecoration(
//                              shape: BoxShape.circle,// You can use like this way or like the below line
//                              //borderRadius: new BorderRadius.circular(30.0),
//                              color: AppTheme.grey.withOpacity(0.5),
//                            ),
//                            child: Icon(
//                              Icons.arrow_back_ios,
//                              color: AppTheme.nearlyWhite,
//                            ),
//                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                          ),
                          onTap: () {
                            if(Navigator.canPop(context)){
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                ],
              )
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.dispatch(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
