import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/main.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/detail/missionDetail.dart';

class MyMissionListView extends StatefulWidget {
  const MyMissionListView(
      {Key key,
        this.ownerID,
        this.missionIDs,
      }) : super(key: key);
  final String ownerID;
  final List missionIDs;
  @override
  _MyMissionListViewState createState() => _MyMissionListViewState();
}

class _MyMissionListViewState extends State<MyMissionListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  ScrollController _scrollController;
  List missionList;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _scrollController = ScrollController();
    missionList = List();
    super.initState();
  }

  Future<bool> getData() async {
//    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    missionList.clear();
    final snaphots = await Firestore.instance.collection('missions').where('ownerID', isEqualTo: widget.ownerID).getDocuments();
    for(var snap in snaphots.documents){
      missionList.add(snap.data);
    }
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
    List missionIDs = widget.missionIDs;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
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
              if(missionList.length != 0){
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

                    return MyMissionView(
                      mission: missionList[index],
                      animation: animation,
                      animationController: animationController,
                      callback: () {
                        getMission(missionList[index], missionIDs[index]);
                      },
                    );
                  },
                );
              }
              else{
                return Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Card(
                    child: Center(
                      child: Container(
                        child: Text(
                            'No missions yet'
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class MyMissionView extends StatelessWidget {
  const MyMissionView(
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

  Image getImage(){
    Image img;
    img = Image.asset('assets/images/blog_placeholder.png', fit: BoxFit.cover,);
    if(mission['article'] != null){
      for(var block in mission['article']['blocks']){
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
                print('tap');
                callback();
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
                                  color: AppTheme.white,
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
                                                mission['name'].length > 15 ? mission['name'].substring(0,12)+'...' : mission['name'],
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, bottom: 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                mission['username'],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  letterSpacing: 0.27,
                                                  color: AppTheme.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(6),
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

