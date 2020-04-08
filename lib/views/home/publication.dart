import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';


class PublicationView extends StatefulWidget {
  const PublicationView (
  {Key key,
    this.blogIDs,
    this.title,
  }) : super(key : key);
  final List blogIDs;
  final String title;

  _PublicationView createState() => _PublicationView();
}

class _PublicationView extends State<PublicationView> with TickerProviderStateMixin {

  List blogList = List();
  AnimationController animationController;

  @override
  void initState(){
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

  Future<bool> getBlogs() async {
    blogList.clear();
    await Firestore.instance.collection('blogs').getDocuments().then((snap) {
      if(snap.documents.isNotEmpty){
        snap.documents.forEach((blogSnap) {
          if(widget.blogIDs.contains(blogSnap.documentID)){
            blogList.add(blogSnap.data);
          }
        });
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.title.substring(0, 15) +  '...', style: TextStyle(color: Colors.black),),
      ),
      body: FutureBuilder<bool>(
        future: getBlogs(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return LiquidPullToRefresh(
              color: AppTheme.primary,
              showChildOpacityTransition: false,
              onRefresh: () async {
                getBlogs();
              },
              child: ListView.builder(
                  itemCount: blogList.length,
                  padding: EdgeInsets.only(top: 8),
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
                    return AnimatedBlogCard(
                      blogID: widget.blogIDs[index],
                      blogData: blogList[index],
                      animation: animation,
                      animationController: animationController,
                    );
                  }
              ),
            );
          }
          else{
            return Center(
              child: Text('Loading'),
            );
          }
        },
      ),
    );
  }
}