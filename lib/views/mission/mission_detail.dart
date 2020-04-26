import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/photo.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/comment/comment_bottom.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:freetitle/views/comment/comment.dart';
import 'package:freetitle/model/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluwx/fluwx.dart';
import 'package:freetitle/views/chat/contact_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:freetitle/views/login/login.dart';
import 'package:freetitle/views/comment/commentInput.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:freetitle/model/full_pdf_screen.dart';

class MissionDetail extends StatefulWidget {
  const MissionDetail(
  { Key key,
    @required this.missionID,
    this.restorePosition,
  }) : super(key: key);

  final String missionID;
  final double restorePosition;

  @override
  _MissionDetail createState() => _MissionDetail();
}

class _MissionDetail extends State<MissionDetail>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  UserRepository _userRepository;

  String wechatThumbnailUrl;
  String wechatDescription;
  bool showFloatingAction = true;
  Future<bool> _getMissionData;

  bool liked = false;
  bool followed = false;
  String userID;

  SharedPreferences sharedPref;
  Map missionData;
  Map authorData;
  String pdfPath;

  @override
  void initState() {

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    _userRepository = new UserRepository();

    _getMissionData = getMissionData();

    SharedPreferences.getInstance().then((pref) {
      sharedPref = pref;
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget getImage(missionData){
    Widget img;
    img = InkWell(
      child: Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.cover,),
      onTap: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoScreen(photoType: 'asset', photoUrl: 'assets/images/blog_placeholder.png',)
          )
        );
      },
    );
    if(missionData['article'] != null){
      for(var block in missionData['article']['blocks']){
        if(block['type'] == "image"){
          if(block['data']['file']['url'] != null){
//            img = Image.network(block['data']['file']['url'], fit: BoxFit.cover,);
            img = InkWell(
              child: Image.network(block['data']['file']['url'], fit: BoxFit.cover,),
              onTap: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PhotoScreen(photoType: 'network', photoUrl: block['data']['file']['url'],)
                    )
                );
              },
            );
            break;
          }
        }
      }
    }
    return img;
  }

  List<Widget> buildMissionContent(content, context){
    List<Widget> missionWidget = new List<Widget>();
    if(content == null){
      missionWidget.add(Text('Loading mission'));
      return missionWidget;
    }

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

          missionWidget.add(
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 16.0, left: 24.0, right: 24.0),
                child: curBlock,
              )
          );
        }
        else if(block['type'] == 'header'){
          missionWidget.add(
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
          missionWidget.add(
              Padding(
                padding: EdgeInsets.all(20.0),
//                child: Image.network(block['data']['file']['url'], fit: BoxFit.contain,),
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
            print(code);
            missionWidget.add(
                HtmlWidget(
                  code,
                  webView: true,
                )
            );
          }
          else{
            if(code.contains('bilibili')){
              String url = code.split('\"')[1];
              print(url);
              url = 'https:'+url;
              missionWidget.add(
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
              missionWidget.add(
                  HtmlWidget(
                    code,
                    webView: true,
                  )
              );
              String url = code.split('\"')[1];
              print(url);
              if(code.contains('youtube') || code.contains('youtu')){
                missionWidget.add(
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
                missionWidget.add(
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
          missionWidget.add(
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
          missionWidget.add(
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.network(block, fit: BoxFit.contain,),
              )
          );
        }
        else{
          missionWidget.add(
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 24.0, right: 24.0),
                child: Text(block, style: TextStyle(height: 2, fontSize: 15),),
              )
          );
        }
      }
    }

    if(content.containsKey('RSSarticle')){
      missionWidget.add(
          SizedBox(
            height: 20,
          )
      );

      missionWidget.add(
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


    missionWidget.add(
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


    List<String> commentIDs = getCommentIDs(content);
    if (commentIDs.isNotEmpty){
      missionWidget.add(
          CommentBottom(
            pageID: widget.missionID,
            pageType: 'mission',
          )
      );
    }else{
      missionWidget.add(PlaceHolderCard(text: 'No comments yet', height: 200.0,));
    }

    missionWidget.add(
        SizedBox(
          height: 36,
        )
    );

    return missionWidget;
  }

  List<Widget> getLabels(missionData){
    List<Widget> labels = List();
    for(var label in missionData['labels']){
      labels.add(
        Card(
          color: AppTheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
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

  Future<bool> getMissionData() async {
    await _userRepository.getUser().then((snap) {
      if(snap != null)
        userID = snap.uid;
    });

    missionData = Map();
    await Firestore.instance.collection('missions').document(widget.missionID).get().then((snap) {
      missionData = snap.data;
    });

    authorData = Map();
    await Firestore.instance.collection('users').document(missionData['ownerID']).get().then((snap) {
      authorData = snap.data;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _getMissionData,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(missionData['followedBy'] != null && missionData['followedBy'].contains(userID)){
            followed = true;
          }
          if(missionData['upvotedBy'] != null && missionData['upvotedBy'].contains(userID)){
            liked = true;
          }

          return Container(
            color: AppTheme.nearlyWhite,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: showFloatingAction
                  ? MissionFloatingButton(
                      state: this,
                      userID: userID,
                      missionID: widget.missionID,
                      wechatDescription: wechatDescription,
                      wechatThumbnailUrl: wechatThumbnailUrl,
                    )
                  : Container(),
              body: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: getImage(missionData),
                      ),
                    ],
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.67,
                    minChildSize: 0.67,
                    maxChildSize: 0.89,
                    builder: (BuildContext context, ScrollController _scrollController) {
                      _scrollController.addListener(() {
                        try{
                          List<String> missionStore = List();
                          missionStore.add('mission');
                          missionStore.add(widget.missionID);
                          missionStore.add(_scrollController.position.pixels.toString());
                          sharedPref.setStringList('article', missionStore);
                        }catch(e) {
                          print('store mission position failed $e');
                        }
                      });
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
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 44),
                                child: Column(
                                  children: <Widget>[
                                    Flexible(
                                      child: SingleChildScrollView(
                                        controller: _scrollController,
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                  children: getLabels(missionData)
                                              ),
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
                                                    _userRepository.getUserWidget(context, missionData['ownerID'], authorData),
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
                                            left: 16, bottom: 24, right: 16),
                                        child: InkWell(
                                          onTap: () async {
                                            if (userID == null){
                                              Navigator.push<dynamic>(
                                                context,
                                                MaterialPageRoute<dynamic>(
                                                  builder: (BuildContext context) => LoginScreen(),
                                                ),
                                              );
                                              return;
                                            }
                                            followed = !followed;
                                            setState(() {

                                            });

                                            if(followed){
                                              await Firestore.instance.collection('missions').document(widget.missionID).get().then((snap) async {
                                                if(snap.data.isNotEmpty){
                                                  await _userRepository.getUser().then((snap) {
                                                    userID = snap.uid;
                                                  });
                                                  await Firestore.instance.collection('missions').document(widget.missionID).updateData({
                                                    'followedBy': FieldValue.arrayUnion([userID])
                                                  });
                                                  await Firestore.instance.collection('users').document(userID).updateData({
                                                    'follows': FieldValue.arrayUnion([widget.missionID])
                                                  });
                                                }
                                              });
                                            }
                                            else{
                                              await Firestore.instance.collection('missions').document(widget.missionID).get().then((snap) async {
                                                if(snap.data.isNotEmpty){
                                                  await _userRepository.getUser().then((snap) {
                                                    userID = snap.uid;
                                                  });
                                                  await Firestore.instance.collection('missions').document(widget.missionID).updateData({
                                                    'followedBy': FieldValue.arrayRemove([userID])
                                                  });
                                                  await Firestore.instance.collection('users').document(userID).updateData({
                                                    'follows': FieldValue.arrayRemove([widget.missionID])
                                                  });
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 48,
                                            width: 250,
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
                                                followed ? 'Unfollow' : 'Follow',
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
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
//                          Positioned(
//                              top: 0,
//                              left: MediaQuery.of(context).size.width/2,
//                              child: IconButton(
//                                icon: Icon(Icons.keyboard_arrow_up),
//                                onPressed: () {
//
//                                },
//                              )
//                          ),
                          Positioned(
                            top: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Container(
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_upward),
                                    onPressed: () {
                                      _scrollController.jumpTo(0.0);
                                    },
                                  ),
                                )
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: MediaQuery.of(context).padding.left + 20,
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
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppTheme.white,
              ),
              body: Center(
                child: Text('Loadding mission'),
              )
          );
        }
      },
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


class MissionFloatingButton extends StatefulWidget {
  MissionFloatingButton(
  {Key key,
    @required this.state,
    @required this.userID,
    @required this.missionID,
    @required this.wechatThumbnailUrl,
    @required this.wechatDescription
  }) : super(key : key);

  final _MissionDetail state;
  final String userID;
  final String missionID;
  final String wechatThumbnailUrl;
  final String wechatDescription;
  
  _MissionFloatingButtonState createState() => _MissionFloatingButtonState();
}

class _MissionFloatingButtonState extends State<MissionFloatingButton> {

  void buildShareSheet(BuildContext context, Map mission){
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
                                    builder: (BuildContext context) => ContactListView(sharedMissionID: widget.missionID,)
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
                                "https://freetitle.us/missiondetail?id=${widget.missionID}",
                                title: mission['title'],
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
                            Share.share('请看Mission${mission['title']}，点击https://freetitle.us/missiondetail?id=${widget.missionID}', subject: 'Look at this')
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
    final userID = widget.userID;
    return SpeedDial(
      marginRight: 20,
      marginBottom: 80,
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
          label: "点赞 ${widget.state.missionData['likes'].toString()}",
          labelStyle: AppTheme.body1,
          onTap: () {
            if (widget.state.userID==null){
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

            Firestore.instance.collection('missions').document(widget.missionID).updateData({
              "likes": FieldValue.increment((widget.state.liked ? (1) : (-1))),
            }).whenComplete(() {
              print('succeeded');
            }).catchError((e) {
              print('get error $e');
            });

            if(widget.state.liked){
              Firestore.instance.collection('missions').document(widget.missionID).updateData({
                "upvotedBy": FieldValue.arrayUnion([userID]),
              }).whenComplete(() {
                print('like  succeeds');
              }).catchError((e) {
                print('like gets error $e');
              });
              widget.state.missionData['likes'] += 1;
            }
            else{
              Firestore.instance.collection('missions').document(widget.missionID).updateData({
                "upvotedBy": FieldValue.arrayRemove([userID]),
              }).whenComplete(() {
                print('unlike  succeeds');
              }).catchError((e) {
                print('unlike gets error $e');
              });
              widget.state.missionData['likes'] -= 1;
            }
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.comment),
          backgroundColor: AppTheme.secondary,
          label: "评论 ${widget.state.missionData['comments'] != null ? widget.state.missionData['comments'].length.toString() : '0' }",
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
                    builder: (BuildContext context) => CommentInputPage(pageID: widget.missionID, parentLevel: 0, parentID: widget.missionID, parentType: 'mission', pageType: 'mission', targetID: widget.missionID,)
                )
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.share),
          backgroundColor: AppTheme.secondary,
          label: "分享",
          labelStyle: AppTheme.body1,
          onTap: () {
            buildShareSheet(context, widget.state.missionData);
          },
        ),
      ],
    );
  }
}