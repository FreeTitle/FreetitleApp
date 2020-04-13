import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';
import 'package:freetitle/model/util.dart';
import 'package:freetitle/views/chat/chat.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({Key key,
    this.otherAvatar,
    this.otherUsername,
    this.otherUserID,
    this.sharedBlogID,
    this.sharedMissionID,
  }) : super(key: key);
  final String otherAvatar;
  final String otherUsername;
  final String otherUserID;
  final String sharedBlogID;
  final String sharedMissionID;

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
                launchChat(context, userID, widget.otherUserID, widget.otherUsername, sharedBlogID: widget.sharedBlogID, sharedMissionID: widget.sharedMissionID);
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