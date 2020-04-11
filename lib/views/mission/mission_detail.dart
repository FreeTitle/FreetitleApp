import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:freetitle/views/comment/comment.dart';
import 'package:freetitle/model/util.dart';

class MissionDetail extends StatefulWidget {
  const MissionDetail(
  { Key key,
    this.missionData,
    this.missionID,
  }) : super(key: key);

  final Map missionData;
  final String missionID;

  @override
  _MissionDetail createState() => _MissionDetail();
}

class _MissionDetail extends State<MissionDetail>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  UserRepository _userRepository;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    _userRepository = UserRepository();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Image getImage(){
    Image img;
    img = Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.cover,);
    if(widget.missionData['article'] != null){
      for(var block in widget.missionData['article']['blocks']){
        if(block['type'] == "image"){
          if(block['data']['file']['url'] != null){
            img = Image.network(block['data']['file']['url'], fit: BoxFit.cover,);
            break;
          }
        }
      }
    }
    return img;
  }

  List<Widget> buildMissionContent(mission, context){
    List<Widget> blogWidget = new List<Widget>();
    if(mission == null){
      blogWidget.add(Text('Loading blog'));
      return blogWidget;
    }
//    Padding title = new Padding(
//      padding: EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
//      child: Text(mission['name'], style: AppTheme.headline,),
//    );
//    // Add title
//    blogWidget.add(title);
//    // Add author
//    Widget author = _userRepository.getUserWidget(mission['ownerID']);
//    blogWidget.add(Padding(
//      padding: EdgeInsets.only(top: 8, left: 24, right: 24),
//      child: author,
//    ));
    // Add time
    var date = mission['time'].toDate();

    // Process contents
    if(mission['article'] != null){
      for(var block in mission['article']['blocks']){
        String blockText = block['data']['text'];
        if(block['type'] == 'paragraph'){
          blockText = blockText.replaceAll('&nbsp;', ' ');
          // handle link case
//          if(wechatDescription == null){
//            wechatDescription = blockText;
//          }
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
//          if(wechatThumbailUrl == null){
//            wechatThumbailUrl = block['data']['file']['url'];
//          }
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
    else if (mission.containsKey('blocks')){
      for(var block in mission['blocks']){
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

    if(mission.containsKey('RSSarticle')){
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
              initialUrl: Uri.dataFromString("<html><body>${mission['RSSarticle']}</body></html>",
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

//    if (blog['comments'] != null){
//      List<String> commentIDs = new List();
//      for(String commentID in blog['comments']){
//        commentIDs.add(commentID);
//      }
//      if (commentIDs.isNotEmpty){
//        blogWidget.add(CommentBottom(commentIDs: commentIDs,));
//      }
//    }
    List<String> commentIDs = getCommentIDs(mission);
    if (commentIDs.isNotEmpty){
      blogWidget.add(CommentBottom(commentIDs: commentIDs.length > 3 ? commentIDs.sublist(commentIDs.length-3) : commentIDs, blogID: widget.missionID,));
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

  List<Widget> getLabels(){
    List<Widget> labels = List();
    for(var label in widget.missionData['labels']){
      labels.add(
        Card(
          color: AppTheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          elevation: 10.0,
          child: Container(
            width: 100,
            height: 40,
            child: Center(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.white),
                )
            ),
          ),
        )
      );
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    Map missionData = widget.missionData;
//    String missionID = widget.missionID;
    return Container(
      color: AppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: getImage(),
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.67,
              minChildSize: 0.67,
              maxChildSize: 0.89,
              builder: (BuildContext context, ScrollController _scrollController) {
                return Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.2),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 22),
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Container(
//                            constraints: BoxConstraints(
//                                minHeight: infoHeight,
//                                maxHeight: tempHeight > infoHeight
//                                    ? tempHeight
//                                    : infoHeight),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 32.0, left: 18, right: 18),
                                          child: Text(
                                            missionData['name'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22,
                                              letterSpacing: 0.27,
                                              color: AppTheme.darkerText,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 18, right: 18, bottom: 8, top: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              _userRepository.getUserWidget(missionData['ownerID']),
              //                                NOTE 预留位
              //                                Container(
              //                                  child: Row(
              //                                    children: <Widget>[
              //                                      Text(
              //                                        '4 Joined',
              //                                        textAlign: TextAlign.left,
              //                                        style: TextStyle(
              //                                          fontWeight: FontWeight.w200,
              //                                          fontSize: 22,
              //                                          letterSpacing: 0.27,
              //                                          color: AppTheme.grey,
              //                                        ),
              //                                      ),
              //                                    ],
              //                                  ),
              //                                )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 8, bottom: 0, left: 16, right: 16),
                                          child: Text(
                                            'We are looking for: ',
                                            style: AppTheme.body1,
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: Container(
                                            height: 75,
                                            child: Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: ListView.builder(
                                                    itemCount: missionData['needs'].length,
                                                    scrollDirection: Axis.horizontal,
                                                    itemBuilder: (BuildContext context, int index){
                                                      return getRoleBoxUI('0', missionData['needs'][index]);
                                                    }
                                                )
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8, top: 0, bottom: 0),
                                          child: Column(
                                            children: buildMissionContent(missionData, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16,
                                      left: 16, bottom: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 48,
                                        height: 48,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.nearlyWhite,
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(16.0),
                                              ),
                                              border: Border.all(
                                                  color: AppTheme.grey
                                                      .withOpacity(0.2)),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.share,
                                                color: AppTheme.primary,
                                                size: 28,
                                              ),
                                              onPressed: () {
                                                Share.share('请看Mission${missionData['name']}，点击https://freetitle.us/missiondetail?id=${widget.missionID}', subject: 'Look at this')
                                                    .catchError((e) => {
                                                  print('sharing error ${e}')
                                                });
                                              },
                                            )
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primary,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(16.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: AppTheme
                                                      .primary
                                                      .withOpacity(0.5),
                                                  offset: const Offset(1.1, 1.1),
                                                  blurRadius: 10.0),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Follow',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: 0.0,
                                                color: AppTheme
                                                    .nearlyWhite,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 10,
                        child: Row(
                            children: getLabels()
                        )
                    ),
                  ],
                );
              },
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
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,// You can use like this way or like the below line
                        //borderRadius: new BorderRadius.circular(30.0),
                        color: AppTheme.grey.withOpacity(0.5),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.nearlyWhite,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getRoleBoxUI(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 4.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 预留位
//              Text(
//                text1,
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                  fontWeight: FontWeight.w600,
//                  fontSize: 14,
//                  letterSpacing: 0.27,
//                  color: AppTheme.nearlyBlue,
//                ),
//              ),
              Text(
                text2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
