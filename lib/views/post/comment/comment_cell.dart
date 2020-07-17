import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class CommentCell extends StatefulWidget {
  CommentCellState createState() => CommentCellState();
}

class CommentCellState extends State<CommentCell> {
  Color iconColor = Colors.grey;
  int liked = 322;
  int one = 1;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.yellow,
      width: screenSize.width,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Flexible(
          flex: 1,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    print("Avatar Pressed");
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    child: Image.asset(
                      'assets/placeholders/event.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ),
          SizedBox(width: 13),
          Flexible(
          flex: 5,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Amanda Liu",
                        /* UserName */
                        style: GoogleFonts.galdeano(
                            textStyle: Theme.of(context).textTheme.bodyText2),
                      ),
                      SizedBox(width: 7),
                      Text(
                        "· Freelance Photographer",
                        /* User Label */
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    "This is an example of comment. It can be broken into paragraphs.",
                    style: GoogleFonts.galdeano(
                      textStyle: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(
                              fontSize: 15,
                              color: Colors.grey[800],
                            ),
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "5 mins ago",
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 20,
                        width: 20,
                        child: InkWell(
                          child:
                              Icon(Icons.comment, color: Colors.grey, size: 20),
                          onTap: () {
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Colors.white,
                                  height: 820,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        '$liked',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 12,
                                      color: (iconColor == Colors.grey)
                                          ? Colors.grey
                                          : Color(0xff8199E5),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(width: 4,),
                      Container(
                        width: 20,
                        height: 20,
                        child: InkWell(
                          child: Icon(
                            Icons.thumb_up,
                            color: iconColor,
                            size: 20,
                          ),
                          onTap: () {
                            setState(() {
                              if (iconColor == Colors.grey) {
                                iconColor = Color(0xff8199E5);
                                liked += one;
                              } else {
                                iconColor = Colors.grey;
                                liked -= one;
                              }
                            });
                          },
                        ),
                      ),
                      // SizedBox(
                      //   width: 20,
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}
