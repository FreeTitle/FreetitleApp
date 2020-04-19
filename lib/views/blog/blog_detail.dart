import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/chat/contact_list_view.dart';
import 'package:freetitle/views/comment/comment.dart';
import 'package:freetitle/views/comment/comment_bottom.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:freetitle/views/comment/commentInput.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:freetitle/model/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:fluwx/fluwx.dart';

class BlogDetail extends StatefulWidget{
  const BlogDetail(
      {Key key,
        @required this.blogID,
//        this.blogData,
        this.restorePosition,
      })
      : super(key: key);
  final String blogID;
//  final Map blogData;
  final double restorePosition;

  @override
  State<StatefulWidget> createState() {
    return _BlogDetail();
  }
}


class _BlogDetail extends State<BlogDetail> {

  UserRepository _userRepository;
  ScrollController _scrollController;
  bool liked = false;
  bool marked = false;
  String userID;
  bool showFloatingAction = true;
  final commentPageKey = PageStorageKey('CommentPage');
  final commentBottomKey = PageStorageKey('CommentBottom');
  String wechatThumbnailUrl;
  String wechatDescription;

  Map blogData;
  Map authorData;


  @override
  void initState(){
    final wx = registerWxApi(appId: 'wx3f39d58fd1321045', doOnIOS: true, doOnAndroid: true, universalLink: 'https://freetitle.us/');
    _userRepository = new UserRepository();

    SharedPreferences sharedPref;
    SharedPreferences.getInstance().then((pref) {
      sharedPref = pref;
    });

    _scrollController = new ScrollController(initialScrollOffset: widget.restorePosition != null ? widget.restorePosition : 0.0, keepScrollOffset: true);
//    if(widget.restorePosition != null){
//      _scrollController.jumpTo(widget.restorePosition);
//    }
    _scrollController.addListener(() {
      try{
        List<String> blogStore = List();
        blogStore.add('blog');
        blogStore.add(widget.blogID);
        blogStore.add(_scrollController.position.pixels.toString());
        sharedPref.setStringList('article', blogStore);
      }catch(e) {
        print('store blog position failed $e');
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  List<Widget> buildBlogContent(blog, context){
    List<Widget> blogWidget = new List<Widget>();
    if(blog == null){
      blogWidget.add(Text('Loading blog'));
      return blogWidget;
    }
    Padding title = new Padding(
      padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
      child: Text(blog['title'], style: AppTheme.headline,),
    );
    // Add title
    blogWidget.add(title);
    // Add author
    Widget author = _userRepository.getUserWidget(context, blog['user'], authorData);
    blogWidget.add(Padding(
      padding: EdgeInsets.only(top: 8, left: 24, right: 24),
      child: author,
    ));
    // Add time
    var date = blog['time'].toDate();

    // Process contents
    if(blog['article'] != null){
      for(var block in blog['article']['blocks']){
        String blockText = block['data']['text'];
        if(block['type'] == 'paragraph'){
          blockText = blockText.replaceAll('&nbsp;', ' ');
          // handle link case
          if(wechatDescription == null){
            wechatDescription = blockText;
          }
          Widget curBlock = Text(blockText, style: AppTheme.body1,);
          List<TextSpan> textLists = new List<TextSpan>();
          // handle embedded url
          if (blockText.contains('<a') || blockText.contains('<i>') || blockText.contains('<b>')){
            List<String> blockStrings = blockText.split('<i><b>');
            for (String blockString in blockStrings) {
              if(blockString.contains('</b></i>')){
                final boldItalicStart = 0;
                final boldItalicEnd = blockString.indexOf('</b>');
                textLists.add(TextSpan(
                    style: AppTheme.body1BoldItalic,
                    text: ' ' + blockString.substring(boldItalicStart, boldItalicEnd),
                  )
                );
                processText(blockString.substring(boldItalicEnd+9)).forEach((block) {
                  textLists.add(block);
                });
              }
              else{
                processText(blockString).forEach((block) {
                  textLists.add(block);
                });
              }
            }

            if(textLists.isNotEmpty){
              curBlock = RichText(
                text: TextSpan(
                    children: textLists,
                ),
              );
            }
          }

          blogWidget.add(
            Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0, left: 24.0, right: 24.0),
                child: curBlock,
            )
          );
        }
        else if(block['type'] == 'header'){
          blogWidget.add(
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24.0, right: 24.0),
                child: Text(blockText, style: AppTheme.title,),
              )
          );
        }
        else if(block['type'] == 'image'){
          if(block['data']['file']['url'] == null){
            continue;
          }
          if(wechatThumbnailUrl == null){
            wechatThumbnailUrl = block['data']['file']['url'];
          }
          blogWidget.add(
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.network(block['data']['file']['url'], fit: BoxFit.contain,),
            )
          );
        }
        else if(block['type'] == 'embed'){
          String code = block['data']['code'];
          int end = code.indexOf('>');
          String pre = code.substring(0, end);
          pre += " allowfullscreen ";
          if(Platform.isIOS){
            pre += "width=\"${MediaQuery.of(context).size.width*2.3}\" height=\"600\"";
          }
          else{
            pre += "width=\"${MediaQuery.of(context).size.width*0.85}\" height=\"230\"";
          }
          code = pre + code.substring(end);

          if(code.contains('163')){
            end = code.indexOf('//');
            pre = code.substring(0, end);
            pre += 'https:';
            code = pre + code.substring(end);
            blogWidget.add(
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: Platform.isAndroid ? 120 : 70,
                  padding: EdgeInsets.all(16.0),
                  child: WebView(
                    initialUrl: Uri.dataFromString("<html><body>${code}</body></html>", mimeType: 'text/html').toString(),
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                )
            );
          }
          else{
            blogWidget.add(
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 280,
                  padding: EdgeInsets.all(16.0),
                  child: WebView(
                    initialUrl: Uri.dataFromString("<html><body>${code}</body></html>", mimeType: 'text/html').toString(),
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                )
            );
          }
        }
      }
    }
    else if (blog.containsKey('blocks')){
      for(var block in blog['blocks']){
        if(block.contains('https')){
          blogWidget.add(
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.network(block, fit: BoxFit.contain,),
              )
          );
        }
        else{
          blogWidget.add(
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 24.0, right: 24.0),
                child: Text(block, style: TextStyle(height: 2, fontSize: 15),),
              )
          );
        }
      }
    }

    if(blog.containsKey('RSSarticle')){
      blogWidget.add(
        SizedBox(
          height: 20,
        )
      );

      blogWidget.add(
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height-350,
          child: WebView(
            initialUrl: Uri.dataFromString("<html><body>${blog['RSSarticle']}</body></html>",
            mimeType: "text/html",
            encoding: Encoding.getByName('utf-8')).toString(),
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: [Factory(() => PlatformViewVerticalGestureRecognizer())].toSet(),
          ),
        )
      );
    }

    blogWidget.add(
        Row(
            children: <Widget>[
              Expanded(
                  child: Divider(color: AppTheme.dark_grey,)
              ),

              Text("Comments", style: AppTheme.title,),

              Expanded(
                  child: Divider(color: AppTheme.dark_grey,)
              ),
            ]
        )
    );

    List<String> commentIDs = getCommentIDs(blog);
    if (commentIDs.isNotEmpty){
      blogWidget.add(NewCommentBottom(key: commentBottomKey,pageID: widget.blogID, pageType: 'blog',));
//      if(commentIDs.length > 3){
//        blogWidget.add(
//            Center(
//              child: InkWell(
//                onTap: () {
//                  Navigator.push<dynamic>(
//                      context,
//                      MaterialPageRoute<dynamic>(
//                          builder: (BuildContext context) => CommentPage(key: commentPageKey, pageID: widget.blogID, pageType: 'blog',)
//                      )
//                  );
//                },
//                child: Text('更多评论...', style: AppTheme.link,),
//              ),
//            )
//        );
//      }
    }else{
      blogWidget.add(PlaceHolderCard(text: 'No comments yet', height: 200.0,));
    }

    blogWidget.add(
      SizedBox(
        height: 36,
      )
    );

    return blogWidget;
  }

  void showFloatingActionButton(bool value){
    setState(() {
      showFloatingAction = value;
    });
  }

  Future<bool> getBlogData() async {
    await _userRepository.getUser().then((snap) {
      if(snap != null)
        userID = snap.uid;
    });

    blogData = Map();
    await Firestore.instance.collection('blogs').document(widget.blogID).get().then((snap) {
      blogData = snap.data;
    });

    authorData = Map();
    await Firestore.instance.collection('users').document(blogData['user']).get().then((snap) {
      authorData = snap.data;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: getBlogData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.connectionState == ConnectionState.done) {
            if(blogData['markedBy'] != null && blogData['markedBy'].contains(userID)){
              marked = true;
            }
            if(blogData['upvotedBy'] != null && blogData['upvotedBy'].contains(userID)){
              liked = true;
            }
            if(wechatThumbnailUrl == null && blogData.containsKey('cover')){
              wechatThumbnailUrl = blogData['cover'];
            }
            return Scaffold(
                backgroundColor: AppTheme.nearlyWhite,
                appBar: AppBar(
                  brightness: Brightness.dark,
                  title: Text('Blog正文', style: TextStyle(color: Colors.black),),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
//                  actions: <Widget>[
//                    Padding(
//                      padding: EdgeInsets.only(right: 20),
//                      child: IconButton(
//                        icon: Icon(Icons.comment),
//                        color: Colors.black,
//                        onPressed: () async {
//                          await Navigator.push<dynamic>(
//                              context,
//                              MaterialPageRoute<dynamic>(
//                                builder: (BuildContext context) => CommentPage(key: commentPageKey, pageID: widget.blogID, pageType: 'blog',),
//                              )
//                          );
//                        },
//                      ),
//                    ),
//                  ],
                  backgroundColor: AppTheme.white,
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                floatingActionButton: showFloatingAction ? BlogFloatingButton(
                  state: this,
                  userID: userID,
                  blogID: widget.blogID,
                  wechatDescription: wechatDescription,
                  wechatThumbnailUrl: wechatThumbnailUrl,
                ) : Container(),
                resizeToAvoidBottomPadding: false,
                body: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Column(
                        key: PageStorageKey('blogDetail'),
                        children: buildBlogContent(blogData, context),
                      ),
                    )
                )
            );
          }
          else {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: AppTheme.white,
                ),
                body: PlaceHolderCard(
                  text: 'Loadding Blog',
                )
            );
          }
        },
      ),
    );
  }
}

