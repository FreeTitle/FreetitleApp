import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freetitle/views/home/featured_home.dart';
import 'package:freetitle/views/mission/mission_list_view.dart';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/blog/blog_list_view.dart';

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
  List blogIDs;
  List missionList;
  List missionIDs;
  ScrollController _scrollController;

  @override
  void initState(){
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this
    );
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.dispose();
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
                      length: 3,
                      initialIndex: 1,
                      child: Scaffold(
                          appBar: AppBar(
                            centerTitle: true,
                            brightness: Brightness.light,
                            title: Container(
                              width: 90,
                              child: InkWell(
                                child: Center(child: Text('Freetitle', style: TextStyle(color: Colors.black),) ),
                                onDoubleTap: () {
                                  _scrollController.jumpTo(0);
                                },
                              ),
                            ),
//                            actions: <Widget>[
//                              Container(
//                                  padding: EdgeInsets.only(right: 16),
//                                  child: IconButton(
//                                    icon: Icon(Icons.search, color: Colors.black,),
//                                    onPressed: () {
//                                      Navigator.push<dynamic>(
//                                        context,
//                                        MaterialPageRoute<dynamic>(
//                                          builder: (BuildContext context) => SearchView()
//                                        )
//                                      );
//                                    }
//                                  )
//                              ),
//                            ],
                            backgroundColor: AppTheme.white,
                            bottom: TabBar(
                              labelColor: AppTheme.primary,
                              unselectedLabelColor: Colors.black,
                              indicatorColor: AppTheme.primary,
                              tabs: <Widget>[
                                Tab(child: Text('Blogs')),
                                Tab(child: Text('Featured')),
                                Tab(child: Text('Mission')),
                              ],
                            ),
                          ),
                          body: TabBarView(
                            children: <Widget>[
                              BlogListView(animationController: animationController, scrollController: _scrollController,),
                              FeaturedHome(),
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
                                        missionIDs = List();
                                        snapshot.data.documents.forEach((mission) => {
                                          missionList.add(mission.data),
                                          missionIDs.add(mission.documentID),
                                        });
                                        return SingleChildScrollView(
                                          controller: _scrollController,
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

}
