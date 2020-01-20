import 'package:flutter/material.dart';

class MissionDescription extends StatelessWidget {
  MissionDescription(this.description);
  final String description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mission Description',
          style: textTheme.subhead.copyWith(fontSize: 18.0),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: textTheme.body1.copyWith(
            color: Colors.black45,
            fontSize: 16.0,
          ),
          // TODO Expand 'more' button
        )
      ],
    );
  }
}