class BlogFloatingButton extends StatefulWidget {
  BlogFloatingButton(
  {Key key,
    @required this.state,
    @required this.userID,
    @required this.blogID,
    @required this.wechatThumbnailUrl,
    @required this.wechatDescription
  }) : super(key : key);

  final _BlogDetail state;
  final String userID;
  final String blogID;
  final String wechatThumbnailUrl;
  final String wechatDescription;
  
  _BlogFloatingButtonState createState() => _BlogFloatingButtonState();
}

class _BlogFloatingButtonState extends State<BlogFloatingButton> {

  void buildShareSheet(BuildContext context, Map blog){
    var shareSheetController = showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: AppTheme.nearlyWhite,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 16),
                child: Text('分享至', style: AppTheme.body1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.people,),
                            iconSize: 50,
                            onPressed: () {
                              Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => ContactListView(sharedBlogID: widget.blogID,)
                                ),
                              );
                            },
                          ),
                        )
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(80.0)),
                          child: InkWell(
                            child: Image.asset('assets/icons/wechat.png', fit: BoxFit.fill,),
                            onTap: () {
                              shareToWeChat(WeChatShareWebPageModel(
                                "https://freetitle.us/blogdetail?id=${widget.blogID}",
                                title: blog['title'],
                                description: widget.wechatDescription != null ? widget.wechatDescription : "点击阅读全文",
                                thumbnail: widget.wechatThumbnailUrl != null ? WeChatImage.network(widget.wechatThumbnailUrl) : WeChatImage.network('https://freetitle.us/static/media/background_bw.b784d709.png'),
                              ));
                            },
                          )
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(CupertinoIcons.share,),
                          iconSize: 50,
                          onPressed: () {
                            Share.share('请看博客${blog['title']}，点击https://freetitle.us/blogdetail?id=${widget.blogID}', subject: 'Look at this')
                                .catchError((e) {
                              print('sharing error $e');
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: InkWell(
                  child: Text('取消'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        )
    );

  }
  
  @override
  Widget build(BuildContext context) {
//    final blog = widget.blog;
    final userID = widget.userID;
    final blogID = widget.blogID;
    return SpeedDial(
      marginRight: 20,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: widget.state.liked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          backgroundColor: AppTheme.secondary,
          label: "点赞 ${widget.state.blogData['likes'].toString()}",
          labelStyle: AppTheme.body1,
          onTap: () {
            if (widget.userID==null){
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              );
              return;
            }

            widget.state.liked = !widget.state.liked;
            setState(() {

            });

            Firestore.instance.collection('blogs').document(blogID).updateData({
              "likes": FieldValue.increment((widget.state.liked ? (1) : (-1))),
            }).whenComplete(() {
              print('succeeded');
            }).catchError((e) {
              print('get error $e');
            });

            if(widget.state.liked){
              Firestore.instance.collection('blogs').document(blogID).updateData({
                "upvotedBy": FieldValue.arrayUnion([userID]),
              }).whenComplete(() {
                print('like  succeeds');
              }).catchError((e) {
                print('like gets error $e');
              });
              widget.state.blogData['likes'] += 1;
            }
            else{
              Firestore.instance.collection('blogs').document(blogID).updateData({
                "upvotedBy": FieldValue.arrayRemove([userID]),
              }).whenComplete(() {
                print('unlike  succeeds');
              }).catchError((e) {
                print('unlike gets error $e');
              });
              widget.state.blogData['likes'] -= 1;
            }
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.comment),
          backgroundColor: AppTheme.secondary,
          label: "评论 ${widget.state.blogData['comments'] != null ? widget.state.blogData['comments'].length.toString() : '0' }",
          labelStyle: AppTheme.body1,
          onTap: () {
            if (userID == null){
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              );
              return;
            }
            Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => CommentInputPage(pageID: widget.blogID, parentLevel: 0, parentID: widget.blogID, parentType: 'blog', pageType: 'blog', targetID: widget.blogID,)
                )
            );
          },
        ),
        SpeedDialChild(
          child: widget.state.marked ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
          backgroundColor: AppTheme.secondary,
          label: "收藏 ${widget.state.blogData['markedBy'] != null ? widget.state.blogData['markedBy'].length.toString() : '0' }",
          labelStyle: AppTheme.body1,
          onTap: () {
            if (userID == null){
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => LoginScreen(),
                ),
              );
              return;
            }
            widget.state.marked = !widget.state.marked;
            setState(() {

            });
            if(widget.state.marked){
              Firestore.instance.collection('blogs').document(widget.blogID).get().then((snap) {
                if(snap.data.isNotEmpty){
//                  _userRepository.getUser().then((snap) {
//                    userID = snap.uid;
//                  });
                  Firestore.instance.collection('blogs').document(widget.blogID).updateData({
                    'markedBy': FieldValue.arrayUnion([userID])
                  });
                  Firestore.instance.collection('users').document(userID).updateData({
                    'bookmarks': FieldValue.arrayUnion([widget.blogID])
                  });
                }
              });
              widget.state.blogData['markedBy'].add(userID);
            }
            else{
              Firestore.instance.collection('blogs').document(widget.blogID).get().then((snap) {
                if(snap.data.isNotEmpty){
//                  _userRepository.getUser().then((snap) {
//                    userID = snap.uid;
//                  });
                  Firestore.instance.collection('blogs').document(widget.blogID).updateData({
                    'markedBy': FieldValue.arrayRemove([userID])
                  });
                  Firestore.instance.collection('users').document(userID).updateData({
                    'bookmarks': FieldValue.arrayRemove([widget.blogID])
                  });
                }
              });
              widget.state.blogData['markedBy'].remove(userID);
            }
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.share),
          backgroundColor: AppTheme.secondary,
          label: "分享",
          labelStyle: AppTheme.body1,
          onTap: () {
            buildShareSheet(context, widget.state.blogData);
          },
        ),
      ],
    );
  }
}