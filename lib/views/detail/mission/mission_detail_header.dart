import 'package:flutter/material.dart';
import 'package:freetitle/views/detail/mission/arc_banner.dart';
import 'package:freetitle/model/mission_list_data.dart';
import 'package:freetitle/views/detail/mission/poster.dart';

class MissionDetailHeader extends StatelessWidget {
  MissionDetailHeader(this.mission);
  final Mission mission;

  // TODO category label

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: ArcBanner(mission.imagePath, null),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Poster(mission.imagePath),
              SizedBox(width: 16.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(mission.title, style: textTheme.title,),
                    SizedBox(height: 8.0),
                    Text('Location: ')
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}