import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/comment/commentInput.dart';
import 'package:freetitle/views/login/login.dart';

class CommentBox extends StatefulWidget {

  const CommentBox({Key key,
    @required this.commentData,
    @required this.isSubCommentPage,
    @required this.pageID,
    @required this.pageType,
    @required this.commentID,
    this.isCurrentUserComment,
    @required this.state,
  }) : super(key: key);

  final Map commentData;
  final bool isSubCommentPage;
  final String pageID;
  final String commentID;
  final bool isCurrentUserComment;
  final String pageType;
  final state;

  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox>{

//  bool liked = false;
  String userID;
  UserRepository _userRepository;
  Map authorData;

  @override
  void initState(){
    _userRepository = UserRepository();

    super.initState();
  }

  Widget buildContent(){
    final Map content = widget.commentData['content'];
    if (content == null){
      return SizedBox(

      );
    }
    Widget img;
    if (content['image'] != null){
      img =  Image.network(content['image'], fit: BoxFit.contain);
    }
    if (img != null){
      return Column(
        children: <Widget>[
          img,
          SizedBox(
            height: 15,
          ),
          Text(content['text']),
        ],
      );
    }
    else{
      return Text(content['text']);
    }
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

//                            List comments;
//                            List subcomments;

                            if(pageType == 'blog') {
//                              await Firestore.instance.collection('blogs').document(pageID).get().then((snap) {
//                                comments = snap.data['comments'];
//                                subcomments = snap.data['subcomments'];
//                              });
//                              comments.remove(commentID);
//                              for(var id in subCommentIDs){
//                                subcomments.remove(id);
//                              }
                              await Firestore.instance.collection('blogs').document(pageID).updateData({
                                'comments': FieldValue.arrayRemove([commentID]),
                                'subcomments': FieldValue.arrayRemove(subCommentIDs),
                              });
                            }
                            else if(pageType == 'mission') {
//                              await Firestore.instance.collection('missions').document(pageID).get().then((snap) {
//                                comments = snap.data['comments'];
//                                subcomments = snap.data['subcomments'];
//                              });
//                              comments.remove(commentID);
//                              for(var id in subCommentIDs){
//                                subcomments.remove(id);
//                              }
                              await Firestore.instance.collection('missions').document(pageID).updateData({
                                'comments': FieldValue.arrayRemove([commentID]),
                                'subcomments': FieldValue.arrayRemove(subCommentIDs),
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
                        widget.state.setState(() {});


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

  Future<bool> getUser() async {
    authorData = Map();
    await Firestore.instance.collection('users').document(widget.commentData['userID']).get().then((snap) {
      authorData = snap.data;
    });

    return true;
  }

  Widget buildUser() {
    _userRepository = UserRepository();
    return FutureBuilder<bool> (
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return _userRepository.getUserWidget(context, widget.commentData['userID'], authorData, color: AppTheme.white);
        }
        else {
          return Text('FreeTitle Author');
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
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: buildUser(),
                ),
                ButtonBar(
                  buttonPadding: EdgeInsets.all(0),
                  children: <Widget>[
                    CommentLikeButton(commentID: widget.commentID, commentData: widget.commentData,),
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

class CommentLikeButton extends StatefulWidget {
  CommentLikeButton({Key key, this.commentID, this.commentData}) : super(key : key);

//  final _CommentBoxState state;
  final String commentID;
  final Map commentData;

  _CommentLikeButtonState createState() => _CommentLikeButtonState();
}

class _CommentLikeButtonState extends State<CommentLikeButton> {
  UserRepository _userRepository;
  String userID;
  bool liked = false;
  Future<bool> getLike() async {
    _userRepository = UserRepository();
    var userSnap = await _userRepository.getUser();
    userID = userSnap.uid;

    return true;
  }

  void modifyFirebase(liked) {
    // modify comment document in database
//    print(liked);
    Firestore.instance.collection('comments').document(widget.commentID).updateData({
      "likes": FieldValue.increment((liked ? (1) : (-1))),
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
//      widget.commentData['upvotedBy'].add(userID);
    }
    else{
      Firestore.instance.collection('comments').document(widget.commentID).updateData({
        "upvotedBy": FieldValue.arrayRemove([userID]),
      }).whenComplete(() {
        print('unlike  succeeds');
      }).catchError((e) {
        print('unlike gets error $e');
      });
//      widget.commentData['upvotedBy'].remove(userID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder<bool>(
        future: getLike(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(widget.commentData['upvotedBy'] != null && widget.commentData['upvotedBy'].contains(userID)){
              liked = true;
            }
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

                modifyFirebase(liked);

              },
            );
          }
          else {
            return SizedBox();
          }
        },
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
  List<Map> subCommentList;

  @override
  void initState(){
    _scrollController =  new ScrollController();
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap) {
      userID = snap.uid;
    });
    subCommentList = List();
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> getComment() async {
    var commentSnap = await Firestore.instance.collection('comments').document(widget.commentID).get();
    commentData = commentSnap.data;
    return true;
  }


  Future<bool> getSubComments(subCommentIDs) async {
    Map subCommentData = Map();
    subCommentList.clear();
    for(var subCommentID in subCommentIDs){
      var subCommentSnap = await Firestore.instance.collection('comments').document(subCommentID).get();
      subCommentData = subCommentSnap.data;
      subCommentList.add(subCommentData);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('refresh subcomment');
    return Scaffold(
      appBar: AppBar(
//        brightness: Brightness.dark,
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
      body: FutureBuilder<bool>(
        future: getComment(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            subCommentIDs = commentData['replies'];
            subCommentIDs = subCommentIDs.reversed.toList();
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Level 1 comment
                  CommentBox(
                    commentData: commentData,
                    isSubCommentPage: true,
                    commentID: widget.commentID,
                    pageID: widget.pageID,
                    pageType: widget.pageType,
                    state: this,
                  ),
                  Container(
                    height: subCommentIDs.length*170.0,
                    color: AppTheme.nearlyWhite,
                    child: FutureBuilder<bool>(
                      future: getSubComments(subCommentIDs),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if(snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: subCommentIDs.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final subCommentData_ = subCommentList[index];
                              bool isCurrentUserComment = false;
                              if(userID == subCommentData_['userID']){
                                isCurrentUserComment = true;
                              }
                              return Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: CommentBox(
                                    commentData: subCommentData_,
                                    isSubCommentPage: true,
                                    commentID: subCommentIDs[index],
                                    pageID: widget.pageID,
                                    isCurrentUserComment: isCurrentUserComment,
                                    pageType: widget.pageType,
                                    state: this,
                                  )
                              );
                            }
                          );
                        }
                        else {
                          return PlaceHolderCard(
                            text: 'Loading...',
                            height: 200.0,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          else{
            return SizedBox(
              child: Text('Loading...'),
            );
          }
        },
      ),
    );
  }
}

