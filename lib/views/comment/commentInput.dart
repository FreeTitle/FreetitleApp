import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentInputPage extends StatefulWidget {
  const CommentInputPage(
  {Key key,
    this.blogID,
    this.parentLevel,
    this.parentID,
    this.parentType,
    this.targetID,
  }):super(key: key);

  final blogID;
  final parentLevel;
  final parentID;
  final parentType;
  final targetID;


  _CommentInputPage createState() => _CommentInputPage();
}

class _CommentInputPage extends State<CommentInputPage> {

  final textController = TextEditingController();

  File image;

  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  Widget buildButtonIcon(){
    if(image == null){
      return Icon(Icons.image);
    }
    else{
      return Container(
        height: 100,
        width: 100,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(80.0)),
          child: Image.file(image, fit: BoxFit.fill,),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    String blogID = widget.blogID;
    int parentLevel = widget.parentLevel;
    String parentID = widget.parentID;
    String parentType = widget.parentType;
    String targetID = widget.targetID;
    print(blogID);
    print(parentLevel);
    print(parentID);
    print(parentType);
    print(targetID);
    return Scaffold(
      appBar: AppBar(
        title: Text("发表评论", style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: ()  {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: AppTheme.white,
        brightness: Brightness.light,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: FlatButton(
              onPressed: () async {
                String text = textController.text;
                final Map data = new Map();
                data['_text'] = text;
                data['blogID'] = blogID;
                data['content'] = Map();
                data['content']['image'] = null;
                data['content']['text'] = text;
                data['level'] = parentLevel + 1;
                if(parentLevel == 3){
                  data['level'] = 3;
                }
                data['parentID'] = parentID;
                data['parentType'] = parentType;
                data['replies'] = List();
                data['targetID'] = null;
                if(data['level'] == 2 || data['level'] == 3){
                  data['targetID'] = targetID;
                }

                data['userID'] = null;
                final _userRepository = new UserRepository();
                await _userRepository.getUser().then((user) => {
                  data['userID'] = user.uid,
                });

                print("Input comment content ${data}");
                String commentID;
                String downLoadURL;
                if (image != null){
                  print('image');
                  final FirebaseStorage _storage = FirebaseStorage(storageBucket: "gs://freetitle.appspot.com");
                  String filePath = '${DateTime.now()}.png';
                  await _storage.ref().child(filePath).putFile(image).onComplete.then((snap) => {
                    print("Upload succeeds: ${snap}, ${snap.storageMetadata}, ${snap.ref.getDownloadURL()}"),
                    snap.ref.getDownloadURL().then((url) => {
                      downLoadURL = url
                    })
                  });

                  await _storage.ref().child(filePath).getDownloadURL().then((url) => {
                    downLoadURL = url,
                  });
                }

                await Firestore.instance.collection('comments').add({
                  '_text': data['_text'],
                  'blogID': data['blogID'],
                  'content': {'image': downLoadURL, 'text': text},
                  'level': data['level'],
                  'parentID': data['parentID'],
                  'parentType': data['parentType'],
                  'replies': data['replies'],
                  'targetID': data['targetID'],
                  'time': Timestamp.fromDate(DateTime.now()),
                  'userID': data['userID']
                }).then((snap) => {
                  print(snap.documentID),
                  commentID = snap.documentID,
                });

                // Level 1 comment setup
                if(data['level'] == 1 && data['blogID'] == data['parentID']){
                  // Set target blog's comments
                  List blogComments;
                  await Firestore.instance.collection('blogs').document(data['blogID']).get().then((snap) => {
                    print(snap.data['comments']),
                    blogComments = snap.data['comments'],
                  });
                  if(blogComments == null){
                    blogComments = List();
                  }
                  blogComments.add(commentID);
                  await Firestore.instance.collection('blogs').document(data['blogID']).updateData({
                    'comments': blogComments,
                  });
                } // Level 2 and level 3 comment setup
                else if(data['level'] == 2 || data['level'] == 3){

                  // Set target comment's replies
                  List commentReplies;
                  await Firestore.instance.collection('comments').document(data['parentID']).get().then((snap) => {
                    commentReplies = snap.data['replies'],
                  });
                  if(commentReplies == null){
                    commentReplies = List();
                  }
                  commentReplies.add(commentID);
                  await Firestore.instance.collection('comments').document(data['parentID']).updateData({
                    'replies': commentReplies,
                  });

                  // Set target blog's subcomments
                  List blogSubcomments;
                  await Firestore.instance.collection('blogs').document(data['blogID']).get().then((snap) => {
                    blogSubcomments = snap.data['subcomments']
                  });
                  if(blogSubcomments == null){
                    blogSubcomments = List();
                  }
                  blogSubcomments.add(commentID);
                  await Firestore.instance.collection('blogs').document(data['blogID']).updateData({
                    'subcomments': blogSubcomments
                  });
                }
                else{
                  print('level is wrong');
                }
                Navigator.pop(context);
              },
              child: Text('发表', style: TextStyle(color: Colors.black),),
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: buildButtonIcon(),
        onPressed: () async {
          var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
          print(_image);
          setState(() {
            image = _image;
          });
        },
      ),
      body: Card(
        color: Colors.white70,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '输入评论'
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}