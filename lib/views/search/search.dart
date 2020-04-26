import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/app_theme.dart';
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
    AlgoliaQuery query = algolia.instance.index('blogs').search(search);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List blogIDs = List();
    snap.hits.forEach((h) {
      blogIDs.add(h.objectID);
    });
    String matchUid;
    query = algolia.instance.instance.index('users').search(search);
    snap = await query.getObjects();
    List userIDs = List();
    snap.hits.forEach((h) {
      userIDs.add(h.objectID);
      if(h.data['_fieldsProto']['displayName']['stringValue'].toLowerCase().contains(search.toLowerCase())){
        matchUid = h.objectID;
      }
    });


    List users = List();

    for(final uid in userIDs){
      var userSnap = await Firestore.instance.collection('users').document(uid).get();
      Map userData = userSnap.data;
      users.add(_userRepository.getUserWidget(context, uid, userData, color: AppTheme.nearlyWhite));
    }

    if(matchUid != null){
      await Firestore.instance.collection('users').document(matchUid).get().then((snap) {
        if(snap.data.containsKey('blogs')){
          for(var blogID in snap.data['blogs']){
            blogIDs.add(blogID);
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

    resultCount = blogList.length;

    return List.generate(resultCount+1, (int index) {
      if (index == 0){
        return SearchResult("", Map(), "", users);
      }
      else{
        return SearchResult(blogList[index-1]['title'], blogList[index-1], blogIDs[index-1], List());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
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
                    onError: (err) {
                      print(err);
                    },
                    onItemFound: (SearchResult result, int index) {
                      if (index != 0){
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
                        return AnimatedBlogCard(
                          blogID: result.blogID,
                          blogData: result.blogData,
                          animationController: animationController,
                          animation: animation,
                        );
                      }
                      else{
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Users', style: AppTheme.body1, textAlign: TextAlign.left,),
                            ),
                            Divider(color: AppTheme.dark_grey,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 70,
                              width: double.infinity,
                              child: ListView.builder(
                                  itemCount: result.users.length,
                                  padding: const EdgeInsets.only(top: 0),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int i){
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: result.users[i],
                                    );
                                  }
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Blogs', style: AppTheme.body1, textAlign: TextAlign.left,),
                            ),
                            Divider(color: AppTheme.dark_grey,)
                          ],
                        );
                      }
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
  List users;
  SearchResult(this.title, this.blogData, this.blogID, this.users);
}