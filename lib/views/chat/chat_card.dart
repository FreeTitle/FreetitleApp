import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String userName;
  String latestMessage = 'text';
  String latestTime;
  List messageList = List();

  Future<bool>getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    await Firestore.instance.collection('users').document(widget.otherUserID).get().then((snap) => {
      if(snap != null){
        avatar = snap.data['avatarUrl'],
        userName = snap.data['displayName'],
      }
    });

    await Firestore.instance.collection('chat').document(widget.chatID)
        .collection('messages').orderBy('createdAt', descending: true)
        .getDocuments().then((snap) => {
       if(snap.documents.isNotEmpty){
         latestMessage = snap.documents[0].data['text'],
         snap.documents.forEach((m) => {
           messageList.add(m.data),
         }),
       }
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: InkWell(
              onTap: () {
                Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => Chat(chatID: widget.chatID,),
                    )
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Image.network(avatar, fit: BoxFit.fill,),
                    SizedBox(width: 10,),
                    Text(latestMessage),
                  ],
                ),
              ),
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