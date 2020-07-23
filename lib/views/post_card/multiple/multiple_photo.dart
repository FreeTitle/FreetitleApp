import 'package:flutter/material.dart';
import 'package:freetitle/model/post_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'CLflow.dart';

class MultiplePhoto extends StatelessWidget {

  MultiplePhoto({Key key, this.postData}) : super(key: key);

  final PostModel postData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            postData.content,
            style: GoogleFonts.galdeano(
              textStyle: Theme.of(context).textTheme.bodyText1.merge(
                TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Container(
//          height: 200,
          width: 400,
          child: CLFlow(
            count: postData.images.length,
            children: postData.images.map((image) => Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                        image,
                        fit: BoxFit.fill
                    )
                )
            )
            ).toList(),
          ),
        ),
      ],
    );
  }

//  Widget getFlowContainer(List images) {
//    List<Container> list = [];
//    for (var i = 0; i < count; i++) {
//      list.add(
//        Container(
//          child: ClipRRect(
//            borderRadius: BorderRadius.circular(10),
//            child: Image.asset(
//              'assets/placeholders//blogpost_.png',
//              fit: BoxFit.fill
//            )
//          )
//        )
//      );
//    }
//    return CLFlow(
//      count: images.length,
//      children: list,
//    );
//  }
}
