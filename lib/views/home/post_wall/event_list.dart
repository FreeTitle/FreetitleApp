import 'package:flutter/material.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:freetitle/views/metadata_provider.dart';
import 'package:freetitle/views/post_card/event_post_card.dart';
import 'package:freetitle/views/post_card/post_card.dart';

class EventList extends StatefulWidget {
  EventList({
    Key key,
  }) : super(key: key);

  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> with AutomaticKeepAliveClientMixin {

  EasyRefreshController _easyRefreshController;
  List<PostModel> _posts = List();
  Future<List<PostModel>> _getPost;
  int postCount = 5;
  ScrollController _scrollController;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _easyRefreshController = EasyRefreshController();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.custom(
      enableControlFinishRefresh: false,
      enableControlFinishLoad: false,
      controller: _easyRefreshController,
      header: ClassicalHeader(),
      footer: ClassicalFooter(),
      firstRefresh: true,
      scrollDirection: Axis.horizontal,
      scrollController: _scrollController,
      onRefresh: () async {
        List<PostModel> newerPost = await PostRepository.get5DummyEvents();
        setState(() {
          _posts += newerPost;
          postCount = 5;
        });
        _easyRefreshController.resetRefreshState();
      },
      onLoad: () async {
        List<PostModel> newerPost = await PostRepository.get5DummyEvents();
        setState(() {
          _posts += newerPost;
          postCount += newerPost.length;
        });
        _easyRefreshController.finishLoad();
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index){
            return EventPostCard();
          },
            childCount: postCount > _posts.length ? _posts.length : postCount,
          ),
        ),
      ],
    );
  }
}