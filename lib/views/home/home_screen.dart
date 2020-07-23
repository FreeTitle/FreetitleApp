import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/index.dart';
import 'package:freetitle/views/post_detail/blog_post_detail.dart';
import 'package:freetitle/views/post_card/post_card.dart';
import 'package:freetitle/views/post_card/project_post_card.dart';
import 'package:freetitle/views/post_card/event_post_card.dart';
import 'package:freetitle/views/post_card/blog/blog_post.dart';
import 'package:freetitle/views/post_card/multiple/multiple_photo.dart';
import 'package:freetitle/views/post_card/single/single_photo.dart';
import 'package:freetitle/views/post_list/post_list.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:freetitle/views/metadata_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0,length: 2, vsync: this);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            title: InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  'FreeTitle',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              onTap: () {
//                _scrollController.jumpTo(0);
              },
            ),
            // TODO add FlexibleSpaceBar here for header
            bottom: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).highlightColor,
              unselectedLabelColor: Theme.of(context).accentColor,
              indicatorColor: Theme.of(context).highlightColor,
              tabs: <Widget>[
                Tab(child: Text('Opportunities')),
                Tab(child: Text('Posts')),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/placeholders/label_event.png',
                        scale: 2,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Row(
                        children: <Widget>[
                          EventPostCard(),
                          EventPostCard(),
                          EventPostCard(),
                          EventPostCard(),
                          EventPostCard(),
                        ],
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/placeholders/label_project.png',
                        scale: 2,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        ProjectPostCard(),
                        ProjectPostCard(),
                        ProjectPostCard(),
                        ProjectPostCard(),
                        ProjectPostCard(),
                      ],
                    ),
                  ],
                ),
              ),
              PostList(),
            ],
          )
      ),
    );
  }
}
