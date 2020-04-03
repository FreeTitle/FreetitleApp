import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/views/chat/chat.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({Key key,
    this.otherAvatar,
    this.otherUsername,
    this.otherUserID,
    this.sharedBlogID,
  }) : super(key: key);
  final String otherAvatar;
  final String otherUsername;
  final String otherUserID;
  final String sharedBlogID;

  _ContactCard createState() => _ContactCard();
}

class _ContactCard extends State<ContactCard>{

  UserRepository _userRepository;
  String userID;
  @override
  void initState(){
    _userRepository = UserRepository();
    _userRepository.getUser().then((snap) => {
      userID = snap.uid,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: AppTheme.nearlyWhite,
        height: 100,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () async {
                List existingChats = List();
                await Firestore.instance.collection('chat')
                    .where('users', arrayContains: userID)
                    .getDocuments().then((snap) => {
                      if(snap.documents.isNotEmpty){
                        for(var doc in snap.documents){
                          if(doc.data['users'].contains(widget.otherUserID)){
                            existingChats.add(doc),
                          }
                        }
                      }
                });
                if(existingChats.isNotEmpty){
                  assert (existingChats.length == 1);

                  var userRef = await Firestore.instance.collection('users').document(userID).get();
                  String chatID = existingChats[0].documentID;
                  if (userRef.data['chats'].contains(chatID) == false) {
                    await Firestore.instance.collection('users').document(userID).updateData({
                      'chats': FieldValue.arrayUnion([chatID])
                    });
                  }

                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => Chat(chatID: chatID, otherUsername: widget.otherUsername, sharedBlogID: widget.sharedBlogID,),
                    )
                  );
                }
                else{
                  String chatID;
                  await Firestore.instance.runTransaction((transaction) async {
                    var documentRef = Firestore.instance.collection('chat').document();
                    await transaction.set(documentRef, {
                      'users': [
                        userID,
                        widget.otherUserID,
                      ]
                    });
                    chatID = documentRef.documentID;

                    await Firestore.instance.collection('users').document(userID).updateData({
                      'chats': FieldValue.arrayUnion([chatID]),
                    });

                    await Firestore.instance.collection('users').document(widget.otherUserID).updateData({
                      'chats': FieldValue.arrayUnion([chatID]),
                    });
                  });

                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => Chat(chatID: chatID, sharedBlogID: widget.sharedBlogID, otherUsername: widget.otherUsername,),
                      )
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                child: Row(
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
                          child: Image.network(widget.otherAvatar, fit: BoxFit.fill,),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      children: <Widget>[
                        Text(widget.otherUsername),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider(color: AppTheme.dark_grey,)
          ],
        )
    );
  }
}