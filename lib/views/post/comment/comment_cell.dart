import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class CommentCell extends StatefulWidget {
  CommentCellState createState() => CommentCellState();
}

class CommentCellState extends State<CommentCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: Container(
              height: 45,
              width: 45,
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
          
        ],
      ),
    );
  }
}
