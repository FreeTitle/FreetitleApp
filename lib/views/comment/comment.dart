import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
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

  ScrollController _scrollController;
  UserRepository _userRepository;
  String userID;

  @override
  void initState(){
    _scrollController =  new ScrollController();
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap)=>{
      userID = snap.uid,
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List commentIDs = widget.commentIDs.reversed.toList();
    return Container(
      height: commentIDs.length*300.0,
      child: ListView.builder(
          controller: _scrollController,
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
                      bool isCurrentUserComment = false;
                      if(userID == comment['userID']){
                        isCurrentUserComment = true;
                      }
                      if(comment['level'] == 1)
                        return CommentBox(commentData: comment, isSubCommentPage: false, blogID: widget.blogID, commentID: commentIDs[index],isCurrentUserComment: isCurrentUserComment,);
                    }
                    else{
                      return PlaceHolderCard(
                        text: 'No comments yet',
                        height: 200.0,
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
    this.isCurrentUserComment,
  }) : super(key: key);

  final Map commentData;
  final bool isSubCommentPage;
  final String blogID;
  final String commentID;
  final bool isCurrentUserComment;

  Widget getContent(){
    final Map content = commentData['content'];
    if (content == null){
      return SizedBox(

      );
    }
    Image img;
    if (content['image'] != null){
//      print(content['image']);
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
                builder: (BuildContext context) => SubCommentPage(blogID: blogID, commentID: commentID,),
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

  Widget getDeleteButton(BuildContext context){
    if (isCurrentUserComment == null){
      return SizedBox(

      );
    }
    if(isCurrentUserComment){
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('是否删除评论？'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('不'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('是'),
                      onPressed: () async {
                        if(commentData['level'] == 1){
                          await Firestore.instance.collection('comments').document(commentID).delete().whenComplete(() async {
                            print("Level 1 Comment deleted");
                            // Level 1 comment
                            List subCommentIDs = List();
                            for(var id in commentData['replies']){
                              await Firestore.instance.collection('comments').document(id).get().then((snap) => {
                                subCommentIDs.add(snap.documentID),
                              });
                              await Firestore.instance.collection('comments').document(id).delete();
                            }

                            List comments;
                            List subcomments;
                            await Firestore.instance.collection('blogs').document(blogID).get().then((snap) => {
                              comments = snap.data['comments'],
                              subcomments = snap.data['subcomments'],
                            });
                            comments.remove(commentID);
                            for(var id in subCommentIDs){
                              subcomments.remove(id);
                            }
                            await Firestore.instance.collection('blogs').document(blogID).updateData({
                              'comments': comments,
                              'subcomments': subcomments
                            });

                          }).catchError((e) => {
                            print("Level 1 Comment deletion error ${e}"),
                          });
                        }
                        else if(commentData['level'] == 2){
                          // Level 2 comment
                          await Firestore.instance.collection('comments').document(commentID).updateData({
                            'content': {
                              'image': null,
                              'text': "(deleted)"
                            },
                          }).whenComplete(() {
                            print("Level 2 Comment deleted");
                          }).catchError((e) => {
                            print("Level 2 Comment deletion error ${e}"),
                          });
                        }
                        else if (commentData['level'] == 3){
                          // Level 3 comment
                          await Firestore.instance.collection('comments').document(commentID).updateData({
                            'content': {
                              'image': null,
                              'text': "(deleted)"
                            },
                          }).whenComplete(() {
                            print("Level 3 Comment deleted");
                          }).catchError((e) => {
                            print("Level 3 Comment deletion error ${e}"),
                          });
                        }
                        else{
                          print('This comment has some error');
                        }
                        Navigator.of(context).pop();
                      }
                    )
                  ],
                );
              }
          );
        }
      );
    }
    else{
      return SizedBox(

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(commentData == null){
      return SizedBox(

      );
    }
    return Center(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: getUser(),
                ),
                ButtonBar(
                  children: <Widget>[
                    getDeleteButton(context),
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

  ScrollController _scrollController;
  UserRepository _userRepository;
  String userID;

  @override
  void initState(){
    _scrollController =  new ScrollController();
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap) => {
      userID = snap.uid,
    });
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement liquid pull to refresh
    List commentIDs = widget.commentIDs.reversed.toList();
    return Scaffold(
        appBar: AppBar(
          title: Text("评论", style: TextStyle(color: Colors.black),),
          brightness: Brightness.light,
          backgroundColor: AppTheme.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.comment),
          backgroundColor: AppTheme.primary,
          onPressed: () {
            Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => CommentInputPage(blogID: widget.blogID, parentLevel: 0, parentID: widget.blogID, parentType: 'blog',)
                )
            );
          },
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: commentIDs.length*170.0,
              color: AppTheme.nearlyWhite,
              child: ListView.builder(
                  controller: _scrollController,
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
                              bool isCurrentUserComment = false;
                              if(userID == comment['userID']){
                                isCurrentUserComment = true;
                              }
                              if(comment['level'] == 1)
                                return CommentBox(commentData: comment, isSubCommentPage: false, commentID: commentIDs[index], blogID: widget.blogID, isCurrentUserComment: isCurrentUserComment,);
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
          ],
        )
    );
  }
}

class SubCommentPage extends StatefulWidget {
  const SubCommentPage(
  {Key key,
//    this.commentData,
    this.commentID,
    this.blogID,
  }) : super(key: key);

  final String commentID;
  final String blogID;
//  final commentData;

  @override
  _SubCommentPage createState() => _SubCommentPage();
}

class _SubCommentPage extends State<SubCommentPage>{

  ScrollController _scrollController;
  UserRepository _userRepository;
  String userID;
  Map commentData;
  List subCommentIDs;

  @override
  void initState(){
    _scrollController =  new ScrollController();
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap) => {
      userID = snap.uid,
    });

    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement liquid pull to refresh
    return Scaffold(
      appBar: AppBar(
        title: Text('回复'),
        backgroundColor: AppTheme.primary,
      ),
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('comments').document(widget.commentID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return new Text('Loading');
            default:
              if(snapshot.data.data != null){
                commentData = snapshot.data.data;
                subCommentIDs = commentData['replies'];
                subCommentIDs = subCommentIDs.reversed.toList();
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // Level 1 comment
                      CommentBox(commentData: commentData, isSubCommentPage: true, commentID: widget.commentID, blogID: widget.blogID,),
                      Container(
                        height: subCommentIDs.length*170.0,
                        color: AppTheme.nearlyWhite,
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: subCommentIDs.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
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
                                        bool isCurrentUserComment = false;
                                        if(userID == subcomment['userID']){
                                          isCurrentUserComment = true;
                                        }
                                        return Padding(
                                            padding: EdgeInsets.only(left: 16, right: 16),
                                            child: CommentBox(commentData: subcomment, isSubCommentPage: true, commentID: subCommentIDs[index], blogID: widget.blogID, isCurrentUserComment: isCurrentUserComment)
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
                );
              }
              else{
                return SizedBox(

                );
              }
          }
        },
      ),
    );
  }
}

