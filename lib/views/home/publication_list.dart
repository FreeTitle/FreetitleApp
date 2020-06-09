import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/blog/blog_card.dart';
import 'package:freetitle/views/home/content_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';


class PublicationView extends StatefulWidget {
  const PublicationView (
  {Key key,
    this.contentIDs,
    this.title,
    this.cover,
    this.typeList,
  }) : super(key : key);
  final List contentIDs;
  final String title;
  final String cover;
  final List typeList;

  _PublicationView createState() => _PublicationView();
}

class _PublicationView extends State<PublicationView> with TickerProviderStateMixin {

  List contentList = List();
  AnimationController animationController;
  List typeList;

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

  Future<bool> getContent() async {
    contentList.clear();
    if(widget.typeList != null){
      for(var index = 0;index < widget.contentIDs.length;index++) {
        var contentID = widget.contentIDs[index];
        var contentType = widget.typeList[index];
        if(contentType == 'blog'){
          await Firestore.instance.collection('blogs').document(contentID).get().then((snap) {
            if(snap.data != null)
              contentList.add(snap.data);
          });
        }
        else if(contentType == 'mission'){
          await Firestore.instance.collection('missions').document(contentID).get().then((snap) {
            if(snap.data != null)
              contentList.add(snap.data);
          });
        }
        else if(contentType == 'publication'){
          await Firestore.instance.collection('publications').document(contentID).get().then((snap) {
            if(snap.data != null)
              contentList.add(snap.data);
          });
        }
      }
    }
    else{
      typeList = List();
      await Firestore.instance.collection('blogs').getDocuments().then((snap) {
        if(snap.documents.isNotEmpty){
          widget.contentIDs.forEach((id) {
            snap.documents.where((doc) => doc.documentID == id).forEach((blogSnap) {
              contentList.add(blogSnap.data);
            });
            typeList.add('blog');
          });
        }
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    typeList = widget.typeList;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.title.length > 15 ? widget.title.substring(0, 15) +  '...' : widget.title),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder<bool>(
        future: getContent(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return LiquidPullToRefresh(
              key: PageStorageKey('Publication View'),
              color: AppTheme.primary,
              showChildOpacityTransition: false,
              onRefresh: () async {
                getContent();
              },
              child: ListView.builder(
                  itemCount: contentList.length+1,
                  padding: EdgeInsets.only(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if(index == 0){
                      return SizedBox(
                        height: 200,
                        child: Image.network(widget.cover,  fit: BoxFit.cover,),
                      );
                    }
                    else{
                      final int count = contentList.length;
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
                      return AnimatedContentCard(
                        contentID: widget.contentIDs[index-1],
                        contentData: contentList[index-1],
                        contentType: typeList[index-1],
                        animationController: animationController,
                        animation: animation,
                      );
                    }
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