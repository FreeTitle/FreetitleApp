import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/model/algolias_search.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/blog/blog_card.dart';


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

  Future<List<SearchResult>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    AlgoliaQuery query = algolia.instance.index('blogs').search(search);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List blogIDs = List();
    snap.hits.forEach((h) => {
      blogIDs.add(h.objectID),
    });

//    List users = List();
//
//    for(final result in results){
//      await Firestore.instance.collection('users').document(result['user']).get().then((snap) => {
//        users.add(snap.data['displayName']),
//      });
//    }
    List blogList = List();
    for (var id in blogIDs){
      await Firestore.instance.collection('blogs').document(id).get().then((snap) => {
        blogList.add(snap.data)
      });
    }
    resultCount = blogList.length;
    return List.generate(blogList.length, (int index) {

      return SearchResult(blogList[index]['title'], blogList[index], blogIDs[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: SearchBar<SearchResult>(
                    onSearch: search,
                    hintText: 'Search FreeTitle',
                    placeHolder: Center(
                      child: Text('Search blogs'),
                    ),
                    emptyWidget: Center(
                      child: Text('No blogs found'),
                    ),
                    onItemFound: (SearchResult post, int index) {
                      final int count = resultCount;
                      final Animation<double> animation = Tween<double>(
                          begin: 0.0, end: 1.0)
                          .animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                  (1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn
                              )
                          )
                      );
                      animationController.forward();
                      return BlogCard(
                        blogID: post.blogID,
                        blogData: post.blogData,
                        animationController: animationController,
                        animation: animation,
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}

class SearchResult {
  Map blogData;
  String blogID;
  String title;

  SearchResult(this.title, this.blogData, this.blogID);
}