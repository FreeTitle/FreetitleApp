import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/detail/blog_detail.dart';
import 'package:freetitle/views/home/blog_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyBlogListView extends StatefulWidget {

  const MyBlogListView({Key key,
    this.ownerID

  }) : super(key: key);

  final ownerID;
  _MyBlogListView createState() => _MyBlogListView();
}

class _MyBlogListView extends State<MyBlogListView> with TickerProviderStateMixin{
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

//  Widget noBlogWidget() {
//    return Padding(
//      padding: EdgeInsets.only(left: 24, right: 24),
//      child: Card(
//        child: Container(
//          height: 200,
//          child: Center(
//            child: Container(
//              child: Text(
//                  'No blogs yet'
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  void getBlog(blog){
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BlogDetail(blogID: blog,),
        )
    );
  }

  List<Widget> buildBlogList(blogList, blogIDs){
    List<Widget> blogsWidget = List();
    for(var i = 0;i < blogList.length;i++){
      final blog = blogList[i];
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
          BlogCard(
              callback: () {
                getBlog(blogIDs[i]);
              },
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
                return new Text('Loading');
              default:
                if (snapshot.hasData) {
                  blogList = List();
                  blogIDs = List();
                  snapshot.data.documents.forEach((blog) => {
                    blogList.add(blog.data),
                    blogIDs.add(blog.documentID),
                  });
                  if(blogList.isEmpty){
                    return PlaceHolderCard(text: 'No blogs yet', height: 200.0,);
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildBlogList(blogList, blogIDs),
                  );
                }
                else{
                  return PlaceHolderCard(text: 'No blogs yet', height: 200.0,);
                }
            }
          },
        ),
      ),
    );
  }
}