import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freetitle/model/comment_repository.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util/cloud_function_invoker.dart';

class DummyPostData {
  DummyPostData(int numImages) {
    List<String> images = List();
    for(var i=0;i < numImages;i++){
      images.add('assets/placeholders//blogpost_.png');
    }
    postModel = PostModel(
      content: 'Un Chien Andalou has no plot in the conventional sense of the word. The chronology of the film is disjointed, jumping from the initial atThe chronology of the film is disjointed, jumping from the initial at…. Read more ',
      type: numImages > 1 ? PostType.multiple_photo : PostType.single_photo,
      images: images,
      likes: ['like1', 'like2']
    );
  }

  PostModel postModel;
}

enum PostType {
  single_photo,
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
  List labelIDs;
  String content;
  Map missionSpec;
  String forwardedPostID;
  List likes;
  List images;
  /* To be added */

  PostModel({String ownerID,
    Timestamp createTime,
    PostType type,
    List labelIDs,
    String content,
    Map<String, String> missionSpec,
    String forwardedPostID,
    List images,
    List videos,
    List likes,
  })
  : ownerID = ownerID,
    createTime = createTime,
    type = type,
    labelIDs = labelIDs,
    content = content,
    missionSpec = missionSpec,
    forwardedPostID = forwardedPostID,
    likes = likes,
    images = images;
  /* To be added */
  
  void setID(id) {
    postID = id;
  }


  void fromMap(Map<String, dynamic> postData){
    ownerID = postData['ownerID'];

    if(postData.containsKey('createTime'))
      createTime = postData['createTime'];

    if(postData.containsKey('labelIDs'))
      labelIDs = postData['labelIDs'];

    if(postData.containsKey('missionSpec'))
      missionSpec = postData['missionSpec'];

    if(postData.containsKey('forwardedPostID'))
      forwardedPostID = postData['forwardedPostID'];

    if(postData.containsKey('likes'))
      likes = postData['likes'];

    if(postData.containsKey('content'))
      content = postData['content'];

    if(postData.containsKey('images'))
      images = postData['images'];


    _mapType(postData['type']);
    /* To be added */
  }

  void _mapType(String type) {
    switch(type) {
      case "single_photo":
        this.type = PostType.single_photo;
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

class PostRepository {

  /* Read Data */
  static DocumentSnapshot _lastDoc;

  static Future<List<PostModel>> getPosts(count, refresh) async {
    QuerySnapshot ref;
    if(_lastDoc != null && !refresh){
      ref = await Firestore.instance.collection('posts').orderBy("createTime").limit(count).startAfterDocument(_lastDoc).getDocuments();
    }
    else {
      ref = await Firestore.instance.collection('posts').orderBy("createTime").limit(count).getDocuments();
    }
    List<PostModel> posts = List();
    if(ref.documents.isNotEmpty){
      _lastDoc = ref.documents.last;
    }
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
    print("postData $postData");
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

  /* Cloud function involved */

  Future<bool> likeButtonPressed(postID) async  {
    print("Like Post Pressed");
    UserRepository userRepository = UserRepository();
    var userID = userRepository.getUser();
//    HttpsCallableResult resp = await CloudFunctionInvoker.cloudFunction({"collection": "posts", "id": postID, "userID": userID}, 'toggleLike');
    var resp = -1;
    /* TODO Needs to handle result */
    print(resp);
    switch(resp){
      case 1:
        return true;
      case -1:
        return false;
      default:
        return false;
    }
  }

  Future<bool> createPost(Map<String, dynamic> data) async {
    HttpsCallableResult resp = await CloudFunctionInvoker.cloudFunction(data, '<name>');

    /* TODO Needs to handle result */
    print(resp.data);
    switch(resp.data){
      case 1:
        return true;
      case -1:
        return false;
      default:
        return false;
    }
  }

  Future<bool> modifyPost(Map<String, dynamic> data) async {
    HttpsCallableResult resp = await CloudFunctionInvoker.cloudFunction(data, '<name>');

    /* TODO Needs to handle result */
    print(resp.data);
    switch(resp.data){
      case 1:
        return true;
      case -1:
        return false;
      default:
        return false;
    }
  }

  Future<bool> deletePost(Map<String, dynamic> data) async {
    HttpsCallableResult resp = await CloudFunctionInvoker.cloudFunction(data, '<name>');

    /* TODO Needs to handle result */
    print(resp.data);
    switch (resp.data) {
      case 1:
        return true;
      case -1:
        return false;
      default:
        return false;
    }
  }

  /* Functions below are for testing usage only */
  static Future<List<PostModel>> get5DummyPosts() async {
    await Future.delayed(Duration(milliseconds: 50));

    List<PostModel> posts = List();
    for(var i=0;i < 5;i++){
      posts.add(DummyPostData(i % 6).postModel);
    }

    return posts;
  }

  static Future<List<PostModel>> get5DummyEvents() async {
    await Future.delayed(Duration(milliseconds: 50));

    List<PostModel> posts = List();
    for(var i=0;i < 5;i++) {
      posts.add(PostModel(type: PostType.event));
    }

    return posts;
  }

  static Future<List<PostModel>> get5DummyProjects() async {
    await Future.delayed(Duration(milliseconds: 50));

    List<PostModel> posts = List();
    for(var i=0;i < 5;i++) {
      posts.add(PostModel(type: PostType.project));
    }

    return posts;
  }

}