import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/post_detail/blog_post_detail.dart';

class BlogPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BlogPostDetail()),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(8.0)),
              ),
              padding: EdgeInsets.only(top: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                      'assets/placeholders//blogpost_.png',
                      fit: BoxFit.fill
                  )
              )
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                  'Un Chien Andalou has no plot in the conventional',
                  style: Theme.of(context).textTheme.bodyText1
              )
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                  'Un Chien Andalou has no plot in the conventional sense of the word. The chronology of the film is disjointed, jumping from the initial atThe chronology of the film is disjointed, jumping from the initial at…. Read more ',
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey
                  )
              )
          ),
        ],
      ),
    );
  }
}
