import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/post/common/post_bottom.dart';
import 'package:freetitle/views/post/common/post_title.dart';
import 'package:freetitle/views/post_detail/blog_post_detail.dart';
import 'package:google_fonts/google_fonts.dart';

//class SinglePhotoPost extends StatefulWidget {
//  SinglePhotoPostState createState() => SinglePhotoPostState();
//}

class SinglePhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
//        Navigator.push<dynamic>(
//          context,
//          MaterialPageRoute<dynamic>(
//            builder: (BuildContext context) => BlogPostDetail(),
//          )
//        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "My favorite movie",
            style: GoogleFonts.galdeano(
              textStyle: Theme.of(context).textTheme.bodyText1.merge(
                TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            width: 400,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(13.0)),
              child: Image.asset('assets/placeholders/event.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}

