import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/bloc/post/like/bloc.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class PostBottom extends StatefulWidget {
//  PostBottom({Key key, this.likeBloc}) : super(key : key);
//  final likeBloc;
  _PostBottomState createState() => _PostBottomState();
}

class _PostBottomState extends State<PostBottom> {

  LikeBloc _likeBloc;

  @override
  void dispose() {
    _likeBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      //TODO change this
      _likeBloc = LikeBloc(postRepository: PostRepository(), postID: "WEtwpUukkeSOYECPt8dG");
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: IconButton(
                iconSize: 20,
                icon: Icon(Icons.reply),
                onPressed: () {},
              ),
            ),
            Text(
              "58 shares",
              style: GoogleFonts.galdeano(
                textStyle: Theme.of(context).textTheme.bodyText1.merge(
                  TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: IconButton(
                iconSize: 20,
                icon: Icon(Icons.comment),
                onPressed: () {},
              ),
            ),
            Text(
              "12 comments",
              style: GoogleFonts.galdeano(
                textStyle: Theme.of(context).textTheme.bodyText1.merge(
                  TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        ),
        BlocProvider<LikeBloc>(
          bloc: _likeBloc,
          child: LikeButton()
        )
      ],
    );
  }
}

class LikeButton extends StatefulWidget {
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {

  LikeBloc _likeBloc;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeBloc = BlocProvider.of<LikeBloc>(context);
    BlocProvider.of<LikeBloc>(context).dispatch(PostLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _likeBloc,
      listener: (BuildContext context, LikeState state) {
        if(state.isLike){
          isLiked = true;
          setState(() {

          });
        }
        else if(state.isUnlike){
          isLiked = false;
          setState(() {

          });
        }
        else if(state.failure_LIKE_PRESSED) {
          Toast.show("Like failed", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
      },
      child: BlocBuilder(
        bloc: _likeBloc,
        builder: (BuildContext context, LikeState state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: IconButton(
                  iconSize: 20,
                  icon: isLiked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  onPressed: () {
                    isLiked ? _likeBloc.dispatch(UnlikePressed(),) : _likeBloc.dispatch(LikePressed(),);
//                    setState(() {
//
//                    });
                  },
                ),
              ),
              Text(
                "44 likes",
                style: GoogleFonts.galdeano(
                  textStyle: Theme.of(context).textTheme.bodyText1.merge(
                    TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
