import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'CTflow.dart';
import 'dart:math';

class MultiplePhotoPost extends StatefulWidget {
  _MultiplePhotoPostState createState() => _MultiplePhotoPostState();
}

class _MultiplePhotoPostState extends State<MultiplePhotoPost> {
  @override
  Widget build(BuildContext context) {
    int images = 2;
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 16),
        child: InkWell(
            splashColor: Colors.white,
            onTap: () {
              print('blogpost');
            },
            child: Container(
                decoration: BoxDecoration(color: AppTheme.white),
                child: Stack(children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 50,
                                    child: Image.asset(
                                        'assets/images/avatar.png',
                                        fit: BoxFit.fill)),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 30),
                                    child: Text(
                                      '   FreeTitle Freelance Photographer',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(left: 105),
                                    child: Icon(Icons.share))
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                                'Un Chien Andalou has no plot in the conventional sense of the word. The chronology of the film is disjointed, jumping from the initial at…. Read more ',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey))),
                        Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            //height: 200,
                            child: getFlowContainer(2)),
                        // Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(8.0)),
                        //     ),
                        //     padding: EdgeInsets.only(top: 10),
                        //     child: ClipRRect(
                        //         borderRadius: BorderRadius.circular(10),
                        //         child: Image.asset(
                        //             'assets/images/blogpost_.png',
                        //             fit: BoxFit.fill))),

                        Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.share,
                                    ),
                                    Text(
                                      ' 0 shares',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.withOpacity(0.8)),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.comment,
                                    ),
                                    Text(
                                      ' 0 comments',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.withOpacity(0.8)),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Icon(Icons.thumb_up),
                                    Text(
                                      ' 0 likes',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.withOpacity(0.8)),
                                    ),
                                  ]),
                                ]))
                      ])
                ]))));
  }

  getFlowContainer(int count) {
    List<Container> list = [];
    for (var i = 0; i < count; i++) {
      list.add(Container(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/blogpost_.png',
                  fit: BoxFit.fill))));
    }
    return CLFlow(
      count: count,
      children: list,
    );
    // return GridView.builder(
    //     //shrinkWrap: true,
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: count > 3 ? list.length : (list.length / 2).toInt(),
    //         childAspectRatio: 1.0),
    //     itemCount: list.length,
    //     itemBuilder: (context, index) {
    //       return Icon(Icons.share);
    //     });
  }
}
