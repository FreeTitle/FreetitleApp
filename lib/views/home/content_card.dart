import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/blog/blog_detail.dart';
import 'package:freetitle/views/mission/mission_detail.dart';
import 'package:freetitle/views/home/publication_list.dart';

class AnimatedContentCard extends StatefulWidget {
  const AnimatedContentCard({Key key,
    @required this.contentID,
    @required this.contentData,
    @required this.contentType,
    @required this.animationController,
    @required this.animation,})
      : super(key: key);

  final Map contentData;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final String contentID;
  final String contentType;

  _AnimatedContentCardState createState() => _AnimatedContentCardState();
}

class _AnimatedContentCardState extends State<AnimatedContentCard>{
  @override
  Widget build(BuildContext context) {
    final animation = widget.animation;
    final animationController = widget.animationController;
    final blogData = widget.contentData;
    final blogID = widget.contentID;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child){
        return FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation.value), 0.0
              ),
              child: ContentCard(contentID: blogID, contentData: blogData, contentType: widget.contentType,)
          ),
        );
      },
    );
  }
}

class ContentCard extends StatefulWidget {
  const ContentCard({Key key,
    @required this.contentID,
    @required this.contentData,
    @required this.contentType,
  })
      : super(key: key);

  final Map contentData;
  final String contentID;
  final String contentType;

  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard>{
//  final keyContentDetail = PageStorageKey('blogDetail');
  String author;

  @override
  void initState(){
    super.initState();
  }

  String getTitle() {
    if(widget.contentType == 'mission'){
      return widget.contentData['name'];
    }
    else {
      return widget.contentData['title'];
    }
  }

  Image getImage(){
    Image img;
    final blogData = widget.contentData;
    if (blogData.containsKey('cover')){
      img = Image.network(blogData['cover'], fit: BoxFit.cover,);
    }
    else if(blogData['article'] != null){
      for(var block in blogData['article']['blocks']){
        if(block['type'] == "image"){
          if(block['data']['file']['url'] != null){
            img = Image.network(block['data']['file']['url'], fit: BoxFit.cover,);
            break;
          }
        }
      }
    }

    if(img == null){
      img = Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.cover,);
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    final contentID = widget.contentID;
//    final contentData = widget.contentData;
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 8, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if(widget.contentType == 'blog'){
            Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => BlogDetail(blogID: contentID,),
                )
            );
          }
          else if (widget.contentType == 'mission') {
            Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MissionDetail(missionID: contentID,)
                )
            );
          }
          else if(widget.contentType == 'publication') {
            Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => PublicationView(contentIDs: widget.contentData['blogIDList'], title: widget.contentData['title'], cover: widget.contentData['cover'], typeList: widget.contentData['typeList'],)
                )
            );
          }

        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).primaryColorLight.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,
                      child: getImage(),
                    ),
                    Container(
                      color: Theme.of(context).primaryColorDark,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      getTitle(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
