import 'package:flutter/material.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:freetitle/views/blog/blog_detail.dart';
import 'package:freetitle/app_theme.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogListView extends StatefulWidget {
  const BlogListView(
  {Key key,
    this.blogList,
    this.blogIDs,
    this.animationController,
  }) : super(key: key);

  final blogList;
  final blogIDs;
  final animationController;
  _BlogListView createState() => _BlogListView();

}

class _BlogListView extends State<BlogListView>{

  void getBlog(blogID){
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BlogDetail(blogID: blogID,),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    List blogList = widget.blogList;
    List blogIDs = widget.blogIDs;
    int present = blogList.length;
    int perPage = 15;
    return LiquidPullToRefresh(
        color: AppTheme.primary,
        showChildOpacityTransition: false,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          blogList = new List();
          blogIDs = new List();
          await Firestore.instance.collection('blogs').getDocuments().then((snap)=>{
            snap.documents.forEach((blog) => {
              blogList.add(blog.data),
              blogIDs.add(blog.documentID),
            }),
          });
        },
        child:ListView.builder(
          itemCount: blogList.length,
          padding: const EdgeInsets.only(top: 8),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            final int count = blogList.length;
            final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval(
                        (1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn
                    )
                )
            );
            widget.animationController
                .forward();
            return BlogCard(
                callback: () {
                  getBlog(blogIDs[index]);
                },
                blogData: blogList[index],
                animation: animation,
                animationController: widget.animationController
            );
          },
        )
    );
  }
}

