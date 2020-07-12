import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/post/post_card.dart';
import 'package:freetitle/views/post/project_post_card.dart';
import 'package:freetitle/views/post/event_post_card.dart';
import 'package:freetitle/views/post/blog/blog_post.dart';
import 'package:freetitle/views/post/multiple/multiple_photo_post.dart';
import 'package:freetitle/views/post/single/single_photo.dart';

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
  void initState() {
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
    return Scaffold(
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
              _scrollController.jumpTo(0);
            },
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: Image.asset(
                  'assets/label_event.png',
                  scale: 2,
                ),),
            SingleChildScrollView(
              child: Row(children: <Widget>[
                EventPostCard(),
                EventPostCard(),
                EventPostCard(),
                EventPostCard(),
                EventPostCard(),
              ],),
              scrollDirection: Axis.horizontal,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: Image.asset(
                  'assets/label_project.png',
                  scale: 2,
                ),),
            Column(
              children: <Widget>[
                ProjectPostCard(),
                ProjectPostCard(),
                ProjectPostCard(),
                ProjectPostCard(),
                ProjectPostCard(),
                PostCard(type:'single-photo'),
                PostCard(type:'blog'),
                PostCard(type:'multi-photo'),
              ],
            ),
          ],
        ),
      )
    );
  }
}