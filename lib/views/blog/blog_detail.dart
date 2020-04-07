import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/chat/contact_list_view.dart';
import 'package:freetitle/views/comment/comment.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:freetitle/views/comment/commentInput.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freetitle/model/util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:fluwx/fluwx.dart';
import 'package:freetitle/views/chat/chat_list_view.dart';

class BlogDetail extends StatefulWidget{
  const BlogDetail(
      {Key key,
        this.blogID,
//        this.blogData,
      })
      : super(key: key);
  final String blogID;
//  final Map blogData;

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
  String wechatThumbailUrl;
  String wechatDescription;

  @override
  void initState(){
    final wx = registerWxApi(appId: 'wx3f39d58fd1321045', doOnIOS: true, doOnAndroid: true, universalLink: 'https://freetitle.us/');
    _userRepository = new UserRepository();
    _userRepository.getUser().then((snap) => {
      if(snap != null)
        userID = snap.uid,
    });
    _scrollController = new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<String> getCommentIDs(blogData){
    List<String> commentIDs = new List();
    if (blogData['comments'] != null){
      for(String commentID in blogData['comments']){
        commentIDs.add(commentID);
      }
    }
    return commentIDs;
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
    Widget author = _userRepository.getUserWidget(blog['user']);
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
            List<String> blockStrings = blockText.split(' <');
            for(String blockString in blockStrings){
              if(blockString.contains('href=')){
                int startURL = blockString.indexOf('href=')+6;
                int endUrl = blockString.indexOf('">');
                String url = blockString.substring(startURL, endUrl);
                int endLink = blockString.indexOf('</a>');
                String link = blockString.substring(endUrl+2, endLink);
                textLists.add( LinkTextSpan(
                  style: AppTheme.link,
                  url: url,
                  text: ' ' + link,
                ),);
                textLists.add( LinkTextSpan(
                  style: AppTheme.body1,
                  text: blockString.substring(endLink+4),
                ));
              }
              else if (blockString.contains('i>')){
                int italic_start = blockString.indexOf('i>')+2;
                int italic_end = blockString.indexOf('</i>');
                textLists.add(TextSpan(
                  style: AppTheme.body1Italic,
                  text: ' ' + blockString.substring(italic_start, italic_end),
                ));
                textLists.add(TextSpan(
                  style: AppTheme.body1,
                  text: blockString.substring(italic_end+4),
                ));
              }
              else if (blockString.contains('b>')){
                int bold_start = blockString.indexOf('b>')+2;
                int bold_end = blockString.indexOf('</b>');
                textLists.add(TextSpan(
                    style: AppTheme.body1Bold,
                    text: ' ' + blockString.substring(bold_start, bold_end)
                ));
                textLists.add(TextSpan(
                  style: AppTheme.body1,
                  text: blockString.substring(bold_end+4),
                ));
              }
              else{
                textLists.add(TextSpan(
                  style: AppTheme.body1,
                  text: blockString,
                ),);
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
          if(wechatThumbailUrl == null){
            wechatThumbailUrl = block['data']['file']['url'];
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
          height: blog['RSSarticle'].length*0.3,
          child: WebView(
            initialUrl: Uri.dataFromString("<html><body>${blog['RSSarticle']}</body></html>",  mimeType: "text/html", encoding: Encoding.getByName('utf-8')).toString(),

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

//    if (blog['comments'] != null){
//      List<String> commentIDs = new List();
//      for(String commentID in blog['comments']){
//        commentIDs.add(commentID);
//      }
//      if (commentIDs.isNotEmpty){
//        blogWidget.add(CommentBottom(commentIDs: commentIDs,));
//      }
//    }
    List<String> commentIDs = getCommentIDs(blog);
    if (commentIDs.isNotEmpty){
      blogWidget.add(CommentBottom(commentIDs: commentIDs.length > 3 ? commentIDs.sublist(commentIDs.length-3) : commentIDs, blogID: widget.blogID,));
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
                              description: wechatDescription != null ? wechatDescription : "点击阅读全文",
                              thumbnail: wechatThumbailUrl != null ? WeChatImage.network(wechatThumbailUrl) : WeChatImage.network('https://freetitle.us/static/media/background_bw.b784d709.png'),
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
                                .catchError((e) => {
                              print('sharing error ${e}')
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

  void showFloatingActionButton(bool value){
    setState(() {
      showFloatingAction = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map blog;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('blogs').document(widget.blogID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return new PlaceHolderCard(
                text: 'Loading Blog',
                height: 200.0,
              );
            default:
              if(snapshot.data.data != null){
                blog = snapshot.data.data;
                if(blog['markedBy'] != null && blog['markedBy'].contains(userID)){
                  marked = true;
                }
                if(blog['upvotedBy'] != null && blog['upvotedBy'].contains(userID)){
                  liked = true;
                }
                return Scaffold(
                    backgroundColor: AppTheme.nearlyWhite,
                    appBar: AppBar(
                      brightness: Brightness.light,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      actions: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: Icon(Icons.comment),
                            color: Colors.black,
                            onPressed: () async {
                              await Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => CommentPage(key: commentPageKey, commentIDs: getCommentIDs(blog), blogID: widget.blogID),
                                  )
                              );
                            },
                          ),
                        ),
                      ],
                      backgroundColor: AppTheme.white,
                      iconTheme: IconThemeData(color: Colors.white),
                    ),
                    floatingActionButton: showFloatingAction ? SpeedDial(
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
                          child: liked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                          backgroundColor: AppTheme.secondary,
                          label: "点赞 ${blog['likes'].toString()}",
                          labelStyle: AppTheme.body1,
                          onTap: () {
                            if (userID==null){
                              Navigator.push<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => LoginScreen(),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              liked = !liked;
                            });
                            Firestore.instance.collection('blogs').document(widget.blogID).updateData({
                              "likes": FieldValue.increment((liked ? (1) : (-1))),
                            }).whenComplete(() => {
                              print('succeeded'),
                            }).catchError((e) => {
                              print('get error ${e}'),
                            });
                            if(liked){
                              Firestore.instance.collection('blogs').document(widget.blogID).updateData({
                                "upvotedBy": FieldValue.arrayUnion([userID]),
                              }).whenComplete(() => {
                                print('like  succeeds'),
                              }).catchError((e) => {
                                print('like gets error ${e}'),
                              });
                            }
                            else{
                              Firestore.instance.collection('blogs').document(widget.blogID).updateData({
                                "upvotedBy": FieldValue.arrayRemove([userID]),
                              }).whenComplete(() => {
                                print('like  succeeds'),
                              }).catchError((e) => {
                                print('like gets error ${e}'),
                              });
                            }
                          },
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.comment),
                          backgroundColor: AppTheme.secondary,
                          label: "评论 ${blog['comments'] != null ? blog['comments'].length.toString() : '0' }",
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
                                    builder: (BuildContext context) => CommentInputPage(blogID: widget.blogID, parentLevel: 0, parentID: widget.blogID, parentType: 'blog',)
                                )
                            );
                          },
                        ),
                        SpeedDialChild(
                          child: marked ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
                          backgroundColor: AppTheme.secondary,
                          label: "收藏 ${blog['markedBy'] != null ? blog['markedBy'].length.toString() : '0' }",
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
                            setState(() {
                              marked = !marked;
                            });
                            if(marked){
                              Firestore.instance.collection('blogs').document(widget.blogID).get().then((snap) async {
                                if(snap.data.isNotEmpty){
                                  await _userRepository.getUser().then((snap) => {
                                    userID = snap.uid,
                                  });
                                  await Firestore.instance.collection('blogs').document(widget.blogID).updateData({
                                    'markedBy': FieldValue.arrayUnion([userID])
                                  });
                                  await Firestore.instance.collection('users').document(userID).updateData({
                                    'bookmarks': FieldValue.arrayUnion([widget.blogID])
                                  });
                                }
                              });
                            }
                            else{
                              Firestore.instance.collection('blogs').document(widget.blogID).get().then((snap) async {
                                if(snap.data.isNotEmpty){
                                  await _userRepository.getUser().then((snap) => {
                                    userID = snap.uid,
                                  });
                                  await Firestore.instance.collection('blogs').document(widget.blogID).updateData({
                                    'markedBy': FieldValue.arrayRemove([userID])
                                  });
                                  await Firestore.instance.collection('users').document(userID).updateData({
                                    'bookmarks': FieldValue.arrayRemove([widget.blogID])
                                  });
                                }
                              });
                            }
                          },
                        ),
                        SpeedDialChild(
                          child: Icon(Icons.share),
                          backgroundColor: AppTheme.secondary,
                          label: "分享",
                          labelStyle: AppTheme.body1,
                          onTap: () {
                            buildShareSheet(context, blog);
                          },
                        ),
                      ],
                    ) : Container(),
                    resizeToAvoidBottomPadding: false,
                    body: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            key: PageStorageKey('blogDetail'),
                            children: buildBlogContent(blog, context),
                          ),
                        )
                    )
                );
              }
              else{
                return Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppTheme.primary,
                    ),
                    body: PlaceHolderCard(
                      text: 'Loadding Blog',
                    )
                );
              }
          }
        },
      ),
    );
  }
}