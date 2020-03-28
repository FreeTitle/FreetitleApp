import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/chat/chat_card.dart';

class ChatListView extends StatefulWidget{
  _ChatListView createState() => _ChatListView();
}

class _ChatListView extends State<ChatListView>{
  String userID;
  UserRepository _userRepository;
  String otherUserID;

  @override
  void initState(){
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap) => {
      if(snap != null)
        userID = snap.uid,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('私信', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black,),
            onPressed: () {

            },
          )
        ],
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('chat').where('users', arrayContains: userID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return new Center(
                child: Text('Loading'),
              );
            default:
              if(snapshot.hasData){
                List messageList = List();
                List messageIDs = List();
                snapshot.data.documents.forEach((m) => {
                  messageIDs.add(m.documentID),
                  messageList.add(m.data),
                  for (var id in m.data['users']){
                    if(id != userID){
                      otherUserID = id,
                    }
                  }
                });
                return ListView.builder(
                  itemCount: messageIDs.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index){
                    return ChatCard(chatID: messageIDs[index], otherUserID: otherUserID);
                  }
                );
              }
              else{
                return new Text("Something is wrong with firebase");
              }
          }
        },
      )
    );
  }
}