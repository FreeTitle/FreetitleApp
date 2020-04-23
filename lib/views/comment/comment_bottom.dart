import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/comment/comment.dart';
import 'package:synchronized/synchronized.dart';
import 'package:freetitle/app_theme.dart';

class CommentBottom extends StatefulWidget {

  const CommentBottom(
      {Key key,
        @required this.pageID,
        @required this.pageType,
      }): super(key: key);

  final String pageID;
  final String pageType;

  @override
  _CommentBottomState createState() => _CommentBottomState();
}

class _CommentBottomState extends State<CommentBottom>{

  ScrollController _scrollController;
  UserRepository _userRepository;
  String userID;
  List<Map> commentList;
  List commentIDs;

  int startIdx = 0;
  int perPage = 5;
  int pageCount = 1;

  var lock;

  Future<bool> _getComments;

  @override
  void initState(){
    _scrollController =  new ScrollController();
    _userRepository = UserRepository();
    _getComments = getComments();
    commentList = List();
    lock = new Lock();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Future<bool> getComments() async {
    commentIDs = List();
    if(widget.pageType == 'blog'){
      await Firestore.instance.collection('blogs').document(widget.pageID).get().then((snap) {
        if(snap.data['comments'] != null) {
          snap.data['comments'].forEach((comment) {
            commentIDs.add(comment);
          });
        }
      });
    }
    else if(widget.pageType  == 'mission'){
      await Firestore.instance.collection('missions').document(widget.pageID).get().then((snap) {
        if(snap.data['comments'] != null) {
          snap.data['comments'].forEach((comment) {
            commentIDs.add(comment);
          });
        }
      });
    }
    commentIDs = commentIDs.reversed.toList();
    Map commentData = Map();

    await lock.synchronized(() async {
      commentList.clear();
      for(var idx = startIdx; idx <  startIdx+perPage*pageCount && idx < commentIDs.length; idx++ ){
        var commentID = commentIDs[idx];
        var commentSnap = await Firestore.instance.collection('comments').document(commentID).get();
        commentData = commentSnap.data;
        commentList.add(commentData);
      }
    });

    await _userRepository.getUser().then((snap) {
      if(snap != null)
        userID = snap.uid;
    });

    return true;
  }

  @override
  Widget build(BuildContext context){
//    List commentIDs = widget.commentIDs.reversed.toList();
//    List<Widget> commentWidgets = List();
//    Map commentData = Map();
    return FutureBuilder<bool>(
      future: _getComments,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return CommentsList(
            commentList: commentList,
            userID: userID,
            pageID: widget.pageID,
            commentIDs: commentIDs,
            pageType: widget.pageType,
          );
        }
        else{
          return PlaceHolderCard(
            text: 'Loading...',
            height: 200.0,
          );
        }
      },
    );
  }
}

class CommentsList extends StatefulWidget{

  CommentsList({Key key, this.commentList, this.userID, this.pageID, this.commentIDs, this.pageType}) : super(key : key);

  final List commentList;
  final String userID;
  final String pageID;
  final List commentIDs;
  final String pageType;

  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentsList> {


  List<Widget> commentWidgets;

  int pageCount = 1;
  int perPage = 5;

  @override
  void initState(){
    commentWidgets = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List commentList = widget.commentList;
    Map commentData;
    final commentIDs = widget.commentIDs;
    final userID = widget.userID;
    if(pageCount == 1){
      commentWidgets.clear();
      for(var index = 0; index <  commentList.length; index ++){
        bool isCurrentUserComment = false;
        commentData = commentList[index];
        if(userID == commentData['userID']){
          isCurrentUserComment = true;
        }
        if(commentData['level'] == 1)
          commentWidgets.add(
              CommentBox(
                commentData: commentData,
                isSubCommentPage: false,
                pageID: widget.pageID,
                commentID: commentIDs[index],
                isCurrentUserComment: isCurrentUserComment,
                pageType: widget.pageType,
                state: this,
              )
          );
      }
    }
    if(commentWidgets.length == 0){
      commentWidgets.add(
          PlaceHolderCard(
            text: 'No comments yet',
            height: 200.0,
          )
      );
    }

    if(commentWidgets.length < commentIDs.length){
      commentWidgets.add(
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            width: 200,
            child: FlatButton(
              child: Text("Load More", style: TextStyle(color: AppTheme.primary),),
              onPressed: () async {
                pageCount += 1;
                commentWidgets.removeLast();

                for(var idx = (pageCount-1)*perPage; idx <  perPage*pageCount && idx < commentIDs.length; idx++ ){
                  var commentID = commentIDs[idx];
                  var commentSnap = await Firestore.instance.collection('comments').document(commentID).get();
                  commentData = commentSnap.data;
                  bool isCurrentUserComment = false;
                  if(userID == commentData['userID']){
                    isCurrentUserComment = true;
                  }

                  if(commentData['level'] == 1)
                    commentWidgets.add(
                        CommentBox(
                          commentData: commentData,
                          isSubCommentPage: false,
                          pageID: widget.pageID,
                          commentID: commentIDs[idx],
                          isCurrentUserComment: isCurrentUserComment,
                          pageType: widget.pageType,
                          state: this,
                        )
                    );
                }
                setState(() {

                });

              },
            ),
          ),
        )
      );
    }

    return Column(
      key: PageStorageKey('CommentBottom'),
      children: commentWidgets,
    );
  }
}