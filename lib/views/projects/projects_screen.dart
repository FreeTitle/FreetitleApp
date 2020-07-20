
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:freetitle/model/util/cloud_function_invoker.dart';

class ProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects"),
      ),
      body: Container(
        child: Center(
          child: FlatButton(
            onPressed: () async {
//              try{
//                var resp =  await CloudFunctionInvoker.cloudFunction({'collection': "blogs", "id": "HG8CoZgUQEjSbj9n5DVw", "field": "title"}, "dbCommonUpdateData");
//              } catch (e) {
//                print(e);
//              }
//
//              var user = await BlocProvider.of<AuthenticationBloc>(context).userRepository.getUser();
//              print(user.uid);
//              Firestore.instance.collection('posts').add({
//                "content": "Test content3",
//                "isNotReady": true,
//                "ownerID": "FvuBqE0jLHP69UYnIU0aZcPqny53",
//                "type": "single_photo",
//                "images": ["https://firebasestorage.googleapis.com/v0/b/freetitle.appspot.com/o/2020-04-24%2019%3A27%3A00.852338.png?alt=media&token=07e481fb-c7c3-4371-b992-4df720d5907c"]
//              });
//              Firestore.instance.collection('posts').add({
//                "content": "Test content4",
//                "isNotReady": true,
//                "ownerID": "FvuBqE0jLHP69UYnIU0aZcPqny53",
//                "type": "multiple_photo",
//                "images": ["https://firebasestorage.googleapis.com/v0/b/freetitle.appspot.com/o/2020-04-24%2019%3A27%3A00.852338.png?alt=media&token=07e481fb-c7c3-4371-b992-4df720d5907c", "https://firebasestorage.googleapis.com/v0/b/freetitle.appspot.com/o/2020-04-24%2019%3A27%3A00.852338.png?alt=media&token=07e481fb-c7c3-4371-b992-4df720d5907c"]
//              });
            },
            child: Text("OnCall"),
          ),
        ),
      ),
    );
  }
}