import 'package:flutter/material.dart';
import 'package:freetitle/views/detail/mission/mission_description.dart';
import 'package:freetitle/views/detail/mission/mission_detail_header.dart';
import 'package:freetitle/views/detail/mission/photo_scroller.dart';
import 'package:freetitle/model/mission_list_data.dart';

class MissionDetailPage extends StatelessWidget {
//  MissionDetailPage(this.mission);
  Mission mission = Mission.categoryMissionList[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  MissionDetailHeader(mission),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top+4,
                        left: 8
                    ),
                    child: SizedBox(
                      width: AppBar().preferredSize.height - 8,
                      height: AppBar().preferredSize.height - 8,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              AppBar().preferredSize.height
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          onTap: (){
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MissionDescription(mission.description),
            ),
            PhotoScroller(mission.photoURLs),
            SizedBox(height: 20.0),
          ],
        )
      ),
    );
  }

}

/*


 */