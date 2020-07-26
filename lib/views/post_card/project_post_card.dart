import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/bloc/post/save/bloc.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:freetitle/views/post_card/common/opportunity_save.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:freetitle/views/post_detail/project_post_detail.dart';

class ProjectPostCard extends StatefulWidget {
  _ProjectPostCardState createState() => _ProjectPostCardState();
}

class _ProjectPostCardState extends State<ProjectPostCard> {

  SaveBloc _saveBloc;

  @override
  void dispose() {
    _saveBloc.dispose();
    super.dispose();
  }

  List userName = [
    "AH",
    "MC",
    "AH",
  ];
  List<Widget> buildAvatarList(userName) {
    List<Widget> avatarList = List();
    for (var i in userName) {
      avatarList.add(
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: FittedBox(
                fit: BoxFit.fill, // otherwise the logo will be tiny
                child: CircleAvatar(
                  radius: 19,
                  backgroundColor: Colors.orange[100],
                  child: Text(i),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return avatarList;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    setState(() {
      //TODO change this
      _saveBloc = SaveBloc(postRepository: PostRepository(), postID: "C9SuEe1ySPg5M1WjNDPz");
    });

    return InkWell(
        onTap: () {
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ProjectPostDetail(),
            ),
          );
        },
        child: Container(
          height: 400,
          width: screenSize.width,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  width: screenSize.width,
                  height: 340,
                  child: Image.asset(
                    'assets/placeholders/event.png',
                    scale: 1.0,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    height: 180,
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Nocturnal Wonderland Photography of The Year Competition",
                          style: GoogleFonts.galdeano(
                              textStyle: TextStyle(fontSize: 18)),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Text("We are looking for: ",
                                style: GoogleFonts.galdeano(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(TextStyle(
                                          fontSize: 14,
                                        )))),
                            SizedBox(width: 10),
                            Text("photography",
                                style: GoogleFonts.galdeano(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue[700],
                                        )))),
                            SizedBox(
                              width: 10,
                            ),
                            Text("graphic design",
                                style: GoogleFonts.galdeano(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue[700],
                                        )))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.place, color: Colors.grey, size: 20),
                            Text("Apply Anywhere ",
                                style: GoogleFonts.galdeano(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        )))),
                            SizedBox(width: 80),
                            Icon(Icons.schedule, color: Colors.grey, size: 20),
                            Text("2 days left",
                                style: GoogleFonts.galdeano(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        )))),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            BlocProvider(
                              bloc: _saveBloc,
                              child: SaveButton(type: PostType.project,),
                            ),
                            Spacer(),
                            Container(
                              height: 38,
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "3 people have applied",
                                style: GoogleFonts.galdeano(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            RowSuper(
                              children: buildAvatarList(userName),
                              innerDistance: -10.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 20, top: 20),
                  alignment: Alignment.topRight,
                  width: 1000,
                  height: 400,
                  child: new Material(
                    type: MaterialType.transparency,
                    child: Ink(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Colors.teal[200],
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        iconSize: 22,
                        icon: Icon(Icons.share),
                        color: Colors.white,
                        onPressed: () {
                          print("Project share pressed");
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
                  blurRadius: 10.0),
            ],
          ),
        ));
  }
}
