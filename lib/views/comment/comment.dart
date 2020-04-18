import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/comment/commentInput.dart';
import 'package:freetitle/views/login/login.dart';

class CommentBottom extends StatefulWidget {

  const CommentBottom(
      {Key key,
        @required this.commentIDs,
        @required this.pageID,
        @required this.pageType,
      }): super(key: key);

  final String pageID;
  final List<String> commentIDs;
  final String pageType;

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
    _userRepository.getUser().then((snap) {
      if(snap != null)
        userID = snap.uid;
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget>buildComments(){
    List commentIDs = widget.commentIDs.reversed.toList();
    List<Widget> commentList = List();
    for(var index = 0; index < commentIDs.length;index++){
      commentList.add(
          StreamBuilder<DocumentSnapshot>(
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
                      return CommentBox(commentData: comment, isSubCommentPage: false, pageID: widget.pageID, commentID: commentIDs[index], isCurrentUserComment: isCurrentUserComment, pageType: widget.pageType,);
                  }
                  else{
                    return PlaceHolderCard(
                      text: 'No comments yet',
                      height: 200.0,
                    );
                  }
              }
            },
          )
      );
    }
    return commentList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildComments(),
    );
  }
}

class CommentBox extends StatefulWidget {

  const CommentBox({Key key,
    @required this.commentData,
    @required this.isSubCommentPage,
    @required this.pageID,
    @required this.pageType,
    @required this.commentID,
    this.isCurrentUserComment,
  }) : super(key: key);

