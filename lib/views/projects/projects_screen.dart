
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
//                "content": "Test content7",
//                "isNotReady": true,
//                "createTime": Timestamp.now(),
//                "ownerID": "FvuBqE0jLHP69UYnIU0aZcPqny53",
//                "type": "single_photo",
//                "images": ["https://firebasestorage.googleapis.com/v0/b/freetitle.appspot.com/o/3AA9D988-CE20-4E4A-B8C5-ADEC734E63F0.jpegSat%20Feb%2015%202020%2016%3A57%3A16%20GMT-0600%20(CST).JPEG?alt=media&token=2305f6cb-0f7a-4722-b1db-f7f71fbc9e8a"]
//              });
//              Firestore.instance.collection('posts').add({
//                "content": "Test content8",
//                "isNotReady": true,
//                "createTime": Timestamp.now(),
//                "ownerID": "FvuBqE0jLHP69UYnIU0aZcPqny53",
//                "type": "multiple_photo",
//                "images": ["https://firebasestorage.googleapis.com/v0/b/freetitle.appspot.com/o/3AA9D988-CE20-4E4A-B8C5-ADEC734E63F0.jpegSat%20Feb%2015%202020%2016%3A57%3A16%20GMT-0600%20(CST).JPEG?alt=media&token=2305f6cb-0f7a-4722-b1db-f7f71fbc9e8a", "https://firebasestorage.googleapis.com/v0/b/freetitle.appspot.com/o/3AA9D988-CE20-4E4A-B8C5-ADEC734E63F0.jpegSat%20Feb%2015%202020%2016%3A57%3A16%20GMT-0600%20(CST).JPEG?alt=media&token=2305f6cb-0f7a-4722-b1db-f7f71fbc9e8a"]
//              });
            },
            child: Text("OnCall"),
          ),
        ),
      ),
    );
  }
}