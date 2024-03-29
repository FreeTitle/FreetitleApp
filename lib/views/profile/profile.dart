import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util/util.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.userID, this.isMyProfile}) : super(key : key);

  final String userID;
  final bool isMyProfile;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {

  List blogList;
  List blogIDs;
  List missionList;
  List missionIDs;
  List bookmarkList;
  Map userData;
  Future<bool> _getUserStuff;
  AnimationController animationController;

  @override void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this
    );
    _getUserStuff = getUserStuff();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> getUserStuff() async {
    await Firestore.instance.collection('users').document(widget.userID).get().then((snap) {
      userData = snap.data;
    });

    blogList = List();
    blogIDs = List();
    await Firestore.instance.collection('blogs').where('user', isEqualTo: widget.userID).getDocuments().then((snap){
      snap.documents.forEach((doc) {
        blogList.add(doc.data);
        blogIDs.add(doc.documentID);
      });
    });

    missionList = List();
    missionIDs = List();
    await Firestore.instance.collection('missions').where('ownerID', isEqualTo: widget.userID).getDocuments().then((snap) {
      snap.documents.forEach((doc) {
        missionList.add(doc.data);
        missionIDs.add(doc.documentID);
      });
    });

    bookmarkList = List();
    await Firestore.instance.collection('blogs').getDocuments().then((snap){
      if(userData['bookmarks'] != null && userData['bookmarks'].length != 0){
        userData['bookmarks'].forEach((id) {
          snap.documents.where((doc) => doc.documentID == id).forEach((blogSnap){
            bookmarkList.add(blogSnap.data);
          });
        });
      }
    });

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _getUserStuff,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Container(
            child: Container(
              child: Stack(
                children: <Widget>[
                  UserInfoView(userData: userData, isMyProfile: widget.isMyProfile, userID: widget.userID,),
                  DraggableScrollableSheet(
                    initialChildSize: 0.65,
                    minChildSize: 0.53,
                    maxChildSize: 0.9,
                    builder: (BuildContext context, ScrollController _scrollController) {
                      return UserContentView(
                        scrollController: _scrollController,
                        animationController: animationController,
                        blogList: blogList,
                        blogIDs: blogIDs,
                        missionList: missionList,
                        missionIDs: missionIDs,
                        bookmarkIDs: userData['bookmarks'],
                        bookmarkList: bookmarkList,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }else{
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            body:  Center(
              child: Text('加载中'),
            ),
          );
        }
      },
    );
  }
}

class UserInfoView extends StatefulWidget {

  UserInfoView({Key key, @required this.userData, @required this.isMyProfile, @required this.userID}) : super(key : key);

  final Map userData;
  final bool isMyProfile;
  final String userID;

  @override
  State<StatefulWidget> createState() {
    return _UserInfoViewState();
  }
}

class _UserInfoViewState extends State<UserInfoView> {
//  var _following = 0;
//  var _follower = 0;

//  bool isFollowing = false;

  Color backgroundColor = Color(0xFFFFFFFF);

  Future<bool> getBackgroundColor() async {
    ImageProvider img;
    final backgroundUrl = widget.userData['backgroundUrl'];
    if(backgroundUrl != null && backgroundUrl != ''){
      img = NetworkImage(backgroundUrl);
    }
    else{
      img = AssetImage('assets/images/blog_placeholder.png');
    }
    PaletteGenerator pg = await PaletteGenerator.fromImageProvider(img);

    if(pg.dominantColor?.color !=null)
      backgroundColor = pg.dominantColor?.color;

    return true;
  }

  @override
  Widget build(BuildContext context) {

    final userData = widget.userData;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getBackgroundColor(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            print(backgroundColor.computeLuminance());
            Color color = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
            // Change status bar brightness according to image
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                // For iOS
                statusBarBrightness: backgroundColor.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
                // For Android M and higher
                statusBarIconBrightness: backgroundColor.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
              ),
            );
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: userData.containsKey('backgroundUrl') && userData['backgroundUrl'] != '' ? Image.network(userData['backgroundUrl'], fit: BoxFit.fill,) : Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.fill,),
                    ),
                  ],
                ),
//          Positioned(
//            top: 45,
//            left: 20,
//            child: Container(
//              height: 250,
//              width: 375,
//              color: Colors.grey.withOpacity(0.8),
//            ),
//          ),
                Padding(
                  padding: EdgeInsets.only(top: AppBar().preferredSize.height),
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
                                    Container(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                    color: color,
                                                    blurRadius: 1,
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                                child: userData['avatarUrl'] != null ? Image.network(userData['avatarUrl'], fit: BoxFit.cover,) : Image.asset('assets/logo.png', fit: BoxFit.fill),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
//                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // following
                                        Container(
                                          width: MediaQuery.of(context).size.width/2-25,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  userData['displayName'],
                                                  style: TextStyle(
                                                    fontFamily: 'WorkSans',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    letterSpacing: 0.27,
                                                    color: color,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Container(
                                                child: Icon(Icons.mood),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "",
                                              style: TextStyle(
                                                color: color,
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
                                        Container(
                                          width: 150,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  userData['campus'] != null ? userData['campus'] : '',
                                                  style: TextStyle(
                                                    color: color,
//                                              fontFamily: 'Quicksand',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Divider(
                                  color: color,
                                ),
                                //self-intro
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Container(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        userData['statement'] != null && userData['statement'] != "" ? userData['statement'].toString() : 'This user has no art statement yet',
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 15.0,
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
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: MediaQuery.of(context).padding.left + 10,
                  child: SizedBox(
                    width: AppBar().preferredSize.height-8,
                    height: AppBar().preferredSize.height-8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                        child: Container(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: color,
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
                  top: MediaQuery.of(context).padding.top,
                  right: MediaQuery.of(context).padding.right + 10,
                  child: SizedBox(
                    width: AppBar().preferredSize.height-8,
                    height: AppBar().preferredSize.height-8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                        child: Container(
                          child: Icon(
                            Icons.more_horiz,
                            color: color,
                          ),
                        ),
                        onTap: () {

                        },
                      ),
                    ),
                  ),
                ),
                !widget.isMyProfile ?
                Positioned(
                  top: MediaQuery.of(context).padding.top + 115,
                  right: MediaQuery.of(context).padding.right + 30,
                  child: InkWell(
                    onTap: () async {

                    },
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Theme.of(context).highlightColor,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ) : SizedBox(width: 0,)
              ],
            );
          }else{
            return PlaceHolderCard(text: 'Loading Profile');
          }
        },
      ),
    );
  }
}

class UserContentView extends StatelessWidget {

  const UserContentView({Key key, this.scrollController, this.bookmarkList, this.bookmarkIDs, this.animationController, this.blogIDs, this.blogList, this.missionList, this.missionIDs}) : super(key : key);

  final ScrollController scrollController;
  final AnimationController animationController;
  final List blogIDs;
  final List blogList;
  final List missionList;
  final List missionIDs;
  final List bookmarkList;
  final List bookmarkIDs;

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
//            color: Colors.white,
          ),
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
              automaticallyImplyLeading: false,
              elevation: 20.0,
//              backgroundColor: Colors.white,
              title: Theme(
                data: ThemeData(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: TabBar(
                  labelColor: Theme.of(context).highlightColor,
                  unselectedLabelColor: Theme.of(context).accentColor,
                  indicatorColor:  Theme.of(context).highlightColor,
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
