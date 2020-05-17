import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/chat/chat.dart';

class ChatCard extends StatelessWidget {
  const ChatCard(
      {Key key,
        @required this.avatar,
        @required this.username,
        @required this.latestTime,
        @required this.latestMessage,
        @required this.chatID,
        this.stream,
        this.unreadNum,
        this.indexState,
      }) : assert(chatID != null), super(key: key);
  final String chatID;
  final int unreadNum;
  final String avatar;
  final String username;
  final String latestMessage;
  final int latestTime;
  final indexState;
  final Stream<Map> stream;


  Widget buildTime(context){
    if(latestTime != null){
      var time = DateTime.fromMillisecondsSinceEpoch(latestTime);
      if(DateTime.now().day == time.day){
        String minute = time.minute < 10 ? '0' + time.minute.toString() : time.minute.toString();
        return Text(time.hour.toString()+':'+ minute, style: Theme.of(context).textTheme.bodyText1);
      }
      else if (DateTime.now().day - time.day == 1){
        return Text('昨天', style: Theme.of(context).textTheme.bodyText1);
      }
      else{
        return Text(time.month.toString() + '-' + time.day.toString(), style: Theme.of(context).textTheme.bodyText1);
      }
    }
    else{
      return Text('Future');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        width: MediaQuery.of(context).size.width,
//        color: AppTheme.nearlyWhite,
        height: 100,
        child: InkWell(
          onTap: () {
            Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => Chat(chatID: chatID, otherUsername: username, indexState: indexState, stream: stream,),
                )
            );
          },
          child: Card(
            color: Theme.of(context).primaryColorDark,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(80.0)),
                        child: Image.network(avatar, fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(username, style: Theme.of(context).textTheme.bodyText1,),
                      SizedBox(height: 10,),
                      Text(latestMessage.length > 19 ? latestMessage.substring(0, 18) + '...' : latestMessage, style: TextStyle(fontWeight: FontWeight.w200),),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: <Widget>[
                      buildTime(context),
                      unreadNum != null && unreadNum != 0 ? Badge(
                        badgeContent: Text(unreadNum.toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
                        toAnimate: false,
                      ) : SizedBox(),
                    ],
                  ),
                  SizedBox(width: 20,)
                ],
              ),
            ),
          ),
        )
    );
  }
}