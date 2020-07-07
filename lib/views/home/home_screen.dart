import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/post/blog_post.dart';
import 'package:freetitle/views/post/multiple_photo_post.dart';

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
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: BlogPost()),
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: MultiplePhotoPost())
          ],
        ));
  }
}
