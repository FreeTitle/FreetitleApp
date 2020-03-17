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
    this.scrollController,
  }) : super(key: key);

  final blogList;
  final blogIDs;
  final animationController;
  final scrollController;
  _BlogListView createState() => _BlogListView();

}

class _BlogListView extends State<BlogListView>{

  int perPage = 15;
  int pageCount = 1;

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

    return LiquidPullToRefresh(
        scrollController: widget.scrollController,
        color: AppTheme.primary,
        showChildOpacityTransition: false,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 500));
          blogList.clear();
          blogIDs.clear();

          await Firestore.instance.collection('blogs').limit(15).orderBy('time', descending: true).getDocuments().then((snap)=>{
            snap.documents.forEach((blog) => {
              blogList.add(blog.data),
              blogIDs.add(blog.documentID),
            }),
            present = blogList.length,
            pageCount = 1,
          });
          setState(() {

          });
        },
        child:ListView.builder(
          itemCount: present < perPage * pageCount ? present : present + 1,
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
            return (index == present) ?
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Container(
                color: AppTheme.grey,
                child: FlatButton(
                  child: Text("Load More", style: TextStyle(color: AppTheme.primary),),
                  onPressed: () async {
                    pageCount += 1;
                    blogList.clear();
                    blogIDs.clear();
                    await Firestore.instance.collection('blogs').limit(pageCount*perPage).orderBy('time', descending: true).getDocuments().then((snap) => {
                      snap.documents.forEach((blog) => {
                        blogList.add(blog.data),
                        blogIDs.add(blog.documentID),
                      }),
                      present = blogList.length,
                    });
                    setState(() {

                    });
                  },
                ),
              ),
            )
                :
            BlogCard(
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

