import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/main.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/mission/mission_detail.dart';

class HorizontalMissionListView extends StatefulWidget {
  const HorizontalMissionListView(
      {Key key, 
        @required this.missionList,
        @required this.missionIDs,
      }) : super(key: key);
  final List missionList;
  final List missionIDs;
  @override
  _HorizontalMissionListViewState createState() => _HorizontalMissionListViewState();
}

class _HorizontalMissionListViewState extends State<HorizontalMissionListView>
with TickerProviderStateMixin {
  AnimationController animationController;
  ScrollController _scrollController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _scrollController = ScrollController();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose(){
    animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List missionList = widget.missionList;
    List missionIDs = widget.missionIDs;
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: Container(
        height: 200,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
            if (!snapshot.hasData) {
              return const SizedBox();
            }
            else{
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 0),
                itemCount: missionList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index){
                  final int count = missionList.length > 5
                      ? 5
                      : missionList.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return HorizontalMissionView(
                      missionData: missionList[index],
                      missionID: missionIDs[index],
                      animation: animation,
                      animationController: animationController,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class HorizontalMissionView extends StatelessWidget {
  const HorizontalMissionView(
      {Key key,
        @required this.missionData,
        @required this.missionID,
        this.animationController,
        this.animation
      })
      : super(key: key);
  
  final Map missionData;
  final String missionID;
  final AnimationController animationController;
  final Animation<dynamic> animation;


  Image getImage(){
    Image img;
    img = Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.cover,);
    if(missionData['article'] != null){
      for(var block in missionData['article']['blocks']){
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

  @override
  Widget build(BuildContext context) {
    PageStorageKey keyMissionDetail = PageStorageKey('blogDetail');
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child){
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => MissionDetail(key: keyMissionDetail, missionID: missionID,),
                    )
                );
              },
              child: SizedBox(
                width: 240,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey
                                          .withOpacity(0.2),
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 6.0),
                                ],
                              ),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16, left: 24, bottom: 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            //TODO this truncate is ugly... needs to be fixed taking into account different languages
                                            missionData['name'].length > 12 ? missionData['name'].substring(0,12)+'...' : missionData['name'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              letterSpacing: 0.27,
                                              color: AppTheme.darkerText,
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.only(
//                                          left: 24, bottom: 0),
//                                      child: Row(
//                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                        crossAxisAlignment: CrossAxisAlignment.center,
//                                        children: <Widget>[
//                                          Container(
//                                            child: Text(
//                                              mission['username'],
//                                              textAlign: TextAlign.left,
//                                              style: TextStyle(
//                                                fontWeight: FontWeight.w400,
//                                                fontSize: 12,
//                                                letterSpacing: 0.27,
//                                                color: AppTheme.grey,
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Container(
                                        height: 120,
                                        width: 180,
//                                        decoration: BoxDecoration(
//                                          borderRadius:
//                                          const BorderRadius.all(Radius.circular(16.0)),
//                                          boxShadow: <BoxShadow>[
//                                            BoxShadow(
//                                                color: AppTheme.grey
//                                                    .withOpacity(0.2),
//                                                offset: const Offset(0.0, 0.0),
//                                                blurRadius: 6.0),
//                                          ],
//                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                          child: AspectRatio(
                                            aspectRatio: 1.5,
                                            child: getImage(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// List View showing latest missions
class VerticalMissionListView extends StatefulWidget {
  const VerticalMissionListView(
      {Key key,
        @required this.missionList,
        @required this.missionIDs,
      }) : super(key: key);

  // callback passed downwards for handling tapping
  final List missionList;
  final List missionIDs;
  @override
  _VerticalMissionListViewState createState() => _VerticalMissionListViewState();
}

class _VerticalMissionListViewState extends State<VerticalMissionListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }
  

  List<Widget> buildMissionGrid(){
    List missionList = widget.missionList;
    List missionIDs = widget.missionIDs;
    List<Widget> missionGrid = List();
    for (var i = 0;i < missionList.length-1;i+=2){
      final int count = missionList.length;
      final Animation<double> animation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * i, 1.0,
              curve: Curves.fastOutSlowIn),
        ),
      );
      animationController.forward();
      missionGrid.add(Row(
        children: <Widget>[
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width/2-25,
            child: AnimatedVerticalMissionView(
              missionID: missionIDs[i],
              missionData: missionList[i],
              animationController: animationController,
              animation: animation,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width/2-25,
            child: AnimatedVerticalMissionView(
              missionID: missionIDs[i+1],
              missionData: missionList[i+1],
              animationController: animationController,
              animation: animation,
            ),
          ),
        ],
      ));
      missionGrid.add(SizedBox(
          height: 20,
      ));
    }
    if (missionList.length % 2 != 0){
      final int count = missionList.length;
      final Animation<double> animation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * missionList.length-1, 1.0,
              curve: Curves.fastOutSlowIn),
        ),
      );
      animationController.forward();
      missionGrid.add(Row(
        children: <Widget>[
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width/2-25,
            child: AnimatedVerticalMissionView(
              missionID: missionIDs[missionIDs.length-1],
              missionData: missionList[missionList.length-1],
              animationController: animationController,
              animation: animation,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width/2-25,
            child: SizedBox(

            ),
          )
        ],
      ));
    }
    return missionGrid;
  }

  @override
  Widget build(BuildContext context) {
//    List missionData = widget.missionList;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildMissionGrid(),
    );
  }
}


class AnimatedVerticalMissionView extends StatelessWidget {
  const AnimatedVerticalMissionView(
      {Key key,
        this.missionData,
        this.missionID,
        this.animationController,
        this.animation})
      : super(key: key);
  
  final Map missionData;
  final String missionID;
  final AnimationController animationController;
  final Animation<dynamic> animation;



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child){
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: VerticalMissionCard(missionData: missionData, missionID: missionID,)
          ),
        );
      },
    );
  }
}

class VerticalMissionCard extends StatelessWidget {

  const VerticalMissionCard({Key key, this.missionData, this.missionID}) : super(key : key);

  final Map missionData;
  final String missionID;

  Image getImage(){
    Image img;
    img = Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.cover,);
    if(missionData['article'] != null){
      for(var block in missionData['article']['blocks']){
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

  @override
  Widget build(BuildContext context) {
    PageStorageKey keyMissionDetail = PageStorageKey('blogDetail');
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => MissionDetail(key: keyMissionDetail, missionID: missionID,),
            )
        );
      },
      child: SizedBox(
        height: 280,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor('#F8FAFB'),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey
                                  .withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 6.0),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 16, right: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              missionData['name'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: AppTheme.darkerText,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
                                      child: Container(
                                        child: ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(8.0)),
                                          child: AspectRatio(
                                            aspectRatio: 1.28,
                                            child: getImage(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

