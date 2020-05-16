import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/algolias_search.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:freetitle/views/mission/mission_list_view.dart';


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
                    searchBarStyle: SearchBarStyle(
                      backgroundColor: Theme.of(context).primaryColorLight
                    ),
                    onSearch: search,
                    hintText: 'Search FreeTitle',
                    placeHolder: Center(
                      child: Text('Search'),
                    ),
                    emptyWidget: Center(
                      child: Text('No results found'),
                    ),
                    onError: (err) {
                      print(err);
                    },
                    minimumChars: 2,
                    onItemFound: (SearchResult result, int index) {
                      if (index == 0){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Users', style: AppTheme.body1, textAlign: TextAlign.left,),
                            ),
                            Divider(),
                            result.users.length != 0 ? Container(
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
                            ) : Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Center(child: Text("No Users Found"),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Missions', style: AppTheme.body1, textAlign: TextAlign.left,),
                            ),
                            Divider(),
                            result.missionIDs.length != 0 ? HorizontalMissionListView(
                              missionIDs: result.missionIDs,
                              missionList: result.missions,
                            ) :
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Center(child: Text("No Missions Found"),),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Blogs', style: AppTheme.body1, textAlign: TextAlign.left,),
                            ),
                            Divider(),
                            resultCount <= 1 ?
                            Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Center(child: Text("No Blogs Found"),),
                            ) :
                            SizedBox(),
                          ],
                        );
                      }
                      else {
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
  List users;
  List missions;
  List missionIDs;
  SearchResult(this.blogData, this.blogID, this.users, this.missions, this.missionIDs);
}