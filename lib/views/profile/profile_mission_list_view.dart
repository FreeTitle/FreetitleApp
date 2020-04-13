import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/mission/mission_detail.dart';
import 'package:freetitle/views/mission/mission_list_view.dart';

class ProfileHorizontalMissionListView extends StatefulWidget {
  const ProfileHorizontalMissionListView(
      {Key key,
        this.ownerID,
        this.missionIDs,
      }) : super(key: key);
  final String ownerID;
  final List missionIDs;
  @override
  _ProfileHorizontalMissionListViewState createState() => _ProfileHorizontalMissionListViewState();
}

class _ProfileHorizontalMissionListViewState extends State<ProfileHorizontalMissionListView>
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

//  Widget noMissionWidget() {
//    return Padding(
//      padding: EdgeInsets.only(left: 24, right: 24),
//      child: Card(
//        child: Center(
//          child: Container(
//            child: Text(
//                'No missions yet'
//            ),
//          ),
//        ),
//      ),
//    );
//  }

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
              return PlaceHolderCard(text: 'No missions yet',);
            }
            else{
              if(missionList.length != 0){
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 24, left: 24),
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
                return PlaceHolderCard(text: 'No missions yet',);
              }
            }
          },
        ),
      ),
    );
  }
}

