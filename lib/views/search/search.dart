import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/algolias_search.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';

class SearchView extends StatefulWidget {

  _SearchView createState() => _SearchView();
}

class _SearchView extends State<SearchView> with TickerProviderStateMixin {

  Algolia algolia = AlgoliaSearch.algolia;
  UserRepository _userRepository = UserRepository();
  AnimationController animationController;
  int resultCount = 0;

  @override
  void initState(){
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this
    );
    super.initState();
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  Future<List<SearchResult>> search(String searchKey) async {
    // Search blogs
    AlgoliaQuery query = algolia.instance.index('blogs').search(searchKey);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List blogIDs = List();
    snap.hits.forEach((h) {
      blogIDs.add(h.objectID);
    });
    
    // Search missions
    query = algolia.instance.index('missions').search(searchKey);
    snap = await query.getObjects();
    List missionIDs = List();
    snap.hits.forEach((h) {
      missionIDs.add(h.objectID);
    });
    
    // Search users
    String matchUid;
    query = algolia.instance.instance.index('users').search(searchKey);
    snap = await query.getObjects();
    List userIDs = List();
    snap.hits.forEach((h) {
      userIDs.add(h.objectID);
      if(h.data['displayName'].toLowerCase().contains(searchKey.toLowerCase())){
        matchUid = h.objectID;
      }
    });
    
    List users = List();

    for(final uid in userIDs){
      var userSnap = await Firestore.instance.collection('users').document(uid).get();
      Map userData = userSnap.data;
      users.add(_userRepository.getUserWidget(context, uid, userData));
    }

    // search matched user's blogs and missions
    if(matchUid != null){
      await Firestore.instance.collection('users').document(matchUid).get().then((snap) {
        if(snap.data.containsKey('blogs')){
          for(var blogID in snap.data['blogs']){
            if(blogIDs.contains(blogID) != true){
              blogIDs.add(blogID);
            }
          }
        }
        if(snap.data.containsKey('missions')) {
          for(var missionID in snap.data['missions']){
            if(missionIDs.contains(missionID) != true) {
              missionIDs.add(missionID);
            }
          }
        }
      });
    }

    List blogList = List();
    for (var id in blogIDs){
      await Firestore.instance.collection('blogs').document(id).get().then((snap) {
        blogList.add(snap.data);
      });
    }
    blogList.sort((a, b) => b['time'].compareTo(a['time']));

    List missionList = List();
    for (var id in missionIDs) {
      await Firestore.instance.collection('missions').document(id).get().then((snap) {
        missionList.add(snap.data);
      });
    }
    missionList.sort((a, b) => a['time'].compareTo(b['time']));

    resultCount = blogList.length;

    return List.generate(resultCount+1, (int index) {
      if (index == 0){
        return SearchResult(Map(), "", users, missionList, missionIDs);
      }
      else{
        return SearchResult(blogList[index-1], blogIDs[index-1], List(), List(), List());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Exploration"),
      ),
      body: Container()
    );
  }
}

class SearchResult {
  Map blogData;
  String blogID;
  List users;
  List missions;
  List missionIDs;
  SearchResult(this.blogData, this.blogID, this.users, this.missions, this.missionIDs);
}