import 'package:flutter/material.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:freetitle/app_theme.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogListView extends StatefulWidget {
  const BlogListView(
  {Key key,
    this.scrollController,
  }) : super(key: key);

  final scrollController;
  _BlogListView createState() => _BlogListView();

}

class _BlogListView extends State<BlogListView> with TickerProviderStateMixin {

  int perPage = 15;
  int pageCount = 1;

  AnimationController animationController;

  @override void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List blogList = new List();
    List blogIDs = new List();

    return StreamBuilder<QuerySnapshot>(
        key: PageStorageKey('Blogs'),
        stream: Firestore.instance.collection('blogs').limit(pageCount*perPage).orderBy('time', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            default:
              if (snapshot.hasData) {
                blogList = new List();
                blogIDs = new List();
                snapshot.data.documents.forEach((blog) => {
                  blogList.add(blog.data),
                  blogIDs.add(blog.documentID),
                });
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
                            parent: animationController,
                            curve: Interval(
                                (1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn
                            )
                        )
                        );
                        animationController.forward();
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
                        AnimatedBlogCard(
                            blogID: blogIDs[index],
                            blogData: blogList[index],
                            animation: animation,
                            animationController: animationController
                        );
                      },
                    )
                );
              }
              else{
                return new Text("Something is wrong with firebase");
              }
          }
        }
    );
  }
}

