import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/bloc/post/save/bloc.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:freetitle/views/post_card/common/opportunity_save.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPostCard extends StatefulWidget {
  _EventPostCardState createState() => _EventPostCardState();
}

class _EventPostCardState extends State<EventPostCard> {

  SaveBloc _saveBloc;

  @override
  void dispose() {
    _saveBloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    setState(() {
      //TODO change this
      _saveBloc = SaveBloc(postRepository: PostRepository(), postID: "C9SuEe1ySPg5M1WjNDPz");
    });

    return Container(
      width: 210,
      height: 250,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              width: 210,
              height: 250,
              child: Image.asset(
                'assets/placeholders/event.png',
                scale: 0.1,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                width: 210,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Nocturnal Wonderland Photography of The Year Competition",
                      style: GoogleFonts.galdeano(
                          textStyle: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        BlocProvider<SaveBloc>(
                          bloc: _saveBloc,
                          child: SaveButton(type: PostType.event,),
                        ),
                        Spacer(),
                        Icon(Icons.schedule, color: Colors.grey, size: 20),
                        Text("2 days left",
                          style: GoogleFonts.galdeano(
                            textStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .merge(
                              TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              )
                            )
                          )
                        ),
                        SizedBox(width: 5,)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 12, top: 12),
              alignment: Alignment.topRight,
              width: 1000,
              height: 400,
              child: new Material(
                type: MaterialType.transparency,
                child: Ink(
                  width: 36,
                  height: 36,
                  decoration: ShapeDecoration(
                    color: Theme.of(context).highlightColor,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.share),
                    color: Colors.white,
                    onPressed: () {
                      print("Event share button pressed");
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.2),
            offset: Offset(1.1, 1.1),
            blurRadius: 10.0
          ),
        ],
      ),
    );
  }
}