import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:freetitle/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:flutter/material.dart';


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
        this.blogData,
      })
      : super(key: key);
  final Map blogData;

  @override
  State<StatefulWidget> createState() {
    return _BlogDetail();
  }
}


class _BlogDetail extends State<BlogDetail> {

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // TODO 插入link的处理
  List<Widget> processBlogContent(){
    Map blog = widget.blogData;
    List<Widget> blogWidget = new List<Widget>();
    Padding title = new Padding(
      padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
      child: Text(blog['title'], style: AppTheme.headline,),
    );
    // Add title
    blogWidget.add(title);
    // Add author
    Widget author = StreamBuilder<DocumentSnapshot> (
      stream: Firestore.instance.collection('users').document(blog['user']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.hasError)
          return new Text('Error: ${snapshot
              .error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading');
          default:
            if (snapshot.hasData) {
              final userData = snapshot.data;
              String userName = userData['displayName'];
              String avatarURL = userData['avatarUrl'];
              Image avatar = Image.network(avatarURL);
              return Padding(
                padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.6),
                              offset: const Offset(2.0, 4.0),
                              blurRadius: 2),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(60.0)),
                        child: avatar,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }
            else{
              return Text('Author');
            }
        }
      },
    );
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
    return blogWidget;
  }

  @override
  Widget build(BuildContext context) {
    Map blog = widget.blogData;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.comment),
          )
        ],
        backgroundColor: AppTheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:
              processBlogContent(),
        ),
      ),
    );
  }
}