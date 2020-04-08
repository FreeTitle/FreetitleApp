import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/blog/blog_detail.dart';

class AnimatedBlogCard extends StatefulWidget {
  const AnimatedBlogCard({Key key,
    this.blogID,
    this.blogData,
    this.animationController,
    this.animation,})
      : super(key: key);

  final Map blogData;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final String blogID;

  _AnimatedBlogCard createState() => _AnimatedBlogCard();
}

class _AnimatedBlogCard extends State<AnimatedBlogCard>{
  @override
  Widget build(BuildContext context) {
    final animation = widget.animation;
    final animationController = widget.animationController;
    final blogData = widget.blogData;
    final blogID = widget.blogID;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child){
        return FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation.value), 0.0
              ),
              child: BlogCard(blogID: blogID, blogData: blogData,)
          ),
        );
      },
    );
  }
}

class BlogCard extends StatefulWidget {
  const BlogCard({Key key,
    this.blogID,
    this.blogData,
})
      : super(key: key);

  final Map blogData;
  final String blogID;

  _BlogCard createState() => _BlogCard();
}

class _BlogCard extends State<BlogCard>{
  final keyBlogDetail = PageStorageKey('blogDetail');
  String author = 'FreeTitle Author';

  @override
  void initState(){
    super.initState();
  }

  Image getBlogImage(){
    Image img;
    final blogData = widget.blogData;
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
    final blogID = widget.blogID;
    final blogData = widget.blogData;
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 8, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => BlogDetail(key: keyBlogDetail,blogID: blogID,),
              )
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
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
                      child: getBlogImage(),
                    ),
                    Container(
                      color: AppTheme.buildLightTheme().backgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      blogData['title'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        StreamBuilder<DocumentSnapshot>(
                                          stream: Firestore.instance.collection('users').document(blogData['user']).snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                                            if (snapshot.hasError)
                                              return new Text('Error: ${snapshot.error}');
                                            switch(snapshot.connectionState){
                                              case ConnectionState.waiting:
                                                return new Text(
                                                    'FreeTitle Author',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey
                                                    )
                                                );
                                              default:
                                                if(snapshot.data.data != null){
                                                  return Text(
                                                      snapshot.data.data['displayName'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey
                                                      ));
                                                }
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 2,
                                            child: Container(
//                                                      width: MediaQuery.of(context).size.width/5,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 3,
                                                    child: Icon(
                                                        Icons.remove_red_eye
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      blogData['views'] != null ? blogData['views'].toString() : '0',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey
                                                              .withOpacity(0.8)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
//                                                      width: MediaQuery.of(context).size.width/5,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 3,
                                                    child: Icon(
                                                      Icons.favorite,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      blogData['likes'].toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey
                                                              .withOpacity(0.8)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
//                                                      width: MediaQuery.of(context).size.width/5,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 3,
                                                    child: Icon(
                                                      Icons.bookmark,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      blogData['markedBy'] != null ? blogData['markedBy'].length.toString() : '0' ,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey
                                                              .withOpacity(0.8)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
//                                                      width: MediaQuery.of(context).size.width/5,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    flex: 3,
                                                    child: Icon(
                                                      Icons.comment,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    child: Text(
                                                      blogData['comments'] != null ? blogData['comments'].length.toString() : '0' ,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey
                                                              .withOpacity(0.8)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
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