  final Map commentData;
  final bool isSubCommentPage;
  final String pageID;
  final String commentID;
  final bool isCurrentUserComment;
  final String pageType;

  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox>{

  bool liked = false;
  String userID;

  Widget buildContent(){
    final Map content = widget.commentData['content'];
    if (content == null){
      return SizedBox(

      );
    }
    Image img;
    if (content['image'] != null){
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

  Widget buildUser(){
    UserRepository _userRepository = new UserRepository();
    return _userRepository.getUserWidget(widget.commentData['userID'], color: AppTheme.white);
  }

  Widget buildSubComment(BuildContext context){
    final commentData = widget.commentData;
    // Subcomment button only appears when it's not in subcomment page
    if(commentData['replies'].length != 0 && commentData['level'] == 1 && !widget.isSubCommentPage){
      return InkWell(
        child: Text("共${commentData['replies'].length}条回复>>", style: AppTheme.link,),
        splashColor: Colors.grey,
        onTap: (){
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => SubCommentPage(pageID: widget.pageID, commentID: widget.commentID, pageType: widget.pageType,),
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
    final commentData = widget.commentData;
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

  Widget buildDeleteButton(BuildContext context){
    if (widget.isCurrentUserComment == null){
      return SizedBox(

      );
    }
    if(widget.isCurrentUserComment){
      final commentData = widget.commentData;
      final pageType = widget.pageType;
      final commentID =  widget.commentID;
      final pageID = widget.pageID;
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
                      child: Text('否'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      color: Colors.red,
                      child: Text('是'),
                      onPressed: () async {
                        if(commentData['level'] == 1){
                          await Firestore.instance.collection('comments').document(commentID).delete().whenComplete(() async {
                            print("Level 1 Comment deleted");
                            // Level 1 comment
                            List subCommentIDs = List();
                            for(var id in commentData['replies']){
                              await Firestore.instance.collection('comments').document(id).get().then((snap) {
                                subCommentIDs.add(snap.documentID);
                              });
                              await Firestore.instance.collection('comments').document(id).delete();
                            }

                            List comments;
                            List subcomments;

                            if(pageType == 'blog') {
                              await Firestore.instance.collection('blogs').document(pageID).get().then((snap) {
                                comments = snap.data['comments'];
                                subcomments = snap.data['subcomments'];
                              });
                              comments.remove(commentID);
                              for(var id in subCommentIDs){
                                subcomments.remove(id);
                              }
                              await Firestore.instance.collection('blogs').document(pageID).updateData({
                                'comments': comments,
                                'subcomments': subcomments
                              });
                            }
                            else if(pageType == 'mission') {
                              await Firestore.instance.collection('missions').document(pageID).get().then((snap) {
                                comments = snap.data['comments'];
                                subcomments = snap.data['subcomments'];
                              });
                              comments.remove(commentID);
                              for(var id in subCommentIDs){
                                subcomments.remove(id);
                              }
                              await Firestore.instance.collection('missions').document(pageID).updateData({
                                'comments': comments,
                                'subcomments': subcomments
                              });
                            }


                          }).catchError((e) {
                            print("Level 1 Comment deletion error $e");
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
                          }).catchError((e) {
                            print("Level 2 Comment deletion error $e");
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
                          }).catchError((e) {
                            print("Level 3 Comment deletion error $e");
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

  Future<bool> getLke() async {
    UserRepository _userRepository = UserRepository();

    var user = await _userRepository.getUser();
    userID = user.uid;

    if(widget.commentData['upvotedBy'].contains(userID)){
      liked = true;
    }else {
      liked = false;
    }

    return true;
  }

  Widget buildLikeButton() {
    return FutureBuilder<bool>(
      future: getLke(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return IconButton(
            icon: liked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: () {
              if (userID==null){
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                );
                return;
              }

              // toggle like
              liked = !liked;
              setState(() {

              });

              // modify comment document in database
              Firestore.instance.collection('comments').document(widget.commentID).updateData({
                "likes": FieldValue.increment((liked ? (1) : (-1))),
              }).whenComplete(() {
                print('succeeded');
              }).catchError((e) {
                print('get error $e');
              });

              // toggle user like status in database
              if(liked){
                Firestore.instance.collection('comments').document(widget.commentID).updateData({
                  "upvotedBy": FieldValue.arrayUnion([userID]),
                }).whenComplete(() {
                  print('like  succeeds');
                }).catchError((e) {
                  print('like gets error $e');
                });
              }
              else{
                Firestore.instance.collection('comments').document(widget.commentID).updateData({
                  "upvotedBy": FieldValue.arrayRemove([userID]),
                }).whenComplete(() {
                  print('unlike  succeeds');
                }).catchError((e) {
                  print('unlike gets error $e');
                });
              }
            },
          );
        }
        else{
          return SizedBox();
        }
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    if(widget.commentData == null){
      return SizedBox(

      );
    }
    final commentData = widget.commentData;
    final commentID = widget.commentID;
    final pageID = widget.pageID;
    final pageType = widget.pageType;
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
                  child: buildUser(),
                ),
                ButtonBar(
                  buttonPadding: EdgeInsets.all(0),
                  children: <Widget>[
                    buildLikeButton(),
                    buildDeleteButton(context),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) {
                              if (commentData['level']  == 1)
                                return CommentInputPage(pageID: pageID, parentLevel: commentData['level'], parentID: commentID, parentType: 'page', targetID: commentID, pageType: pageType,);
                              else
                                return CommentInputPage(pageID: pageID, parentLevel: commentData['level'], parentID: commentData['parentID'], parentType: 'comment', targetID: commentID, pageType: pageType,);
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
              child: buildContent(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              child: buildSubComment(context),
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
        @required this.commentIDs,
        @required this.pageID,
        @required this.pageType,
      }): super(key: key);

  final List<String> commentIDs;
  final String pageID;
  final String pageType;

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
    _userRepository.getUser().then((snap) {
      userID = snap.uid;
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
    List commentIDs = widget.commentIDs.reversed.toList();
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            child: Text("评论", style: TextStyle(color: Colors.black),),
            onTap: () {
              _scrollController.jumpTo(0.0);
            },
          ),
          brightness: Brightness.dark,
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
                    builder: (BuildContext context) => CommentInputPage(pageID: widget.pageID, parentLevel: 0, parentID: widget.pageID, parentType: 'comment', pageType: widget.pageType, )
                )
            );
          },
        ),
        body: Padding(
          key: PageStorageKey('CommentPage'),
          padding: EdgeInsets.symmetric(vertical: 16),
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
                            return CommentBox(commentData: comment, isSubCommentPage: false, commentID: commentIDs[index], pageID: widget.pageID, isCurrentUserComment: isCurrentUserComment, pageType: widget.pageType,);
                        }
                        else{
                          return SizedBox(

                          );
                        }
                    }
                  },
                );
              }
          ),
        ),
    );
  }
}

class SubCommentPage extends StatefulWidget {
  const SubCommentPage(
  {Key key,
//    this.commentData,
    @required this.commentID,
    @required this.pageID,
    @required this.pageType,
  }) : super(key: key);

  final String commentID;
  final String pageID;
  final String pageType;
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
    _userRepository.getUser().then((snap) {
      userID = snap.uid;
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
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('回复', style: TextStyle(color: Colors.black),),
        backgroundColor: AppTheme.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
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
                      CommentBox(commentData: commentData, isSubCommentPage: true, commentID: widget.commentID, pageID: widget.pageID, pageType: widget.pageType,),
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
                                            child: CommentBox(commentData: subcomment, isSubCommentPage: true, commentID: subCommentIDs[index], pageID: widget.pageID, isCurrentUserComment: isCurrentUserComment, pageType: widget.pageType,)
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

