import 'package:flutter/material.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:freetitle/views/metadata_provider.dart';
import 'package:freetitle/views/post_card/post_card.dart';

class PostList extends StatefulWidget {
  PostList({
    Key key,
  }) : super(key: key);

  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> with AutomaticKeepAliveClientMixin {

  EasyRefreshController _easyRefreshController;
  List<PostModel> _posts = List();
  Future<List<PostModel>> _getPost;
  int postCount = 5;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
//    _getPost = PostRepository.getPosts(postCount, true);
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
        List<PostModel> newerPost = await PostRepository.getPosts(5, true);
        setState(() {
          _posts += newerPost;
          postCount = 5;
        });
        _easyRefreshController.resetRefreshState();
      },
      onLoad: () async {
        List<PostModel> newerPost = await PostRepository.getPosts(postCount, false).timeout(Duration(milliseconds: 500));
        setState(() {
          _posts += newerPost;
          postCount += newerPost.length;
        });
        _easyRefreshController.finishLoad();
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index){
            return PostCard(type: _posts[index].type, postData: _posts[index],);
          },
            childCount: postCount > _posts.length ? _posts.length : postCount,
          ),
        ),
      ],
    );
  }
}