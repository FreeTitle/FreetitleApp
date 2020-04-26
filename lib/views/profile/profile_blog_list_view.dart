import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/blog/blog_detail.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ProfileBlogListView extends StatefulWidget {

  const ProfileBlogListView({Key key,
    this.ownerID,
    this.scrollController,
  }) : super(key: key);

  final ownerID;
  final scrollController;
  _ProfileBlogListView createState() => _ProfileBlogListView();
}

class _ProfileBlogListView extends State<ProfileBlogListView> with TickerProviderStateMixin{
  AnimationController animationController;

  @override
  void initState(){
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this
    );
    super.initState();
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  void getBlog(blog){
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BlogDetail(blogID: blog,),
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    List blogList;
    List blogIDs;
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('blogs').where('user', isEqualTo: widget.ownerID).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState){
              case ConnectionState.waiting:
                return new SingleChildScrollView(
                  controller: widget.scrollController,
                  child: PlaceHolderCard(text: 'Loading...', height: 200.0,),
                );
              default:
                if (snapshot.hasData) {
                  blogList = List();
                  blogIDs = List();
                  snapshot.data.documents.forEach((blog) {
                    blogList.add(blog.data);
                    blogIDs.add(blog.documentID);
                  });
                  if(blogList.isEmpty){
                    return SingleChildScrollView(
                      controller: widget.scrollController,
                      child: PlaceHolderCard(text: 'No blogs yet', height: 200.0,),
                    );
                  }
                  return ProfileBlogList(animationController: animationController, scrollController: widget.scrollController, blogIDs: blogIDs, blogList: blogList,);
                }
                else{
                  return SingleChildScrollView(
                    controller: widget.scrollController,
                    child: PlaceHolderCard(text: 'No blogs yet', height: 200.0,),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}


class ProfileBlogList extends StatefulWidget {

  const ProfileBlogList({Key key, this.animationController, this.scrollController, this.blogList, this.blogIDs}) : super(key:key);

  final animationController;
  final scrollController;
  final blogList;
  final blogIDs;

  _ProfileBlogListState createState() => _ProfileBlogListState();
}

class _ProfileBlogListState extends State<ProfileBlogList> with TickerProviderStateMixin {

  List<Widget> buildBlogList(blogList, blogIDs){

    final animationController = widget.animationController;

    List<Widget> blogsWidget = List();
    for(var i = 0;i < blogList.length;i++) {
      final int count = blogList.length;
      final Animation<double> animation = Tween<double>(
          begin: 0.0, end: 1.0)
          .animate(
          CurvedAnimation(
              parent: animationController,
              curve: Interval(
                  (1 / count) * i, 1.0,
                  curve: Curves.fastOutSlowIn
              )
          )
      );
      animationController
          .forward();
      blogsWidget.add(
          AnimatedBlogCard(
              blogID: blogIDs[i],
              blogData: blogList[i],
              animation: animation,
              animationController: animationController
          )
      );
    }
    return blogsWidget;
  }

  @override
  Widget build(BuildContext context) {

    if(widget.blogList.length == 0){
      return SingleChildScrollView(
        controller: widget.scrollController,
        child: PlaceHolderCard(text: 'No blogs yet', height: 200.0,)
      );
    }
    else{
      return SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildBlogList(widget.blogList, widget.blogIDs),
        ),
      );
    }
  }
}