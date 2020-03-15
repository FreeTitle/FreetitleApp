import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/views/home/blog_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:freetitle/views/home/mission_list_view.dart';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/detail/blog_detail.dart';
import 'package:tuple/tuple.dart';
import 'package:freetitle/views/detail/mission_detail.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with TickerProviderStateMixin {

  AnimationController animationController;
  List blogList;
  List missionList;
  List missionIDs;
//  final ScrollController _scrollController = ScrollController();

  @override
  void initState(){
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this
    );

    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child:
                    DefaultTabController(
                      length: 2,
                      child: Scaffold(
                          appBar: AppBar(
                            brightness: Brightness.light,
                            title: new Center(child: Text('Freetitle', style: TextStyle(color: Colors.black),) ),
                            actions: <Widget>[
                              Container(padding: EdgeInsets.only(right: 16),child: Icon(Icons.search, color: Colors.black,)),
                            ],
                            backgroundColor: AppTheme.white,
                            bottom: TabBar(
                              labelColor: AppTheme.primary,
                              unselectedLabelColor: Colors.black,
                              indicatorColor: AppTheme.primary,
                              tabs: <Widget>[
                                Tab(child: Text('Blogs')),
                                Tab(child: Text('Mission')),
                              ],
                            ),
                          ),
                          body:
                          TabBarView(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                key: PageStorageKey('Blogs'),
                                stream: Firestore.instance.collection('blogs').orderBy('time', descending: true).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return new Center(
                                        child: Text('Loading'),
                                      );
                                    default:
                                      if (snapshot.hasData) {
                                        blogList = new List();
//                                        blogList.clear();
                                        snapshot.data.documents.forEach((blog) => {
                                          blogList.add(Tuple2(blog.documentID, blog.data))
                                        });
                                        return LiquidPullToRefresh(
                                          color: AppTheme.primary,
                                          showChildOpacityTransition: false,
                                          onRefresh: () async {
                                            print('pull');
                                            await Future.delayed(
                                                Duration(milliseconds: 500));
//                                            List newList = List();
//                                            await Firestore.instance.collection('blogs').getDocuments().then((snap)=>{
//                                              snap.documents.forEach((blog) => {
//                                                newList.add(Tuple2(blog.documentID, blog.data))
//                                              }),
//                                            });
//                                            setState(() {
//                                              blogList = newList;
//                                            });
                                          },
                                          child: ListView.builder(
                                            itemCount: blogList.length,
                                            padding: const EdgeInsets.only(top: 8),
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (
                                                BuildContext context,
                                                int index) {
                                              final int count = blogList.length;
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
                                              animationController
                                                  .forward();
                                              return BlogCard(
                                                  callback: () {
                                                    getBlog(blogList[index]);
                                                  },
                                                  blogData: blogList[index].item2,
                                                  animation: animation,
                                                  animationController: animationController
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      else{
                                        return new Text("Something is wrong with firebase");
                                      }
                                  }
                                }
                              ),
                              StreamBuilder<QuerySnapshot>(
                                key: PageStorageKey('Missions'),
                                stream: Firestore.instance.collection('missions').orderBy('time', descending: true).snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return new Center(
                                        child: Text('Loading'),
                                      );
                                    default:
                                      if(snapshot.hasData){
                                        missionList = List();
//                                        missionList.clear();
                                        missionIDs = List();
//                                        missionIDs.clear();
                                        snapshot.data.documents.forEach((mission) => {
                                          missionList.add(mission.data),
                                          missionIDs.add(mission.documentID),
                                        });
                                        return SingleChildScrollView(
                                          child: Container(
                                            color: AppTheme.nearlyWhite,
//                                            height: MediaQuery.of(context).size.height,
                                            child: Column(
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16, bottom: 4),
                                                      child: Text(
                                                        'Popular Mission',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 22,
                                                          letterSpacing: 0.27,
                                                          color: AppTheme.darkerText,
                                                        ),
                                                      ),
                                                    ),
                                                    PopularMissionListView(
                                                      missionList: missionList,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 0.0, left: 18, right: 16),
                                                    child: LatestMissionListView(missionList: missionList,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      else{
                                        return new Text("Something is wrong with firebase");
                                      }
                                  }
                                },
                              )
                            ],
                          )
                      )
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void getBlog(blog){
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => BlogDetail(blogID: blog.item1,),
      )
    );
  }

}
