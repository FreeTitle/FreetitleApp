import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freetitle/app_theme.dart';

class LinkTextSpan extends TextSpan {

  LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: TapGestureRecognizer()..onTap = () {
        launch(url, forceSafariVC: false);
      }
  );
}

class PlaceHolderCard extends StatelessWidget {

  const PlaceHolderCard(
  {Key key,
    this.text,
    this.height,
  }) : super(key: key);

  final String text;
  final height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:8, left: 24, right: 24),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            color: AppTheme.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          height: height,
          child: Center(
            child: Container(
              child: Text(
                  text
              ),
            ),
          ),
        ),
    );
  }
}

List<TextSpan> processText(blockText){
  List<String> blockStrings = blockText.split('<');
  List<TextSpan> textLists = List();
  for(String blockString in blockStrings){
    if(blockString.contains('href=')){
      int startURL = blockString.indexOf('href=')+6;
      int endUrl = blockString.indexOf('">');
      String url = blockString.substring(startURL, endUrl);
      String link = blockString.substring(endUrl+2);
      textLists.add( LinkTextSpan(
        style: AppTheme.link,
        url: url,
        text: ' ' + link,
      ),);
    }
    else if (blockString.contains('i>') && !blockString.contains(('/'))){
      final italicStart = blockString.indexOf('i>')+2;
      textLists.add(TextSpan(
        style: AppTheme.body1Italic,
        text: ' ' + blockString.substring(italicStart),
      ));
    }
    else if (blockString.contains('b>') && !blockString.contains('/')){
      final boldStart = blockString.indexOf('b>')+2;
      textLists.add(TextSpan(
          style: AppTheme.body1Bold,
          text: ' ' + blockString.substring(boldStart)
      ));
    }
    else{
      if(blockString.startsWith('/')){
        blockString = blockString.substring(3);
      }
      textLists.add(TextSpan(
        style: AppTheme.body1,
        text: blockString,
      ),);
    }
  }

  return textLists;
}

List<String> getCommentIDs(data){
  List<String> commentIDs = new List();
  if (data['comments'] != null){
    for(String commentID in data['comments']){
      commentIDs.add(commentID);
    }
  }
  return commentIDs;
}

class PlatformViewVerticalGestureRecognizer
    extends VerticalDragGestureRecognizer {
  PlatformViewVerticalGestureRecognizer({PointerDeviceKind kind})
      : super(kind: kind);

  Offset _dragDistance = Offset.zero;

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
  }

  @override
  void handleEvent(PointerEvent event) {
    _dragDistance = _dragDistance + event.delta;
    if (event is PointerMoveEvent) {
      final double dy = _dragDistance.dy.abs();
      final double dx = _dragDistance.dx.abs();

      if (dy > dx && dy > kTouchSlop) {
        // vertical drag - accept
        resolve(GestureDisposition.accepted);
        _dragDistance = Offset.zero;
      } else if (dx > kTouchSlop && dx > dy) {
        // horizontal drag - stop tracking
        stopTrackingPointer(event.pointer);
        _dragDistance = Offset.zero;
      }
    }
  }

  @override
  String get debugDescription => 'horizontal drag (platform view)';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}