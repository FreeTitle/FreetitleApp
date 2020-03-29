import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/chat/chat_card.dart';
import 'package:freetitle/views/chat/contact_list_view.dart';

class ChatListView extends StatefulWidget{
  _ChatListView createState() => _ChatListView();
}

class _ChatListView extends State<ChatListView>{
  String userID;
  UserRepository _userRepository;

  List messageIDs = List();
  List otherUserIDs = List();

  @override
  void initState(){
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap) => {
      if(snap != null)
        userID = snap.uid,
    });
    super.initState();
  }

  Future<bool> getChatList() async {
    messageIDs.clear();
    otherUserIDs.clear();
    var possibleChats = await Firestore.instance.collection('chat').where(
        'users', arrayContains: userID).getDocuments();
    if (possibleChats.documents.isNotEmpty) {
      await Firestore.instance.collection('users').document(userID).get().then((snap) => {
        if(snap.data['chats'].isNotEmpty){
          for(var doc in possibleChats.documents){
            if(snap.data['chats'].contains(doc.documentID)){
              messageIDs.add(doc.documentID),
              for(var id in doc.data['users']){
                if(id != userID){
                  otherUserIDs.add(id),
                }
              }
            }
          }
        }
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('私信', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).push(contactListRoute());
            },
          ),
          SizedBox(width: 10,),
        ],
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      body: FutureBuilder(
        future: getChatList(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
                itemCount: messageIDs.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  var chat = ChatCard(chatID: messageIDs[index], otherUserID: otherUserIDs[index]);
                  return Dismissible(
                    key: ObjectKey(chat),
                    onDismissed: (direction) async {
                      await Firestore.instance.collection('users')
                          .document(userID)
                          .updateData({
                        'chats': FieldValue.arrayRemove([messageIDs[index]]),
                      });
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      color: Colors.red,
                      child: Icon(
                        CupertinoIcons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: chat,
                  );
                  //ChatCard(chatID: messageIDs[index], otherUserID: otherUserIDs[index]);
                }
            );
          }
          else{
            return Center(
              child: Text('No chats yet'),
            );
          }
        },
      )
    );
  }
}

Route contactListRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ContactListView(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}