import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MultiplePhotoPostDetail extends StatefulWidget {
  MultiplePhotoPostDetailState createState() => MultiplePhotoPostDetailState();
}

final List<String> imgList = [
  'assets/1.png',
  'assets/2.png',
  'assets/3.png',
  'assets/4.png',
  'assets/5.png'
];

final int totalImg = imgList.length;

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
              child: Stack(
            children: <Widget>[
              Container(
                child: Image.asset(item),
              ),
            ],
          )),
        ))
    .toList();

class MultiplePhotoPostDetailState extends State<MultiplePhotoPostDetail> {
  var pressAttention = false;
  var pressAttention2 = false;
  Color iconColor = Colors.grey;
  int liked = 322;
  int one = 1;
  int current = 0;
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Container(
          padding: EdgeInsets.only(
            right: 20,
          ),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/user_pic.png'),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Amanda Liu',
                    style: GoogleFonts.galdeano(
                      textStyle: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(
                              fontSize: 16,
                            ),
                          ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Freelance Photographer',
                    style: GoogleFonts.galdeano(
                      textStyle: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(
                              fontSize: 13,
                            ),
                          ),
                    ),
                  )
                ],
              ),
              Spacer(),
              Container(
                height: 30,
                width: 91,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      setState(() => pressAttention = !pressAttention);
                      print("Follow pressed");
                    },
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          pressAttention
                              ? SizedBox(width: 0)
                              : Icon(Icons.add,
                                  color: Color(0xff77E2C4), size: 15),
                          pressAttention
                              ? SizedBox(width: 0)
                              : SizedBox(width: 2),
                          Text(
                            pressAttention ? "FOLLOWED" : "FOLLOW",
                            style: GoogleFonts.dosis(
                              textStyle:
                                  Theme.of(context).textTheme.bodyText1.merge(
                                        TextStyle(
                                          fontSize: 15,
                                          color: pressAttention
                                              ? Color(0xff707070)
                                              : Color(0xff77E2C4),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                      color: pressAttention
                          ? Color(0xff707070)
                          : Color(0xff77E2C4),
                      width: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                      width: screenSize.width,
                      height: screenSize.height / 3.3,
                      child: Stack(
                        children: <Widget>[
                          CarouselSlider(
                            options: CarouselOptions(
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    current = index + 1;
                                  });
                                }),
                            items: imageSliders,
                          ),
                          Positioned(
                            bottom: 240.0,
                            left: 370.0,
                            right: 10.0,
                            child: Container(
                              child: Text(
                                '$current/$totalImg',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dosis(
                                  textStyle: 
                                        TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                      ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                border:
                                    Border.all(color: Color(0x2D2A2B), width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(width: 20, height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 20, height: 20),
                      Text(
                        'Tags',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText2.merge(
                                    TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'Film',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        child: Image.asset('assets/shape.png'),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Visual art',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        child: Image.asset('assets/shape.png'),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Movie',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        child: Image.asset('assets/shape.png'),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Avant-garde',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20),
                      Container(
                        width: 379,
                        height: 137,
                        child: Text(
                          'Un Chien Andalou has no plot in the conventional sense of the word. The chronology of the film is disjointed, jumping from the initial “once upon a time” to “eight years later” without the events or characters changing. It uses dream logic in narrative flow that can be described in terms of then-popular Freudian free association, presenting a series of tenuously related scenes.',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.galdeano(
                            textStyle:
                                Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff565254),
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 373,
                    height: 514,
                    child: Text(
                      'Last edit: June 26, 2020',
                      style: GoogleFonts.galdeano(
                        textStyle: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 70,
            width: 414,
            padding: EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 35,
                  width: 90,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {
                        setState(() => pressAttention2 = !pressAttention2);
                        print("Project save pressed");
                      },
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Icon(pressAttention2 ? Icons.done : Icons.favorite,
                                color: pressAttention2
                                    ? Colors.blue[300]
                                    : Colors.white,
                                size: 15),
                            SizedBox(width: pressAttention2 ? 3 : 10),
                            Text(
                              pressAttention2 ? "SAVED" : "SAVE",
                              style: GoogleFonts.galdeano(
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize: 17,
                                            color: pressAttention2
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
                    color: pressAttention2 ? Colors.white : Colors.blue[300],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Colors.blue[300], width: 1.5),
                  ),
                ),
                SizedBox(width: 180),
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Icon(
                        Icons.share,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        '107',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        '37',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 1.5),
                      Container(
                        width: 36,
                        height: 20,
                        child: IconButton(
                          icon: Icon(Icons.thumb_up),
                          color: iconColor,
                          iconSize: 20,
                          onPressed: () {
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
                      SizedBox(height: 8.5),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
