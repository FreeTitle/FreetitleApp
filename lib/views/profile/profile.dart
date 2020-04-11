import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            UserInfoView(),
            DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.65,
              maxChildSize: 0.9,
              builder: (BuildContext context, ScrollController _scrollController) {
                return UserContentView(scrollController: _scrollController,);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserInfoViewState();
  }
}

class _UserInfoViewState extends State<UserInfoView> {
//  var _following = 0;
//  var _follower = 0;

//  bool isFollowing = false;

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
                                          Container(
                                            child: Icon(Icons.mood),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Labels',
                                            style: TextStyle(
                                              color: Colors.black,
//                                              fontFamily: 'Quicksand',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Campus',
                                            style: TextStyle(
                                              color: Colors.black,
//                                              fontFamily: 'Quicksand',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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

class UserContentView extends StatelessWidget {

  const UserContentView({Key key, this.scrollController}) : super(key : key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
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
                  labelColor: AppTheme.primary,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: AppTheme.primary,
                  tabs: <Widget>[
                    Tab(child: Text('Blogs')),
                    Tab(child: Text('Missions')),
                    Tab(child: Text('Marks')),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                ContentPage('post', scrollController),
                ContentPage('comment', scrollController),
                ContentPage('bookmark', scrollController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  final _name;

  ContentPage(this._name, this.scrollController);

  final scrollController;

  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(20, (i) => "$_name ${i + 1}");

    return ListView.builder(
        controller: scrollController,
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
                    image: AssetImage('assets/logo.png'),
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
//        physics: const ClampingScrollPhysics(),
      );
  }
}