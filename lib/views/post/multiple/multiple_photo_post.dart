import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'CTflow.dart';

class MultiplePhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Un Chien Andalou has no plot in the conventional sense of the word. The chronology of the film is disjointed, jumping from the initial at…. Read more ',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey
            )
          )
        ),
        SizedBox(height: 10,),
        Container(
          child: getFlowContainer(6)
        ),
      ],
    );
  }

  Widget getFlowContainer(int count) {
    List<Container> list = [];
    for (var i = 0; i < count; i++) {
      list.add(
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/placeholders//blogpost_.png',
              fit: BoxFit.fill
            )
          )
        )
      );
    }
    return CLFlow(
      count: count,
      children: list,
    );
  }
}
