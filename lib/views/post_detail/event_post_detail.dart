import 'dart:convert';
import 'package:freetitle/model/post_repository.dart';
import 'package:freetitle/views/post_card/post_card.dart';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:freetitle/views/post_card/common/post_title.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class EventPostDetail extends StatefulWidget {
  _EventPostDetailState createState() => _EventPostDetailState();
}

class _EventPostDetailState extends State<EventPostDetail>
    with SingleTickerProviderStateMixin {
  var pressSaved = false;
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event detail')),
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              automaticallyImplyLeading: false,
              //title: Text('Event detail'),
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  //height: double.infinity,
                  //color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[_buildBanner()],
                  )
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).highlightColor,
                unselectedLabelColor: Theme.of(context).accentColor,
                indicatorColor: Theme.of(context).highlightColor,
                tabs: [
                  Tab(text: "Detail"),
                  Tab(text: "Post"),
                ],
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(left: 43, right: 43),
                    width: 410,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(height: 20),
                          PostTitle(),

                          Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Nocturnal Wonderland Photography of the year Competition',
                                style: GoogleFonts.galdeano(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                ),
                              )),
                          Container(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Text(
                                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et.',
                                style: GoogleFonts.galdeano(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                ),
                              )),

                          Container(
                            height: 218,
                            child: Swiper(
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.asset(
                                  "assets/project_placeholder3.png",
                                  fit: BoxFit.fill,
                                );
                              },
                              control: SwiperControl(),
                              pagination: SwiperPagination(
                                  builder: new DotSwiperPaginationBuilder(
                                      color: Colors.grey,
                                      activeColor: Colors.blue)),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  top: 40, right: 240, bottom: 10),
                              child: Text(
                                'Featured',
                                style: GoogleFonts.galdeano(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image.asset(
                                      "assets/placeholders/event_placeholder2.png",
                                      scale: 1.5),
                                  Image.asset(
                                      "assets/placeholders/event_placeholder2.png",
                                      scale: 1.5),
                                  Image.asset(
                                      "assets/placeholders/event_placeholder2.png",
                                      scale: 1.5),
                                ],
                              )),
                          Text('12315 artists have participated so far.'),
                          SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width),

                          InkWell(
                            onTap: () {
                              print('apply pressed');
                            },
                            child: Container(
                                width: 184,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.blue[300]),
                                child: Center(
                                    child: Text('SUBMIT YOUR WORK',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15)))),
                          ),
                          // ),
                          SizedBox(
                            height: 80,
                          )
                        ]))),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  PostCard(type: PostType.blog),
                  PostCard(type: PostType.blog),
                  PostCard(type: PostType.blog),
                  PostCard(type: PostType.blog),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: 22, top: 5, bottom: 10, right: 20),
          height: 70,
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
                          setState(() => pressSaved = !pressSaved);
                        },
                        highlightColor: Colors.transparent,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(pressSaved ? Icons.done : Icons.favorite,
                                    color: pressSaved
                                        ? Theme.of(context).highlightColor
                                        : Colors.white,
                                    size: 15),
                                Text(pressSaved ? "SAVED" : " SAVE",
                                    style: GoogleFonts.galdeano(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(TextStyle(
                                              fontSize: 19,
                                              color: pressSaved
                                                  ? Theme.of(context)
                                                      .highlightColor
                                                  : Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ))))
                              ],
                            )))),
                decoration: BoxDecoration(
                  color: pressSaved
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                      color: Theme.of(context).highlightColor, width: 1.5),
                ),
              ),
              Spacer(flex: 5),
              Container(
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
                        textStyle: Theme.of(context).textTheme.bodyText1.merge(
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
              Spacer(),
              Container(
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
                        textStyle: Theme.of(context).textTheme.bodyText1.merge(
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
              Spacer(),
              Container(
                //padding: EdgeInsets.only(left: 12, top: 10),
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
                        textStyle: Theme.of(context).textTheme.bodyText1.merge(
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
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      height: 350,
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.only(top: 10),

      child: Image.asset('assets/placeholders/event_placeholder1.png',
          fit: BoxFit.cover),
    );
  }

  // Widget _buildTabBarBg() {
  //   return Container(
  //     // height: 30,
  //     // padding: EdgeInsets.only(top: 270),
  //     // child: Container(
  //     //     decoration: BoxDecoration(
  //     //         color: Colors.white,
  //     //         borderRadius: BorderRadius.only(
  //     //             topLeft: Radius.circular(40),
  //     //             topRight: Radius.circular(40))),
  //     //     child: Container(color: Colors.white))

  //     height: 40,
  //     padding: EdgeInsets.only(bottom: 30),
  //     child: ClipRRect(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(45), topRight: Radius.circular(45)),
  //         child: Container(color: Colors.white)),
  //   );
  // }
}
