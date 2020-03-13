import 'package:freetitle/app_theme.dart';
import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
//  final AnimationController animationController;
//  final Animation animation;

  const TitleView(
      {Key key,
        this.titleTxt: "",
        this.subTxt: ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 27, right: 27),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                titleTxt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: AppTheme.lightText,
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onTap: () {
                
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      subTxt,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        color: AppTheme.nearlyBlue,
                      ),
                    ),
//                    SizedBox(
//                      height: 38,
//                      width: 26,
//                      child: Icon(
//                        Icons.arrow_forward,
//                        color: AppTheme.darkText,
//                        size: 18,
//                      ),
//                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
