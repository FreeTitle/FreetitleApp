import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostBottom extends StatefulWidget {
  _PostBottomState createState() => _PostBottomState();
}

class _PostBottomState extends State<PostBottom> {
  @override
  Widget build(BuildContext context) {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: IconButton(
                iconSize: 20,
                icon: Icon(Icons.thumb_up),
                onPressed: () {},
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
        )
      ],
    );
  }
}