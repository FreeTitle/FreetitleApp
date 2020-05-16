import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/full_pdf_screen.dart';
import 'package:freetitle/model/photo.dart';
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
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
  Future<bool> _getBlogData;

  SharedPreferences sharedPref;
  Map blogData;
  Map authorData;
  String pdfPath;

  @override
  void initState(){
    _userRepository = new UserRepository();


    SharedPreferences.getInstance().then((pref) {
      sharedPref = pref;
    });

    _scrollController = new ScrollController(initialScrollOffset: widget.restorePosition != null ? widget.restorePosition : 0.0, keepScrollOffset: true);
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

    _getBlogData = getBlogData();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  List<Widget> buildBlogContent(content, context){
    List<Widget> blogWidget = new List<Widget>();
    if(content == null){
      blogWidget.add(Text('Loading blog'));
      return blogWidget;
    }
    Padding title = new Padding(
      padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
      child: Text(content['title'], style: Theme.of(context).textTheme.headline1),
    );
    // Add title
    blogWidget.add(title);
    // Add author
    Widget author = _userRepository.getUserWidget(context, content['user'], authorData);
    blogWidget.add(Padding(
      padding: EdgeInsets.only(top: 8, left: 24, right: 24),
      child: author,
    ));
    // Add time
    var date = content['time'].toDate();

    // Process contents
    if(content['article'] != null){
      for(var block in content['article']['blocks']){
        String blockText = block['data']['text'];
        if(block['type'] == 'paragraph'){
          blockText = blockText.replaceAll('&nbsp;', ' ');
          // handle link case
          if(wechatDescription == null){
            wechatDescription = blockText;
          }
          Widget curBlock = Text(blockText, style: Theme.of(context).textTheme.bodyText1,);
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
//                print(blockString);
                if(boldItalicEnd+9 < blockString.length){
                  processText(blockString.substring(boldItalicEnd+9), context).forEach((block) {
                    textLists.add(block);
                  });
                }
              }
              else{
                processText(blockString, context).forEach((block) {
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
                child: Text(blockText, style: Theme.of(context).textTheme.headline2,),
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
//              child: Image.network(block['data']['file']['url'], fit: BoxFit.contain,),
              child: InkWell(
                onTap: () {
                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => PhotoScreen(photoUrl: block['data']['file']['url'], photoType: 'network',)
                      )
                  );
                },
                child: Image.network(block['data']['file']['url'], fit: BoxFit.contain,),
              )
            )
          );
        }
        else if(block['type'] == 'embed'){
          String code = block['data']['code'];
//          int end = code.indexOf('>');
//          String pre = code.substring(0, end);
//          pre += " allowfullscreen ";
//          if(Platform.isIOS){
//            pre += "width=\"${MediaQuery.of(context).size.width*2.3}\" height=\"600\"";
//          }
//          else{
//            pre += "width=\"${MediaQuery.of(context).size.width*0.85}\" height=\"230\"";
//          }
//          code = pre + code.substring(end);
//          print(code);
          if(code.contains('163')){
            int end = code.indexOf('>');
            String pre = code.substring(0, end-3);
            if(Platform.isIOS){
              pre += "20\"";
            }
            else{
              pre += "20\" height=\"230\"";
            }
            code = pre + code.substring(end);
            end = code.indexOf('//');
            pre = code.substring(0, end);
            pre += 'https:';
            code = pre + code.substring(end);
//            print(code);
            blogWidget.add(
              HtmlWidget(
                code,
                webView: true,
              )
            );
          }
          else{
            if(code.contains('bilibili')){
              String url = code.split('\"')[1];
//              print(url);
              url = 'https:'+url;
              blogWidget.add(
                  RichText(
                    text: LinkTextSpan(
                        style: AppTheme.link,
                        url: url,
                        text: '点击此处，观看视频'
                    ),
                  )
              );
            }
            else {
              blogWidget.add(
                  HtmlWidget(
                    code,
                    webView: true,
                  )
              );
              String url = code.split('\"')[1];
//              print(url);
              if(code.contains('youtube') || code.contains('youtu')){
                blogWidget.add(
                    RichText(
                      text: LinkTextSpan(
                        style: AppTheme.link,
                        url: url,
                        text: '视频若无法观看，请点击此处',
                        innerOpen: false
                      ),
                    )
                );
              }
              else {
                blogWidget.add(
                    RichText(
                      text: LinkTextSpan(
                          style: AppTheme.link,
                          url: url,
                          text: '视频若无法观看，请点击此处',
                          innerOpen: true,
                      ),
                    )
                );
              }
            }
          }
        }
        else if(block['type'] == 'attaches' && block['data']['file']['extension'] == 'pdf') {
          blogWidget.add(
            FutureBuilder<PDFDocument>(
              future: getPDF(block['data']['file']['url'], block['data']['file']['name']),
              builder: (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    height: 300,
                    child: InkWell(
                      onTap: () {
                        Navigator.push<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(builder: (context) => FullPDFScreen(pdfPath: pdfPath, filename: block['data']['file']['name'],))
                        );
                      },
                      child: PDFView(
                        document: snapshot.data,
                      ),
                    )
                  );
                }
                else {
                  return SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: PlaceHolderCard(
                      text: 'Loading pdf...',
                      height: 200.0,
                    ),
                  );
                }
              },
            )
          );
        }
      }
    } // Handle old style content
    else if (content.containsKey('blocks')){
      for(var block in content['blocks']){
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

    if(content.containsKey('RSSarticle')){
      blogWidget.add(
        SizedBox(
          height: 20,
        )
      );

      blogWidget.add(
        Html(
          data: content['RSSarticle'],
          padding: EdgeInsets.all(16.0),
          defaultTextStyle: TextStyle(fontFamily: 'serif'),
          onLinkTap: (url) {
            launch(url, forceSafariVC: false);
          },
          onImageTap: (src) {
            Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => PhotoScreen(photoUrl: src, photoType: 'network',)
              )
            );
          },
        )
      );


    }

    blogWidget.add(
        Row(
            children: <Widget>[
              Expanded(
                  child: Divider()
              ),

              Text("Comments", style: Theme.of(context).textTheme.bodyText1),

              Expanded(
                  child: Divider()
              ),
            ]
        )
    );

    List<String> commentIDs = getCommentIDs(content);
    if (commentIDs.isNotEmpty){
      blogWidget.add(CommentBottom(key: commentBottomKey,pageID: widget.blogID, pageType: 'blog',));
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

  Future<PDFDocument> getPDF(url, filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = dir+'/'+filename;
    bool fileExisted = await File(filePath).exists();
    File file;
    if(!fileExisted){
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);

      file = new File(filePath);
      await file.writeAsBytes(bytes);
    }
    else {
      file = new File(filePath);
    }
    pdfPath = file.path;
    PDFDocument document = await PDFDocument.openFile(file.path);
    return document;
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
        future: _getBlogData,
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
                backgroundColor: Theme.of(context).primaryColor,
                appBar: AppBar(
//                  brightness: Brightness.dark,
                  title: Text('Blog正文'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
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
//                  iconTheme: IconThemeData(color: Colors.white),
                ),
                floatingActionButton: showFloatingAction ? BlogFloatingButton(
                  state: this,
                  userID: userID,
                  blogID: widget.blogID,
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
                ),
                backgroundColor: Theme.of(context).primaryColor,
                body: Center(
                  child: Text('Loadding Blog'),
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
  }) : super(key : key);

  final _BlogDetail state;
  final String userID;
  final String blogID;
  
  _BlogFloatingButtonState createState() => _BlogFloatingButtonState();
}

