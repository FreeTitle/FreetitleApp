import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/comment/comment.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:freetitle/views/comment/commentInput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freetitle/model/util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';
import 'dart:io';

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
  final commentPageKey = PageStorageKey('CommentPage');


  @override
  void initState(){
    _userRepository = new UserRepository();
    _userRepository.getUser().then((snap) => {
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

  List<Widget> processBlogContent(blog, context){
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
        if(block['type'] == 'paragraph'){
          // handle link case
          Widget curBlock = Text(block['data']['text']);
          List<TextSpan> textLists = new List<TextSpan>();
          if (block['data']['text'].contains('<a')){
            List<String> blockTexts = block['data']['text'].split('<a ');
            for(String blockText in blockTexts){
              if(blockText.contains('href=')){
                int startURL = blockText.indexOf('href=')+6;
                int endUrl = blockText.indexOf('">');
                String url = blockText.substring(startURL, endUrl);
                int endLink = blockText.indexOf('</a>');
                String link = blockText.substring(endUrl+2, endLink);
                textLists.add( LinkTextSpan(
                  style: AppTheme.link,
                  url: url,
                  text: link,
                ),);
                textLists.add(TextSpan(
                  style: AppTheme.body1,
                  text: blockText.substring(endLink+4),
                ));
              }
              else{
                textLists.add(TextSpan(
                  style: AppTheme.body1,
                  text: blockText,
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
                child: Text(block['data']['text'], style: AppTheme.title,),
              )
          );
        }
        else if(block['type'] == 'image'){
          if(block['data']['file']['url'] == null){
            continue;
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
    else{
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

  @override
  Widget build(BuildContext context) {
    Map blog;

    return StreamBuilder<DocumentSnapshot>(
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
                  floatingActionButton: SpeedDial(
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
                        //TODO 点赞 to be implemented
                        child: liked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                        backgroundColor: AppTheme.secondary,
                        label: "点赞 ${blog['likes'].toString()}",
                        labelStyle: AppTheme.body1,
                        onTap: () {
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
                        //TODO 分享 to be implemented
                        child: Icon(Icons.share),
                        backgroundColor: AppTheme.secondary,
                        label: "分享",
                        labelStyle: AppTheme.body1,
                        onTap: () {
                          Share.share('请看博客${blog['title']}，点击https://freetitle.us/blogdetail?id=${widget.blogID}', subject: 'Look at this')
                              .catchError((e) => {
                            print('sharing error ${e}')
                          });
                        },
                      ),
                    ],
                  ),
                  resizeToAvoidBottomPadding: false,
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      key: PageStorageKey('blogDetail'),
                      children: processBlogContent(blog, context),
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
    );
  }
}