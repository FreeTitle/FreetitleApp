import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        /* User Avatar */
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
                borderRadius:
                const BorderRadius.all(Radius.circular(25.0)),
                child: Image.asset(
                  'assets/event.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Amanda Liu", /* UserName */
                  style: GoogleFonts.galdeano(
                      textStyle: Theme.of(context).textTheme.bodyText2),
                ),
                SizedBox(width: 7),
                Text(
                  "· Freelance Photographer", /* User Label */
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
            SizedBox(height: 3),
            Text(
              "5 mins ago",
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
      ],
    );
  }
}