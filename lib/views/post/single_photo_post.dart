import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SinglePhotoPost extends StatefulWidget {
  SinglePhotoPostState createState() => SinglePhotoPostState();
}

class SinglePhotoPostState extends State<SinglePhotoPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: 800,
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
                    onTap: () {},
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
                        "Amanda Liu",
                        style: GoogleFonts.galdeano(
                            textStyle: Theme.of(context).textTheme.bodyText2),
                      ),
                      SizedBox(width: 7),
                      Text(
                        "· Freelance Photographer",
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
              SizedBox(
                width: 22,
              ),
              Material(
                type: MaterialType.transparency,
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "My favorite movie",
            style: GoogleFonts.galdeano(
              textStyle: Theme.of(context).textTheme.bodyText1.merge(
                    TextStyle(
                      fontSize: 15,
                    ),
                  ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 170,
            width: 400,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(13.0)),
              child: Image.asset('assets/event.png', fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                type: MaterialType.transparency,
                child: Container(
                  child: IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.reply),
                    onPressed: () {},
                  ),
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
              SizedBox(
                width: 15,
              ),
              Material(
                type: MaterialType.transparency,
                child: Container(
                  child: IconButton(
                    iconSize: 25,
                    icon: Icon(Icons.comment),
                    onPressed: () {},
                  ),
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
              SizedBox(
                width: 15,
              ),
              Material(
                type: MaterialType.transparency,
                child: Container(
                  child: IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.thumb_up),
                    onPressed: () {},
                  ),
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
          ),
        ],
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
    );
  }
}
