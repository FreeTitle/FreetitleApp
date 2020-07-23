import 'package:flutter/material.dart';
import 'package:freetitle/bloc/post/like/bloc.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:freetitle/views/post/blog/blog_post.dart';
import 'package:freetitle/views/post/common/post_title.dart';
import 'package:freetitle/views/post/common/post_bottom.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/post/multiple/multiple_photo.dart';
import 'package:freetitle/views/post/single/single_photo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {

  PostCard({
    Key key,
    this.type,
    this.postData
  }) : super(key: key);

  final PostType type;
  final PostModel postData;

  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {


  Widget getContent() {
    switch(widget.type){
      case PostType.single_photo:
        return SinglePhoto(postData: widget.postData,);
      case PostType.blog:
        return BlogPost();
      case PostType.multiple_photo:
        return MultiplePhoto(postData: widget.postData,);
      default:
        return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
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
    );
  }
}