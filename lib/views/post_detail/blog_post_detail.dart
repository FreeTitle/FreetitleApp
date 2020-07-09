import 'package:flutter/material.dart';

class BlogPostDetail extends StatefulWidget {
  BlogPostDetailState createState() => BlogPostDetailState();
}

class BlogPostDetailState extends State<BlogPostDetail> {
  @override
  Widget build(BuildContext context) {
    var pressAttention = false; 
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/user_pic.png'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Amanda Liu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Grill Sans',
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Freelance Photographer',
                    style: TextStyle(
                      fontFamily: 'Grill Sans',
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Container(
                height: 35,
                width: 92,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {},
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add,
                              color: Color(0xff77E2C4),
                              size: 15),
                          SizedBox(width: 3),
                          Text(
                            pressAttention ? "SAVED" : "SAVE",
                            style: GoogleFonts.galdeano(
                              textStyle:
                                  Theme.of(context).textTheme.bodyText1.merge(
                                        TextStyle(
                                          fontSize: 19,
                                          color: pressAttention
                                              ? Colors.blue[300]
                                              : Colors.white,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: pressAttention ? Colors.white : Colors.blue[300],
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: Colors.blue[300], width: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
