import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: screenSize.height / 15,
                horizontal: screenSize.width / 10),
            child: Text('FreeTitle浮樂态度是一个留学生的艺术交流平台。我们来自北美各大院校，旨在为所有热爱艺术、设计、电影、戏剧、摄影等泛艺术专业的朋友提供了一个自由的创作空间。在这里，我们不仅可以分享自己的作品，还可以发起自己的项目招募志同道合的小伙伴。',
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .merge(TextStyle(color: Colors.grey))),
          ),
          Stack(children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width / 7, vertical: 20.0),
                child: Container(
                    height: 150,
                    width: screenSize.width / 1.3,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(48.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Column(children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: -0.05,
                                color: Colors.purple[700],
                              ))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'freetitler@gmail.com',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .merge(TextStyle(color: Colors.grey)),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('@ Official Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: -0.05,
                                color: Colors.purple[700],
                              ))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'FreeTitle 浮樂态度',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .merge(TextStyle(color: Colors.grey)),
                          )),
                    ]))),
            Container(
              padding: EdgeInsets.only(right: screenSize.width / 40, top: 20.0),
              height: 220,
              width: screenSize.width,
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/feather.png',
                scale: screenSize.width / 35,
                fit: BoxFit.cover,
              ),
            ),
          ])
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