class _BlogFloatingButtonState extends State<BlogFloatingButton> {

  void buildShareSheet(BuildContext context, Map blog){
    var shareSheetController = showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          color: Theme.of(context).primaryColorLight,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 16),
                child: Text('分享至', style: Theme.of(context).textTheme.bodyText1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.people,),
                            iconSize: 40,
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
                    flex: 2,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(160.0)),
                        child: InkWell(
                          child: Image.asset('assets/icons/wechat.png', fit: BoxFit.cover,),
                          onTap: () {
                            shareToWeChat(
                              WeChatShareWebPageModel(
                                "https://freetitle.us/blogdetail?id=${widget.blogID}",
                                title: blog['title'],
                                description: widget.state.wechatDescription != null ? widget.state.wechatDescription : "点击阅读全文",
                                thumbnail: widget.state.wechatThumbnailUrl != null ? WeChatImage.network(widget.state.wechatThumbnailUrl) : WeChatImage.network('https://freetitle.us/static/media/background_bw.b784d709.png'),
                              )
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(160.0)),
                          child: InkWell(
                            child: Image.asset('assets/icons/wechat_timeline.png', fit: BoxFit.cover,),
                            onTap: () {
                              shareToWeChat(
                                  WeChatShareWebPageModel(
                                    "https://freetitle.us/blogdetail?id=${widget.blogID}",
                                    title: blog['title'],
                                    scene: WeChatScene.TIMELINE,
                                    description: widget.state.wechatDescription != null ? widget.state.wechatDescription : "点击阅读全文",
                                    thumbnail: widget.state.wechatThumbnailUrl != null ? WeChatImage.network(widget.state.wechatThumbnailUrl) : WeChatImage.network('https://freetitle.us/static/media/background_bw.b784d709.png'),
                                  ));
                            },
                          )
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(160.0)),
                          child: InkWell(
                            child: Image.asset('assets/icons/wechat_favorite.png', fit: BoxFit.cover,),
                            onTap: () {
                              shareToWeChat(
                                  WeChatShareWebPageModel(
                                    "https://freetitle.us/blogdetail?id=${widget.blogID}",
                                    title: blog['title'],
                                    scene: WeChatScene.FAVORITE,
                                    description: widget.state.wechatDescription != null ? widget.state.wechatDescription : "点击阅读全文",
                                    thumbnail: widget.state.wechatThumbnailUrl != null ? WeChatImage.network(widget.state.wechatThumbnailUrl) : WeChatImage.network('https://freetitle.us/static/media/background_bw.b784d709.png'),
                                  ));
                            },
                          )
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(CupertinoIcons.share,),
                          iconSize: 40,
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
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppTheme.primary,
                    ),
                    child: Center(
                      child: Text('取消', style: TextStyle(color: AppTheme.white),)
                    ),
                  ),
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