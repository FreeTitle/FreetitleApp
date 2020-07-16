import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class Comment extends StatefulWidget {
  CommentState createState() => CommentState();
}

class CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 60,
            width: screenSize.width,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.8,
                ),
              ),
              ),
            child: Row(
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 28,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 95,
                ),
                Text(
                  "37 Comments",
                  style: GoogleFonts.galdeano(
                    textStyle: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
