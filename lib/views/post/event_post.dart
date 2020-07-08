import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class EventPost extends StatefulWidget {
  EventPostState createState() => EventPostState();
}

class EventPostState extends State<EventPost> {
  var pressAttention = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
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
                'assets/event.png',
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
                        new Material(
                          type: MaterialType.transparency,
                          child: Ink(
                            width: 45,
                            height: 45,
                            child: IconButton(
                              iconSize: 28,
                              color: Colors.teal[200],
                              icon: pressAttention ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                              onPressed: () => setState(() => pressAttention = !pressAttention),
                            ),
                          ),
                        ),
                        Spacer(),
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
                    color: Colors.teal[200],
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.share),
                    color: Colors.white,
                    onPressed: () {},
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
    );
  }
}