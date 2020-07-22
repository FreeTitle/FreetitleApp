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
                            padding: EdgeInsets.only(top: 40, right: 200),
                            child: Text(
                              'We Prefer:',
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
                            )),
                        Container(
                            padding: EdgeInsets.only(
                                top: 30, right: 200, bottom: 10),
                            child: Text(
                              'Members',
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
                        Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset("assets/member_placeholder.png",
                                    scale: 3),
                                Image.asset("assets/member_placeholder.png",
                                    scale: 3),
                                Image.asset("assets/member_placeholder.png",
                                    scale: 3),
                                Image.asset("assets/member_placeholder.png",
                                    scale: 3),
                              ],
                            )),
                        // Container(
                        //   padding: EdgeInsets.only(top: 60),
                        //   width: 236,
                        //   height: 40,
                        //   child:
                        InkWell(
                          onTap: () {
                            print('apply pressed');
                          },
                          child: Container(
                              width: 136,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.blue[300]),
                              child: Center(
                                  child: Text('APPLY NOW',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17)))),
                        ),
                        // ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
