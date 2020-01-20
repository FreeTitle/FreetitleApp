import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/views/home/sharing_list_view.dart';
import 'package:freetitle/model/sharing_list_data.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:freetitle/views/home/mission_list_view.dart';
import 'home_app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/detail/mission/mission_detail_view.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with TickerProviderStateMixin {

  AnimationController animationController;
  List<SharingListData> sharingList = List<SharingListData>();
  final ScrollController _scrollController = ScrollController();
  CategoryType categoryType = CategoryType.film;

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
      data: HomeAppTheme.buildLightTheme(),
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
                      child: Scaffold(
                          appBar: AppBar(
                            title: new Center(child: Text('Freetitle', style: TextStyle(color: Colors.black),) ),
                            actions: <Widget>[
                              Container(padding: EdgeInsets.only(right: 8),child: Icon(Icons.add, color: Colors.black,)),
                            ],
                            backgroundColor: Colors.white,
                            bottom: TabBar(
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.black,
                              tabs: <Widget>[
                                Tab(text: 'Sharing'),
                                Tab(text: 'Event'),
                                Tab(text: 'Mission'),
                              ],
                            ),
                          ),
                          body:
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection('news').snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return new Text('Error: ${snapshot
                                          .error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return new Text('Loading');
                                      default:
                                        if (snapshot.hasData) {
                                          sharingList.clear();
                                          snapshot.data.documents.forEach((news) =>
                                          {
                                            sharingList.add(SharingListData(
                                                imagePath: news['ImageLoc'],
                                                titleTxt: news['Title'],
                                                subTxt: news['Author']))
                                          });
                                          return TabBarView(
                                            children: <Widget>[
                                              LiquidPullToRefresh(
                                                showChildOpacityTransition: false,
                                                onRefresh: () async {
                                                  await Future.delayed(
                                                      Duration(milliseconds: 500));
                                                  //TODO Refresh
                                                },
                                                child: ListView.builder(
                                                  itemCount: sharingList.length,
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 8),
                                                  scrollDirection: Axis
                                                      .vertical,
                                                  itemBuilder: (
                                                      BuildContext context,
                                                      int index) {
                                                    final int count = sharingList
                                                        .length;
                                                    final Animation<
                                                        double> animation = Tween<
                                                        double>(
                                                        begin: 0.0, end: 1.0)
                                                        .animate(
                                                        CurvedAnimation(
                                                            parent: animationController,
                                                            curve: Interval(
                                                                (1 / count) *
                                                                    index, 1.0,
                                                                curve: Curves
                                                                    .fastOutSlowIn
                                                            )
                                                        )
                                                    );
                                                    animationController
                                                        .forward();
                                                    return SharingListView(
                                                        callback: () {},
                                                        sharingData: sharingList[index],
                                                        animation: animation,
                                                        animationController: animationController
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: Center(
                                                  child: Text('Event'),),
                                              ),
                                              Container(
                                                color: HomeAppTheme.nearlyWhite,
                                                child: Scaffold(
                                                  backgroundColor: Colors.transparent,
                                                  body: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: MediaQuery.of(context).padding.top,
                                                      ),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          child: Container(
                                                            height: MediaQuery.of(context).size.height,
                                                            child: Column(
                                                              children: <Widget>[
                                                                getCategoryMissionUI(),
                                                                Flexible(
                                                                  child: getPopularMissionUI(),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                        else{
                                          return new Text("Something is wrong with firebase");
                                        }
                                    }
                                  }
                      )
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget getCategoryMissionUI(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: HomeAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              getButtonUI(CategoryType.film, categoryType == CategoryType.film),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.theater, categoryType == CategoryType.theater),
              const SizedBox(
                width: 16,
              ),
              getButtonUI(
                  CategoryType.photography, categoryType == CategoryType.photography),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        CategoryMissionListView(
          callBack: () {
            getMission();
          },
        ),
      ],
    );
  }

  Widget getPopularMissionUI(){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Popular Mission',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: HomeAppTheme.darkerText,
            ),
          ),
          Flexible(
            child: PopularMissionListView(
              callBack: (){
                getMission();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected){
    String txt = '';
    if (CategoryType.film == categoryTypeData) {
      txt = '电影';
    } else if (CategoryType.theater == categoryTypeData) {
      txt = '戏剧';
    } else if (CategoryType.photography == categoryTypeData) {
      txt = '视觉艺术';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? HomeAppTheme.nearlyBlue
                : HomeAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: HomeAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? HomeAppTheme.nearlyWhite
                        : HomeAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getMission() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MissionDetailPage(),
      )
    );
  }

}



enum CategoryType {
  film,
  theater,
  photography,
}