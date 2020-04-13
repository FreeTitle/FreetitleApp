import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/chat/chat.dart';

class ChatCard extends StatefulWidget {
  const ChatCard(
      {Key key,
        this.chatID,
        this.otherUserID,
      }) : super(key: key);
  final String chatID;
  final String otherUserID;

  _ChatCard createState() => _ChatCard();
}

class _ChatCard extends State<ChatCard>{

  String avatar;
  String username;
  String latestMessage = 'text';
  int latestTime;
  List messageList = List();

  Future<bool>getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    await Firestore.instance.collection('users').document(widget.otherUserID).get().then((snap) => {
      if(snap != null){
        avatar = snap.data['avatarUrl'],
        username = snap.data['displayName'],
      }
    });

    await Firestore.instance.collection('chat').document(widget.chatID)
        .collection('messages').orderBy('createdAt', descending: true)
        .getDocuments().then((snap) {
       if(snap.documents.isNotEmpty){
         latestMessage = snap.documents[0].data['text'];
         latestTime = snap.documents[0].data['createdAt'];
         if(snap.documents[0].data['image'] != null)
           latestMessage = '[图片]';
         if(latestMessage.startsWith('shareblogid='))
           latestMessage = '[Blog]';
         if(latestMessage.startsWith('sharemissionid='))
           latestMessage = '[Mission]';
         snap.documents.forEach((m) => {
           messageList.add(m.data)
         });
       }
    });

    return true;
  }

  Widget buildTime(){
    if(latestTime != null){
      var time = DateTime.fromMillisecondsSinceEpoch(latestTime);
      var timeDiff = DateTime.now().difference(time);
      if(timeDiff.inDays < 1){
        String minute = time.minute < 10 ? '0' + time.minute.toString() : time.minute.toString();
        return Text(time.hour.toString()+':'+ minute, style: AppTheme.body1);
      }
      else if (timeDiff.inDays > 1 && timeDiff.inDays < 2){
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
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Container(
            width: MediaQuery.of(context).size.width,
            color: AppTheme.nearlyWhite,
            height: 92,
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => ChatView(chatID: widget.chatID, otherUsername: username,),
                        )
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: Image.network(avatar, fit: BoxFit.fill,),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(username, style: AppTheme.body1,),
                            SizedBox(height: 10,),
                            Text(latestMessage, style: TextStyle(fontWeight: FontWeight.w200),),
                          ],
                        ),
                        Spacer(),
                        buildTime(),
                        SizedBox(width: 20,)
                      ],
                    ),
                  ),
                ),
                Divider(color: AppTheme.dark_grey,)
              ],
            )
          );
        }
        else{
          return SizedBox();
        }
      },
    );
  }
}