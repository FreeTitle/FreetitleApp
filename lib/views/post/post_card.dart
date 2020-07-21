import 'package:flutter/material.dart';
import 'package:freetitle/views/post/blog/blog_post.dart';
import 'package:freetitle/views/post/common/post_title.dart';
import 'package:freetitle/views/post/common/post_bottom.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/post/multiple/multiple_photo.dart';
import 'package:freetitle/views/post/single/single_photo.dart';
import 'package:google_fonts/google_fonts.dart';

class PostCard extends StatefulWidget {

  PostCard({
    Key key,
    this.type,
  }) : super(key: key);

  final String type;

  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  Widget getContent() {
    switch(widget.type){
      case 'single-photo':
        return SinglePhoto();
      case 'blog':
        return BlogPost();
      case 'multi-photo':
        return MultiplePhoto();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        print("${widget.type} Post Pressed");
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: 800,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                PostTitle(),
                SizedBox(
                  height: 12,
                ),
                getContent(),
                SizedBox(
                  height: 10,
                ),
                PostBottom(),
              ],
            ),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: AppTheme.grey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 10.0
                ),
              ],
            ),
          ),
          Positioned(
            top: 25,
            right: 25,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}