import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freetitle/views/index.dart';
import 'package:freetitle/views/post_detail/blog_post_detail.dart';
import 'package:freetitle/views/post/post_card.dart';
import 'package:freetitle/views/post/project_post_card.dart';
import 'package:freetitle/views/post/event_post_card.dart';
import 'package:freetitle/views/post/blog/blog_post.dart';
import 'package:freetitle/views/post/multiple/multiple_photo.dart';
import 'package:freetitle/views/post/single/single_photo.dart';
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

class _HomeScreenState extends State<HomeScreen> {


//  List<PostModel> _posts;
//  Future<List<PostModel>> _getPost;

  @override
  void initState() {
//    _posts = List();
//    _getPost = PostRepository.get5DummyPosts();
    super.initState();
  }


  @override
  void dispose() {
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
//              FutureBuilder<List<PostModel>>(
//                key: PageStorageKey('Post'),
//                future: _getPost,
//                builder:(BuildContext context, AsyncSnapshot snapshot) {
//                  if(snapshot.connectionState == ConnectionState.done){
//                    if(MetaDataProvider.of(context).postCount == 5){
//                      _posts = snapshot.data;
//                    }
//                    return
//                  } else {
//                    return Center(child: Text("Loading"),);
//                  }
//                },
//              )
            ],
          )
      ),
    );
  }
}
