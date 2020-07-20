import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:freetitle/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProjectPostDetail extends StatefulWidget {
  _ProjectPostDetailState createState() => _ProjectPostDetailState();
}

class _ProjectPostDetailState extends State<ProjectPostDetail> {
  var pressSaved = false;
  String testData =
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam.\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam.\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam.";

  @override
  Widget build(BuildContext context) {
    // final _markDownData =
    //     testData.map((x) => "- $x\n").reduce((x, y) => "$x$y");
    return Scaffold(
        appBar: AppBar(title: Text('Project detail')),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Image.asset('assets/project_placeholder1.png'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 260),
                child: Container(
                    padding: EdgeInsets.only(left: 43, right: 43),
                    width: 410,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Container(
                        //     padding: EdgeInsets.only(top: 30),
                        //     child: Markdown(data: _markDownData)),
                        Container(
                            padding: EdgeInsets.only(top: 61),
                            child: Text(
                              'Boardgame Design Collaboration',
                              style: GoogleFonts.galdeano(
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et.',
                              style: GoogleFonts.galdeano(
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                              ),
                            )),
                        Image.asset('assets/project_placeholder2.png'),
                        Text(
                            'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et.',
                            style: GoogleFonts.galdeano(
                              textStyle:
                                  Theme.of(context).textTheme.bodyText1.merge(
                                        TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                            )),
                        Container(
                            height: 50,
                            width: 400,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 90,
                                  child: Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                          onTap: () {
                                            setState(
                                                () => pressSaved = !pressSaved);
                                          },
                                          highlightColor: Colors.transparent,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                      pressSaved
                                                          ? Icons.done
                                                          : Icons.favorite,
                                                      color: pressSaved
                                                          ? Theme.of(context)
                                                              .highlightColor
                                                          : Colors.white,
                                                      size: 15),
                                                  Text(
                                                      pressSaved
                                                          ? "SAVED"
                                                          : " SAVE",
                                                      style:
                                                          GoogleFonts.galdeano(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .merge(
                                                                      TextStyle(
                                                                    fontSize:
                                                                        19,
                                                                    color: pressSaved
                                                                        ? Theme.of(context)
                                                                            .highlightColor
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ))))
                                                ],
                                              )))),
                                  decoration: BoxDecoration(
                                    color: pressSaved
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).highlightColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                        width: 1.5),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 150, top: 12),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.share,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      Text(
                                        '107',
                                        style: GoogleFonts.galdeano(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(
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
                                Container(
                                  padding: EdgeInsets.only(left: 12, top: 12),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.comment,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      Text(
                                        '37',
                                        style: GoogleFonts.galdeano(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(
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
                                Container(
                                  padding: EdgeInsets.only(left: 12, top: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.thumb_up,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                      Text(
                                        '321',
                                        style: GoogleFonts.galdeano(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(
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
                              ],
                            )),
                        Container(
                          height: 218,
                          child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return Image.asset(
                                  "assets/project_placeholder3.png",
                                  fit: BoxFit.fill,
                                );
                              },
                              itemCount: 3,
                              pagination: new SwiperPagination(),
                              control: new SwiperControl()),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 40, right: 100),
                            child: Text(
                              'We Prefer:                        ',
                              style: GoogleFonts.galdeano(
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                              ),
                            )),
                        ListTile(
                            title: Text(''),
                            subtitle: Column(
                              children: LineSplitter.split(testData).map((o) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('• '),
                                    Expanded(
                                      child: Text(
                                        o,
                                        style: GoogleFonts.galdeano(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(
                                                TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ))
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
