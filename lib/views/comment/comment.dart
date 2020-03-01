import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/comment/commentInput.dart';

class CommentBottom extends StatefulWidget {

  const CommentBottom(
      {Key key,
        this.commentIDs,
        this.blogID,
      }): super(key: key);

  final String blogID;
  final List<String> commentIDs;

  @override
  _CommentBottom createState() => _CommentBottom();
}

class _CommentBottom extends State<CommentBottom>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List commentIDs = widget.commentIDs.reversed.toList();
    return Container(
      height: commentIDs.length*200.0,
      child: ListView.builder(
          itemCount: commentIDs.length,
          padding: const EdgeInsets.only(top: 8),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index){
            return StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance.collection('comments').document(commentIDs[index]).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                    return new Text('Loading');
                  default:
                    if(snapshot.data.data != null){
                      final comment = snapshot.data.data;
                      if(comment['level'] == 1)
                        return CommentBox(commentData: comment, isSubCommentPage: false, blogID: widget.blogID, commentID: commentIDs[index],);
                    }
                    else{
                      return SizedBox(

                      );
                    }
                }
              },
            );
          }),
    );
  }
}

class CommentBox extends StatelessWidget {

  const CommentBox(
  {Key key,
    this.commentData,
    this.isSubCommentPage,
    this.blogID,
    this.commentID,
  }) : super(key: key);

  final Map commentData;
  final bool isSubCommentPage;
  final String blogID;
  final String commentID;

  Widget getContent(){
    final Map content = commentData['content'];
    if (content == null){
      return SizedBox(

      );
    }
    Image img;
    if (content['image'] != null){
      print(content['image']);
      img = Image.network(content['image']);
    }
    if (img != null){
      return Column(
        children: <Widget>[
          img,
          Text(content['text']),
        ],
      );
    }
    else{
      return Text(content['text']);
    }
  }

  Widget getUser(){
    UserRepository _userRepository = new UserRepository();
    return _userRepository.getUserWidget(commentData['userID']);
  }

  Widget getSubComment(BuildContext context){
    // Subcomment button only appears when it's not in subcomment page
    if(commentData['replies'].length != 0 && commentData['level'] == 1 && !isSubCommentPage){
      return InkWell(
        child: Text("共${commentData['replies'].length}条回复>>", style: AppTheme.link,),
        splashColor: Colors.grey,
        onTap: (){
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => SubCommentPage(commentData: commentData, blogID: blogID, commentID: commentID,),
              )
          );
        },
      );
    }
    else{
      return SizedBox(
        height: 0,
      );
    }
  }

  Widget getTarget(){
    if(commentData['level'] == 3){
      assert (commentData['targetID'] != null);
      return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('comments').document(commentData['targetID']).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return new Text('Loading');
            default:
              if(snapshot.hasData){
                final subcomment = snapshot.data.data;
                return StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance.collection('users').document(subcomment['userID']).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                        return new Text('Loading');
                      default:
                        if(snapshot.hasData){
                          final user = snapshot.data.data;
                          return Text('回复@${user['displayName']}');
                        }
                        else{
                          return new Text("Something is wrong with firebase");
                        }
                    }
                  },
                );
              }
              else{
                return new Text("Something is wrong with firebase");
              }
          }
        },
      );
    }
    else{
      return SizedBox(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getUser(),
                ButtonBar(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) {
                              if (commentData['level']  == 1)
                                return CommentInputPage(blogID: blogID, parentLevel: commentData['level'], parentID: commentID, parentType: 'comment', targetID: commentID,);
                              else
                                return CommentInputPage(blogID: blogID, parentLevel: commentData['level'], parentID: commentData['parentID'], parentType: 'comment', targetID: commentID,);
                            }
                          )
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 24, right: 24),
              child: getTarget(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: getContent(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              child: getSubComment(context),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, bottom: 16),
              child: Text(commentData['time'].toDate().toString().split('.')[0], style: AppTheme.body2,),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentPage extends StatefulWidget{
  const CommentPage(
      {Key key,
        this.commentIDs,
        this.blogID,
      }): super(key: key);

  final List<String> commentIDs;
  final String blogID;

  @override
  _CommentPage createState() => _CommentPage();
}

class _CommentPage extends State<CommentPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List commentIDs = widget.commentIDs.reversed.toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("评论"),
          backgroundColor: AppTheme.primary,
        ),
        body: Container(
          height: commentIDs.length*200.0,
          color: AppTheme.nearlyWhite,
          child: ListView.builder(
              itemCount: commentIDs.length,
              padding: const EdgeInsets.only(top: 8),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index){
                return StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance.collection('comments').document(commentIDs[index]).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                        return new Text('Loading');
                      default:
                        if(snapshot.data.data != null){
                          final comment = snapshot.data.data;
                          if(comment['level'] == 1)
                            return CommentBox(commentData: comment, isSubCommentPage: false, commentID: commentIDs[index], blogID: widget.blogID);
                        }
                        else{
                          return SizedBox(

                          );
                        }
                    }
                  },
                );
              }),
        ),
    );
  }
}

class SubCommentPage extends StatefulWidget {
  const SubCommentPage(
  {Key key,
    this.commentData,
    this.commentID,
    this.blogID,
  }) : super(key: key);

  final String commentID;
  final String blogID;
  final commentData;

  @override
  _SubCommentPage createState() => _SubCommentPage();
}

class _SubCommentPage extends State<SubCommentPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List subCommentIDs = widget.commentData['replies'];
    subCommentIDs = subCommentIDs.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('回复'),
        backgroundColor: AppTheme.primary,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // Level 1 comment
            CommentBox(commentData: widget.commentData, isSubCommentPage: true, commentID: widget.commentID, blogID: widget.blogID,),
            Container(
              height: subCommentIDs.length*150.0,
              color: AppTheme.nearlyWhite,
              child: ListView.builder(
                  itemCount: subCommentIDs.length,
                  padding: const EdgeInsets.only(top: 8),
                  itemBuilder: (BuildContext context, int index){
                    return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('comments').document(subCommentIDs[index]).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch(snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return new Text('Loading');
                          default:
                            if(snapshot.hasData){
                              final subcomment = snapshot.data.data;
                              return Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: CommentBox(commentData: subcomment, isSubCommentPage: true, commentID: subCommentIDs[index], blogID: widget.blogID,)
                              );
                            }
                            else{
                              return new Text("Something is wrong with firebase");
                            }
                        }
                      },
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//  String blogID;
//  Map content;
//  int level;
//  String parentID;
//  String parentType;
//  List replies;
//  String targetID;
//  DateTime time;
//  String userID;


//      blogID = comment['blogID'],
//      content = comment['content'],
//      level = comment['level'],
//      parentID = comment['parentID'],
//      parentType = comment['parentType'],
//      replies = comment['replies'],
//      targetID = comment['targetID'],
//      time = comment['time'],
//      userID = comment['userID'],
