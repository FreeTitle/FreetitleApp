import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freetitle/views/home/coin.dart';
import 'package:freetitle/views/home/featured_home.dart';
import 'package:freetitle/views/home/home_drawer.dart';
import 'package:freetitle/views/mission/mission_list_view.dart';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/home/home_blog_list_view.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> {

  List blogList;
  List blogIDs;
  List missionList;
  List missionIDs;
  ScrollController _scrollController;

  @override
  void initState(){

    _scrollController = ScrollController(initialScrollOffset: 0.0);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              title: InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text('FreeTitle', style: TextStyle(color: Theme.of(context).accentColor),),
                ),
                onTap: () {
                  _scrollController.jumpTo(0);
                },
              ),
//              brightness: Brightness.light,
              actions: <Widget>[
                Container(
                    padding: EdgeInsets.only(right: 16),
                    child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Theme.of(context).primaryColorDark,),
                        onPressed: () {

                        }
                    )
                ),
              ],
              bottom: TabBar(
                labelColor: AppTheme.primary,
                unselectedLabelColor: Theme.of(context).accentColor,
                indicatorColor: AppTheme.primary,
                tabs: <Widget>[
                  Tab(child: Text('Blogs')),
                  Tab(child: Text('Featured')),
                  Tab(child: Text('Mission')),
                ],
              ),
            ),
            drawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Theme.of(context).primaryColor,
              ),
              child:  Drawer(
                child: HomeDrawer(),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                HomeBlogListView(scrollController: _scrollController,),
                FeaturedHome(scrollController: _scrollController,),
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
                          snapshot.data.documents.forEach((mission) {
                            missionList.add(mission.data);
                            missionIDs.add(mission.documentID);
                          });
                          return SingleChildScrollView(
                            controller: _scrollController,
                            child: Container(
//                              color: AppTheme.nearlyWhite,
//                                            height: MediaQuery.of(context).size.height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16, bottom: 4),
                                        child: Text(
                                          'Popular Mission',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                            letterSpacing: 0.27,
                                            color: Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                      HorizontalMissionListView(
                                        missionList: missionList,
                                        missionIDs: missionIDs,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16, bottom: 8),
                                    child: Text(
                                      'Latest Mission',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0, left: 16, right: 16),
                                    child: VerticalMissionListView(missionList: missionList, missionIDs: missionIDs,),
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
    );
  }

}
