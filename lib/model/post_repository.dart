import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freetitle/model/comment_repository.dart';
import 'package:freetitle/model/user_repository.dart';

enum PostType {
  single_photo_video,
  multiple_photo,
  pure_text,
  blog,
  event,
  project
}

class PostModel {
  
  String postID;
  String ownerID;
  Timestamp createTime;
  PostType type;
  List<String> labelIDs;
  String content;
  Map missionSpec;
  String forwardedPostID;
  List<String> likes;

  /* To be added */

  PostModel({String ownerID,
    Timestamp createTime,
    PostType type,
    List<String> labelIDs,
    String content,
    Map<String, String> missionSpec,
    String forwardedPostID,
    List<String> images,
    List<String> videos,
    List<String> likes,
  })
  : ownerID = ownerID,
    createTime = createTime,
    type = type,
    labelIDs = labelIDs,
    content = content,
    missionSpec = missionSpec,
    forwardedPostID = forwardedPostID,
    likes = likes;
  /* To be added */
  
  void setID(id) {
    postID = id;
  }


  void fromMap(Map<String, dynamic> postData){
    ownerID = postData['ownerID'];
    createTime = postData['createTime'];
    type = postData['type'];
    labelIDs = postData['labelIDs'];
    missionSpec = postData['missionSpec'];
    forwardedPostID = postData['forwardedPostID'];
    likes = postData['likes'];
    _mapType(postData['type']);
    /* To be added */
  }

  void _mapType(String type) {
    switch(type) {
      case "single_photo_video":
        this.type = PostType.single_photo_video;
        break;
      case "multiple_photo":
        this.type = PostType.multiple_photo;
        break;
      case "pure_text":
        this.type = PostType.pure_text;
        break;
      case "blog":
        this.type = PostType.blog;
        break;
      case "event":
        this.type = PostType.event;
        break;
      case "project":
        this.type = PostType.project;
        break;
      default:
        this.type = null;
        break;
    }
  }
}

class PostFunction {

  static Future<List<PostModel>> get20Posts() async {
    var ref = await Firestore.instance.collection('posts').limit(20).getDocuments();

    List<PostModel> posts = List();
    ref.documents.forEach((element) {
      PostModel post = PostModel();
      post.fromMap(element.data);
      post.setID(element.documentID);
      posts.add(post);
    });

    return posts;
  }

  Future<PostModel> getPostData(postID) async {
    var ref = await Firestore.instance.collection('posts').document(postID).get();

    PostModel post = PostModel();
    post.fromMap(ref.data);
    return post;
  }

  Future<bool> isPostLiked(postID) async {
    var postData = await getPostData(postID);

    UserRepository _userRepository = UserRepository();
    var user = await _userRepository.getUser();
    if(user == null){
      return false;
    }
    else if(postData.likes.contains(user.uid)){
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> likeButtonPressed() async  {
    HttpsCallable likePressed = CloudFunctions.instance.getHttpsCallable(functionName: '<TBD>');
    HttpsCallableResult resp = await likePressed.call(<String, dynamic>{
      /* TBD */
    });

    /* TODO Needs to handle result */
    print(resp.data);
    if(resp.data){
      return true;
    }else {
      return false;
    }
  }

}