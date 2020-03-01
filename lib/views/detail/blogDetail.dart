import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:freetitle/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/comment/comment.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:freetitle/views/comment/commentInput.dart';

class _LinkTextSpan extends TextSpan {

  _LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: TapGestureRecognizer()..onTap = () {
        launch(url, forceSafariVC: false);
      }
  );
}

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
  @override
  void initState(){
    _userRepository = new UserRepository();
    super.initState();
  }

  @override
  void dispose() {
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

  List<Widget> processBlogContent(blog){
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
    blogWidget.add(author);
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
                textLists.add( _LinkTextSpan(
                  style: AppTheme.caption,
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
      blogWidget.add(CommentBottom(commentIDs: commentIDs, blogID: widget.blogID,));
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('blogs').document(widget.blogID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return new Text('Loading');
          default:
            if(snapshot.data.data != null){
              blog = snapshot.data.data;
              return Scaffold(
                  appBar: AppBar(
                    actions: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: (){
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => CommentPage(commentIDs: getCommentIDs(blog), blogID: widget.blogID,),
                              )
                            );
                          },
                        ),
                      ),
                    ],
                    backgroundColor: AppTheme.primary,
                    iconTheme: IconThemeData(color: Colors.white),
                  ),
                  floatingActionButton: SpeedDial(
                    marginRight: 18,
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
                        child: Icon(Icons.favorite),
                        backgroundColor: AppTheme.secondary,
                        label: "点赞",
                        labelStyle: AppTheme.body1,
                        onTap: () => print('点赞'),
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.comment),
                        backgroundColor: AppTheme.secondary,
                        label: "评论",
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
                      //TODO 分享 to be implemented
                        child: Icon(Icons.share),
                        backgroundColor: AppTheme.secondary,
                        label: "分享",
                        labelStyle: AppTheme.body1,
                        onTap: () => print('分享'),
                      )
                    ],
                  ),
                body: SingleChildScrollView(
                  child: Column(
                    children:
                      processBlogContent(blog),
                  ),
                )
              );
            }
            else{
              return Text("Loading blog");
            }
        }
      },
    );
  }
}