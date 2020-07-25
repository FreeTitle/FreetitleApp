import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:freetitle/views/metadata_provider.dart';
import 'package:freetitle/views/post_card/event_post_card.dart';
import 'package:freetitle/views/post_card/project_post_card.dart';
import 'package:freetitle/views/home/post_wall/event_list.dart';

class OpportunityList extends StatefulWidget {
  OpportunityList({
    Key key,
  }) : super(key: key);

  _OpportunityListState createState() => _OpportunityListState();
}

class _OpportunityListState extends State<OpportunityList> with AutomaticKeepAliveClientMixin {

  EasyRefreshController _easyRefreshController;
  List<PostModel> _posts = List();
  int postCount = 5;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();

  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.custom(
      enableControlFinishRefresh: false,
      enableControlFinishLoad: true,
      controller: _easyRefreshController,
      header: ClassicalHeader(),
      footer: ClassicalFooter(),
      firstRefresh: true,
      onRefresh: () async {
        List<PostModel> newerPost = await PostRepository.get5DummyProjects();
        setState(() {
          _posts += newerPost;
          postCount = 5;
        });
        _easyRefreshController.resetRefreshState();
      },
      onLoad: () async {
        List<PostModel> newerPost = await PostRepository.get5DummyProjects();
        setState(() {
          _posts += newerPost;
          postCount += newerPost.length;
        });
        _easyRefreshController.finishLoad();
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index){
            if(index == 0){
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/placeholders/label_event.png',
                      scale: 2,
                    ),
                  ),
                  Container(
                    height: 300,
                    child: EventList(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/placeholders/label_project.png',
                      scale: 2,
                    ),
                  ),
                ],
              );
            }
            else {
              return ProjectPostCard();
            }
          },
            childCount: postCount > _posts.length ? _posts.length+1 : postCount+1,
          ),
        ),
      ],
    );
  }
}