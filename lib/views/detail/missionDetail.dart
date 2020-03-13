import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
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

  List<Widget> processMissionContent(mission){
    List<Widget> missionWidget = new List<Widget>();
    if(mission == null){
      missionWidget.add(Text('Loading mission'));
      return missionWidget;
    }
    // Add time
//    var date = mission['time'].toDate();

    // Process contents
    if(mission['article'] != null){
      for(var block in mission['article']['blocks']){
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
                child: Text(block['data']['text'], style: AppTheme.title,),
              )
          );
        }
        else if(block['type'] == 'image'){
          if(block['data']['file']['url'] == null){
            continue;
          }
          missionWidget.add(
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.network(block['data']['file']['url'], fit: BoxFit.contain,),
              )
          );
        }
      }
    }
    else{
      for(var block in mission['blocks']){
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
    missionWidget.add(
        SizedBox(
          height: 36,
        )
    );
    return missionWidget;
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
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 48.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                                    children: processMissionContent(missionData),
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
                                  child: Icon(
                                    Icons.share,
                                    color: AppTheme.primary,
                                    size: 28,
                                  ),
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
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 70,
              right: 35,
              child: Row(
                children: getLabels()
              )
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
