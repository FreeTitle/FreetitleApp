import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/post/comment/comment.dart';

class BlogPostDetail extends StatefulWidget {
  BlogPostDetailState createState() => BlogPostDetailState();
}

class BlogPostDetailState extends State<BlogPostDetail> {
  var pressAttention = false;
  var pressAttention2 = false;
  Color iconColor = Colors.grey;
  int liked = 322;
  int one = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Container(
          padding: EdgeInsets.only(
            right: 20,
          ),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('assets/user_pic.png'),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Amanda Liu',
                    style: GoogleFonts.galdeano(
                      textStyle: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(
                              fontSize: 16,
                            ),
                          ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Freelance Photographer',
                    style: GoogleFonts.galdeano(
                      textStyle: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(
                              fontSize: 13,
                            ),
                          ),
                    ),
                  )
                ],
              ),
              Spacer(),
              Container(
                height: 30,
                width: 91,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      setState(() => pressAttention = !pressAttention);
                      print("Follow pressed");
                    },
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          pressAttention
                              ? SizedBox(width: 0)
                              : Icon(Icons.add,
                                  color: Color(0xff77E2C4), size: 15),
                          pressAttention
                              ? SizedBox(width: 0)
                              : SizedBox(width: 2),
                          Text(
                            pressAttention ? "FOLLOWED" : "FOLLOW",
                            style: GoogleFonts.dosis(
                              textStyle:
                                  Theme.of(context).textTheme.bodyText1.merge(
                                        TextStyle(
                                          fontSize: 15,
                                          color: pressAttention
                                              ? Color(0xff707070)
                                              : Color(0xff77E2C4),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(
                      color: pressAttention
                          ? Color(0xff707070)
                          : Color(0xff77E2C4),
                      width: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(width: 20, height: 20),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20, height: 20),
                      Container(
                        width: 374,
                        height: 211,
                        child: Image.asset('assets/top_pic.png'),
                      ),
                    ],
                  ),
                  SizedBox(width: 20, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 20, height: 20),
                      Text(
                        'Tags',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText2.merge(
                                    TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        'Film',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        child: Image.asset('assets/shape.png'),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Visual art',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        child: Image.asset('assets/shape.png'),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Movie',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        child: Image.asset('assets/shape.png'),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Avant-garde',
                        style: GoogleFonts.galdeano(
                          textStyle:
                              Theme.of(context).textTheme.bodyText1.merge(
                                    TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff8199e5),
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20),
                      Container(
                        width: 377,
                        height: 49,
                        child: Text(
                          'Un Chien Andalou is a 1929 Franco-Spanish silent surrealist short film',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.galdeano(
                            textStyle:
                                Theme.of(context).textTheme.bodyText2.merge(
                                      TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20),
                      Container(
                        width: 12,
                        height: 12,
                        child: Image.asset('assets/clock.png'),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 80,
                        height: 14,
                        child: Text(
                          'June 26, 2020',
                          style: GoogleFonts.galdeano(
                            textStyle:
                                Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20),
                      Container(
                        width: 373,
                        height: 270,
                        child: Text(
                          'Un Chien Andalou (French pronunciation: ​[œ̃ ʃjɛ̃ ɑ̃dalu], An Andalusian Dog) is a 1929 Franco-Spanish silent surrealist short film by Spanish director Luis Buñuel and artist Salvador Dalí. It was Buñuel’s first film and was initially released in 1929 with a limited showing at Studio des Ursulines in Paris, but became popular and ran for eight months.[1] Un Chien Andalou has no plot in the conventional sense of the word. The chronology of the film is disjointed, jumping from the initial “once upon a time” to “eight years later” without the events or characters changing. It uses dream logic in narrative flow that can be described in terms of then-popular Freudian free association, presenting a series of tenuously related scenes.',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.galdeano(
                            textStyle:
                                Theme.of(context).textTheme.bodyText1.merge(
                                      TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff565254),
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 373,
                    height: 276,
                    child: Image.asset('assets/Image2.png'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 373,
                    height: 514,
                    child: Text(
                      'The screenplay of the film “Andalusian Dog” is based on two dreams of its creators Luis Bunuel and Salvador Dali. The idea for the film began when Buñuel was working as an assistant director for Jean Epstein in France. Buñuel told Dalí at a restaurant one day about a dream in which a cloud sliced the moon in half “like a razor blade slicing through an eye”. Dalí responded that he had dreamed about a hand crawling with ants. Excitedly, Buñuel declared: “There’s the film, let’s go and make it.”[2] They were fascinated by what the psyche could create, and decided to write a script based on the concept of suppressed human emotions.[2] The title of the film is a hidden reminiscence from the Spanish saying: “the Andalusian dog howls-someone has died!” The screenplay was written in a few days. According to Bunuel, they adhered to a simple rule: “Do not dwell on what required purely rational, psychological or cultural explanations. Open the way to the irrational. It was accepted only that which struck us, regardless of the meaning … We did not have a single argument. A week of impeccable understanding. One, say, said: “A man drags double bass.” “No,” the other objected. And the objection was immediately accepted as completely justified. But when the proposal of one liked the other, it seemed to us magnificent, indisputable and immediately introduced into the script.”[3]',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.galdeano(
                        textStyle: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(
                                fontSize: 16,
                                color: Color(0xff565254),
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 70,
            width: 414,
            padding: EdgeInsets.only(bottom: 20),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Container(
                  height: 35,
                  width: 90,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () {
                        setState(() => pressAttention2 = !pressAttention2);
                        print("Project save pressed");
                      },
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          children: <Widget>[
                            Icon(pressAttention2 ? Icons.done : Icons.favorite,
                                color: pressAttention2
                                    ? Colors.blue[300]
                                    : Colors.white,
                                size: 15),
                            SizedBox(width: pressAttention2 ? 3 : 10),
                            Text(
                              pressAttention2 ? "SAVED" : "SAVE",
                              style: GoogleFonts.galdeano(
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize: 17,
                                            color: pressAttention2
                                                ? Colors.blue[300]
                                                : Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: pressAttention2 ? Colors.white : Colors.blue[300],
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Colors.blue[300], width: 1.5),
                  ),
                ),
                SizedBox(width: 170),
                CommentButtonWidget(),
              ],
            ),
          ),
        ],
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}

class CommentButtonWidget extends StatefulWidget {
  CommentButtonWidgetState createState() => CommentButtonWidgetState();
}

class CommentButtonWidgetState extends State<CommentButtonWidget> {
  Color iconColor = Colors.grey;
  int liked = 322;
  int one = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Icon(
                  Icons.share,
                  color: Colors.grey,
                  size: 20,
                ),
                Text(
                  '107',
                  style: GoogleFonts.galdeano(
                    textStyle: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 18),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 1.5),
                Container(
                  height: 20,
                  width: 20,
                  child: InkWell(
                    child: Icon(Icons.comment, color: Colors.grey, size: 20),
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: 820,
                            color: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                              child: Comment(),
                            ),
                            // child: Center(
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: <Widget>[
                            //       const Text('BottomSheet'),
                            //       RaisedButton(
                            //         child: const Text('Close BottomSheet'),
                            //         onPressed: () => Navigator.pop(context),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Text(
                  '37',
                  style: GoogleFonts.galdeano(
                    textStyle: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 18),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 1.5),
                Container(
                  width: 20,
                  height: 20,
                  child: InkWell(
                    child: Icon(
                      Icons.thumb_up,
                      color: iconColor,
                      size: 20,
                    ),
                    onTap: () {
                      setState(() {
                        if (iconColor == Colors.grey) {
                          iconColor = Color(0xff8199E5);
                          liked += one;
                        } else {
                          iconColor = Colors.grey;
                          liked -= one;
                        }
                      });
                    },
                  ),
                ),
                Text(
                  '$liked',
                  style: GoogleFonts.galdeano(
                    textStyle: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                            fontSize: 12,
                            color: (iconColor == Colors.grey)
                                ? Colors.grey
                                : Color(0xff8199E5),
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
