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
import 'package:freetitle/views/home/post_wall/opportunity_list.dart';
import 'package:freetitle/views/home/post_wall/post_list.dart';
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
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 180,
                  floating: false,
                  pinned: true,
                  centerTitle: true,
                  backgroundColor: Theme.of(context).highlightColor,
                  title: Text('FreeTitle'),
                  flexibleSpace: FlexibleSpaceBar(
//                    centerTitle: true,
//                    title:
                  ),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {

                      },
                      icon: Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {

                      },
                      icon: Icon(Icons.create),
                    )
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).accentColor,
                    unselectedLabelColor: Theme.of(context).accentColor,
                    indicatorColor: Theme.of(context).highlightColor,
                    tabs: <Widget>[
                      Tab(child: Text('Opportunities')),
                      Tab(child: Text('Posts')),
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                OpportunityList(),
                PostList(),
              ],
            ),
          )
      ),
    );
  }
}
