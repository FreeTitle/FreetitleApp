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
        this.unreadNum,
        this.callback,
      }) : assert(chatID != null), super(key: key);
  final String chatID;
//  final String otherUserID;
  final int unreadNum;
  final callback;
  final String avatar;
  final String username;
  final String latestMessage;
  final int latestTime;


  Widget buildTime(){
    if(latestTime != null){
      var time = DateTime.fromMillisecondsSinceEpoch(latestTime);
      if(DateTime.now().day == time.day){
        String minute = time.minute < 10 ? '0' + time.minute.toString() : time.minute.toString();
        return Text(time.hour.toString()+':'+ minute, style: AppTheme.body1);
      }
      else if (DateTime.now().day - time.day == 1){
        return Text('昨天', style: AppTheme.body1,);
      }
      else{
        return Text(time.month.toString() + '-' + time.day.toString(), style: AppTheme.body1);
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
        color: AppTheme.nearlyWhite,
        height: 100,
        child: InkWell(
          onTap: () {
            print(chatID);
            callback(chatID);
            Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => ChatView(chatID: chatID, otherUsername: username,),
                )
            );
          },
          child: Card(
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
                      Text(username, style: AppTheme.body2,),
                      SizedBox(height: 10,),
                      Text(latestMessage.length > 20 ? latestMessage.substring(0, 20) + '...' : latestMessage, style: TextStyle(fontWeight: FontWeight.w200),),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: <Widget>[
                      buildTime(),
                      unreadNum != null && unreadNum != 0 ? Badge(
                        badgeContent: Text(unreadNum.toString(), style: TextStyle(color: Colors.white, fontSize: 12),),
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