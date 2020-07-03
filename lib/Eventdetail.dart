import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Eventdetail extends StatelessWidget {
  Eventdetail({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f4),
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(0.0, 80.0),
            child:
                // Adobe XD layer: '7e6a1ba0433f4cef9d3…' (shape)
                Container(
              width: 414.0,
              height: 570.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0.0, 634.0),
            child: Container(
              width: 415.0,
              height: 621.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: const Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(49.0, 718.0),
            child: SizedBox(
              width: 317.0,
              height: 67.0,
              child: Text(
                'Nocturnal Wonderland Photography of the year Competition',
                style: TextStyle(
                  fontFamily: 'Kefa',
                  fontSize: 18,
                  color: const Color(0xff2d2a2b),
                  fontWeight: FontWeight.w700,
                  height: 1.3333333333333333,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            width: 414.0,
            height: 80.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1.07, 2.51),
                end: Alignment(1.1, -2.96),
                colors: [
                  const Color(0xff77e2c4),
                  const Color(0xff64bff4),
                  const Color(0xff8199e5)
                ],
                stops: [0.0, 0.507, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x1a8199e5),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(52.0, 33.0),
            child: Container(
              width: 305.0,
              height: 34.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.0),
                color: const Color(0xe6ffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(366.0, 33.0),
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(15.0, 15.0)),
                color: const Color(0xffffffff),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(373.5, 40.5),
            child: SvgPicture.string(
              _svg_wptkl4,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          Transform.translate(
            offset: Offset(57.5, 36.5),
            child:
                // Adobe XD layer: 'Icon feather-search' (group)
                Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(4.5, 4.5),
                  child: SvgPicture.string(
                    _svg_9f8ll3,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(89.0, 42.0),
            child: Text(
              'Search for people, project, art type, etc',
              style: TextStyle(
                fontFamily: 'Gill Sans',
                fontSize: 14,
                color: const Color(0xff7683af),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(49.0, 789.33),
            child: SizedBox(
              width: 341.0,
              height: 136.0,
              child: Text(
                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et.',
                style: TextStyle(
                  fontFamily: 'Gill Sans',
                  fontSize: 12,
                  color: const Color(0xff2d2a2b),
                  height: 1.6666666666666667,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(39.0, 522.33),
            child: Text(
              'We are looking for: ',
              style: TextStyle(
                fontFamily: 'Gill Sans',
                fontSize: 12,
                color: const Color(0xff565254),
                height: 1.6666666666666667,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(103.0, 664.0),
            child: Text(
              'Amanda Liu',
              style: TextStyle(
                fontFamily: 'Gill Sans',
                fontSize: 15,
                color: const Color(0xff2d2a2b),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(195.0, 666.0),
            child: Text(
              'Verified Curator',
              style: TextStyle(
                fontFamily: 'Gill Sans',
                fontSize: 12,
                color: const Color(0xff565254),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Transform.translate(
            offset: Offset(187.0, 672.0),
            child: Container(
              width: 3.0,
              height: 3.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(1.5, 1.5)),
                color: const Color(0xff565254),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(48.0, 662.0),
            child:
                // Adobe XD layer: '_ZYL0278' (shape)
                Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(20.0, 20.0)),
                image: DecorationImage(
                  image: const AssetImage(''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(103.0, 682.0),
            child: Text(
              'From Nocturnal Wonderland',
              style: TextStyle(
                fontFamily: 'Gill Sans',
                fontSize: 12,
                color: const Color(0xffaaaaaa),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_9f8ll3 =
    '<svg viewBox="4.5 4.5 18.0 18.0" ><path transform="translate(0.0, 0.0)" d="M 20.5 12.50000095367432 C 20.5 16.91827964782715 16.91827583312988 20.50000190734863 12.50000095367432 20.50000190734863 C 8.081722259521484 20.50000190734863 4.500001430511475 16.91827964782715 4.5 12.50000190734863 C 4.5 8.081723213195801 8.081723213195801 4.500000476837158 12.50000190734863 4.500001907348633 C 16.91827774047852 4.500001907348633 20.50000190734863 8.081725120544434 20.5 12.50000286102295 Z" fill="none" stroke="#64bff4" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /><path transform="translate(-6.82, -6.82)" d="M 29.32499885559082 29.32499885559082 L 24.97500038146973 24.97500038146973" fill="none" stroke="#64bff4" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" /></svg>';
const String _svg_wptkl4 =
    '<svg viewBox="373.5 40.5 15.0 15.0" ><path transform="matrix(0.0, 1.0, -1.0, 0.0, 381.5, 40.5)" d="M 0 0 L 15 0" fill="none" stroke="#707070" stroke-width="3" stroke-miterlimit="4" stroke-linecap="round" /><path transform="translate(373.5, 48.5)" d="M 0 0 L 15 0" fill="none" stroke="#707070" stroke-width="3" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
