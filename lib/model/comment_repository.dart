import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freetitle/model/user_repository.dart';

class CommentModel {

  String commentID;
  String ownerID;
  Timestamp createTime;
  String image;
  String text;
  List<String> likes;
  List<String> replies;

  /* To be added */

  CommentModel({
    String ownerID,
    Timestamp createTime,
    String image,
    String text,
    List<String> likes,
    List<String> replies
  })
      : ownerID = ownerID,
        createTime = createTime,
        text = text,
        image = image,
        likes = likes,
        replies = replies;

  /* To be added */

  void setID(id){
    commentID = id;
  }


  void fromMap(Map<String, dynamic> postData){
    try{
      ownerID = postData['ownerID'];
      createTime = postData['createTime'];
      text = postData['text'];
    } catch (e) {
      print("Key Comment Component Missing");
    }
    if(postData.containsKey('image'))
      image = postData['image'];
    if(postData.containsKey('likes'))
      likes = postData['likes'];
    if(postData.containsKey('replies'))
      replies  = postData['replies'];
    /* To be added */
  }

}

class CommentRepository{

  static Future<List<CommentModel>> get20Comments(postID) async {
    
    /* Only get 20 comments at every load */
    var ref = await Firestore.instance.collection('posts').document(postID).collection('comments').limit(20).getDocuments();

    List<CommentModel> comments = List();
    ref.documents.forEach((element) {
      CommentModel comment = CommentModel();
      comment.fromMap(element.data);
      comment.setID(element.documentID);
      comments.add(comment);
    });

    return comments;
  }

  Future<CommentModel> getComment(postID, commentID) async {
    var ref = await Firestore.instance.collection('posts').document(postID).collection('comments').document(commentID).get();

    CommentModel comment = CommentModel();
    comment.fromMap(ref.data);
    return comment;
  }

  Future<bool> isCommentLiked(postID, commentID) async {
    var commentData = await getComment(postID, commentID);

    UserRepository _userRepository = UserRepository();
    var user = await _userRepository.getUser();
    if(user == null){
      return false;
    }
    else if(commentData.likes.contains(user.uid)){
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> uploadCommentPressed(Map<String, dynamic>data) async {
    HttpsCallable commentPressed = CloudFunctions.instance.getHttpsCallable(functionName: '<TBD>');
    HttpsCallableResult resp = await commentPressed.call(data);

    /* TODO Needs to handle result */
    print(resp.data);
    if(resp.data){
      return true;
    }else {
      return false;
    }
  }
}