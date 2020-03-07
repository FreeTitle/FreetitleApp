import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/main.dart';
//import 'package:freetitle/model/mission_list_data.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/detail/missionDetail.dart';

class PopularMissionListView extends StatefulWidget {
  const PopularMissionListView(
      {Key key, 
        this.missionList,
        this.missionID,
      }) : super(key: key);
  final List missionList;
  final String missionID;
  @override
  _PopularMissionListViewState createState() => _PopularMissionListViewState();
}

class _PopularMissionListViewState extends State<PopularMissionListView>
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

  void getMission(missionData, missionID){
    Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => MissionDetail(missionData: missionData, missionID: missionID,),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    List missionList = widget.missionList;
    String missionID = widget.missionID;
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 16),
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
                    top: 0, bottom: 0, right: 16, left: 16),
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

                  return PopularMissionView(
                      mission: missionList[index],
                      animation: animation,
                      animationController: animationController,
                      callback: () {
                        getMission(missionList[index], missionID);
                    },
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

class PopularMissionView extends StatelessWidget {
  const PopularMissionView(
      {Key key,
        this.mission,
        this.animationController,
        this.animation,
        this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Map mission;
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
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: SizedBox(
                width: 280,
                height: 200,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Text(
                                              mission['name'],
                                              textAlign: TextAlign.left,
                                              style: AppTheme.headline
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  height: 100,
                                                  width: 100,
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                                                    child: AspectRatio(
                                                        aspectRatio: 0.2,
                                                        child: Image.network(mission['images'][0])
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 16, bottom: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: <Widget>[
//                                                        const SizedBox(
//                                                          width: 72.0,
//                                                        ),
                                                        Text(
                                                          'Username',
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12,
                                                            letterSpacing: 0.27,
                                                            color: AppTheme.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 16, bottom: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                      children: <Widget>[
//                                                        const SizedBox(
//                                                          width: 48.0,
//                                                        ),
                                                        Text(
                                                          '30 Joined',
                                                          textAlign:
                                                          TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w200,
                                                            fontSize: 12,
                                                            letterSpacing: 0.27,
                                                            color: AppTheme.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]
                              ),
                            ),
                          )
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
class LatestMissionListView extends StatefulWidget {
  const LatestMissionListView(
      {Key key,
        this.callBack,
        this.missionData
      }) : super(key: key);

  // callback passed downwards for handling tapping
  final Function callBack;
  final List missionData;
  @override
  _LatestMissionListViewState createState() => _LatestMissionListViewState();
}

class _LatestMissionListViewState extends State<LatestMissionListView>
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
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
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
    List missionData = widget.missionData;
    return GridView(
      padding: const EdgeInsets.all(8),
//              physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      children: List<Widget>.generate(
        missionData.length,
            (int index) {
          final int count = missionData.length;
          final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          animationController.forward();
          return LatestMissionView(
            callback: () {
              widget.callBack();
            },
            mission: missionData[index],
            animation: animation,
            animationController: animationController,
          );
        },
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 32.0,
        crossAxisSpacing: 32.0,
        childAspectRatio: 0.8,
      ),
    );
  }
}


class LatestMissionView extends StatelessWidget {
  const LatestMissionView(
      {Key key,
        this.mission,
        this.animationController,
        this.animation,
        this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Map mission;
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
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
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
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, left: 16, right: 16),
                                            child: Text(
                                              mission['name'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: AppTheme.darkerText,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                left: 16,
                                                right: 16,
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Username',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: AppTheme.grey,
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        '30 Joined',
                                                        textAlign:
                                                        TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w200,
                                                          fontSize: 12,
                                                          letterSpacing: 0.27,
                                                          color: AppTheme.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                    Container(
                      child: Padding(
                        padding:
                          const EdgeInsets.only(top: 0, right: 8, left: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.grey
                                      .withOpacity(0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 6.0),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                              aspectRatio: 1.28,
                              child: Image.network(mission['images'][0])
                            ),
                          ),
                        ),
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
