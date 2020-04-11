import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/profile/bottom_drag_list_view.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
//  List<String> _tabs = ['BLOGS', 'MISSIONS', 'MARKS'];

  @override
  Widget build(BuildContext context) {
    return BottomDragWidget(
      body: Container(
        color: Colors.white,
        child: ProfileBackground(),
      ),
      dragContainer: DragContainer(
        drawer: ProfileForeground(),
        defaultShowHeight: 550.0,
        height: MediaQuery.of(context).size.height - 50.0 - MediaQuery.of(context).padding.top,
      ),
    );
  }
}

class ProfileBackground extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileBackgroundState();
  }
}

class _ProfileBackgroundState extends State<ProfileBackground> {
  var _following = 0;
  var _follower = 0;

  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
//      appBar: PreferredSize(
//        preferredSize: Size.fromHeight(0.0),
//        child: AppBar(
//          brightness: Brightness.light,
//          elevation: 0.0,
//          backgroundColor: Colors.transparent,
//        ),
//      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.2,
                child: Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.fill,),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 70.0),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  // avatar and following and follower
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(),
                                            image: DecorationImage(
                                              image: AssetImage('assets/logo.png'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: <Widget>[
                                      // following
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Username',
                                            style: AppTheme.headline,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
//                                          Text(
//                                            '$_following',
//                                            style: TextStyle(
//                                              color: Colors.black,
//                                              fontFamily: 'Quicksand',
//                                              fontWeight: FontWeight.bold,
//                                              fontSize: 18.0,
//                                            ),
//                                          )
                                        ],
                                      ),
//                                      SizedBox(
//                                        height: 10.0,
//                                      ),
//                                      // follower
//                                      Row(
//                                        children: <Widget>[
//                                          Text(
//                                            'Follower',
//                                            style: TextStyle(
//                                              color: Colors.black,
//                                              fontFamily: 'Quicksand',
//                                              fontWeight: FontWeight.bold,
//                                              fontSize: 18.0,
//                                            ),
//                                          ),
//                                          SizedBox(
//                                            width: 10.0,
//                                          ),
//                                          Text(
//                                            '$_follower',
//                                            style: TextStyle(
//                                              color: Colors.black,
//                                              fontFamily: 'Quicksand',
//                                              fontWeight: FontWeight.bold,
//                                              fontSize: 18.0,
//                                            ),
//                                          )
//                                        ],
//                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // username
//                          Padding(
//                            padding: EdgeInsets.all(20.0),
//                            child: Container(
//                              child: Align(
//                                alignment: Alignment.centerLeft,
//                                child: Text(
//                                  'Username',
//                                  style: TextStyle(
//                                    fontSize: 13.0,
//                                    color: Colors.black,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          //self-intro
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Self-Intro',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // follow or unfollow
//                  Container(
//                    height: 50.0,
//                    child: Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Container(
//                            alignment: Alignment.centerRight,
//                            child: IconButton(
//                              onPressed: () {
//                                this.setState(
//                                      () {
//                                    if (isFollowing) {
//                                      _follower -= 1;
//                                    } else {
//                                      _follower += 1;
//                                    }
//                                    isFollowing = !isFollowing;
//                                  },
//                                );
//                              },
//                              icon: isFollowing
//                                  ? Icon(
//                                Icons.favorite,
//                              )
//                                  : Icon(
//                                Icons.favorite_border,
//                              ),
//                              color: Colors.red,
//                            ),
//                          ),
//                        ),
//                        SizedBox(
//                          width: 10.0,
//                        ),
//                        Expanded(
//                          child: Container(
//                            alignment: Alignment.centerLeft,
//                            child: GestureDetector(
//                              onTap: () {
////                            Navigator.of(context).push(
////                              MaterialPageRoute(
////                                builder: (context) => ChatScreen(),
////                              ),
////                            );
//                              },
//                              child: Icon(Icons.chat),
//                            ),
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: MediaQuery.of(context).padding.right+15),
            child: SizedBox(
              width: AppBar().preferredSize.height-8,
              height: AppBar().preferredSize.height-8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                  child: Container(
//                    decoration: new BoxDecoration(
//                      shape: BoxShape.circle,// You can use like this way or like the below line
//                      //borderRadius: new BorderRadius.circular(30.0),
//                      color: AppTheme.grey.withOpacity(0.5),
//                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 44,
            right: 20,
            child: SizedBox(
              width: AppBar().preferredSize.height-8,
              height: AppBar().preferredSize.height-8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                  child: Container(
//                    decoration: new BoxDecoration(
//                      shape: BoxShape.circle,// You can use like this way or like the below line
//                      //borderRadius: new BorderRadius.circular(30.0),
//                      color: AppTheme.grey.withOpacity(0.5),
//                    ),
                    child: Icon(
                      Icons.more_horiz,
                      color: AppTheme.nearlyWhite,
                    ),
                  ),
                  onTap: () {
//                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

class ProfileForeground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
              ),
              automaticallyImplyLeading: false,
              elevation: 20.0,
              backgroundColor: Colors.white,
              title: Theme(
                data: ThemeData(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: TabBar(
                  // indicatorColor: Colors.transparent,
                  tabs: <Widget>[
                    Container(
                      // height: 40.0,
                      child: Center(
                        child: Text(
                          "BLOGS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // height: 40.0,
                      child: Center(
                        child: Text(
                          "MISSIONS",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // height: 40.0,
                      child: Center(
                        child: Text(
                          "MARKS",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                ListPage('post'),
                ListPage('comment'),
                ListPage('bookmark'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  final _name;

  ListPage(@required this._name);

  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(20, (i) => "$_name ${i + 1}");

    return OverscrollNotificationWidget(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, idx) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.black),
              ),
            ),
            child: ListTile(
              // thumbnail
              leading: Container(
                width: 40.0,
                height: 30.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/chris.jpg'),
                  ),
                ),
              ),
              title: Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    items[idx],
                  ),
                ),
              ),
            ),
          );
        },
        physics: const ClampingScrollPhysics(),
      ),
    );
  }
}