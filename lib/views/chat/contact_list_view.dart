import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:algolia/algolia.dart';
import 'package:freetitle/model/algolias_search.dart';
import 'package:freetitle/views/chat/contact_card.dart';

class ContactListView extends StatefulWidget{

  const ContactListView(
  {Key key,
    this.sharedBlogID,
    this.sharedMissionID,
  }) : super(key: key);

  final String sharedBlogID;
  final String sharedMissionID;

  _ContactListView createState() => _ContactListView();
}

class _ContactListView extends State<ContactListView>{

  Algolia algolia = AlgoliaSearch.algolia;

  /// searchContact
  ///  Input: String search - text to be searched
  ///  Return: Future<List<ContactSearchResult>> that will be used to build
  ///    contact list
  Future<List<ContactSearchResult>> searchContact(String search) async {
    await Future.delayed(Duration(seconds: 1));
    // Query Algolia to get matched users
    AlgoliaQuery query = algolia.instance.instance.index('users').search(search);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List userIDs = List();
    snap.hits.forEach((h) => {
      userIDs.add(h.objectID),
    });

    List users = List();
    
    for(var uid in userIDs){
      await Firestore.instance.collection('users').document(uid).get().then((snap) => {
        if(snap.data.isNotEmpty) {
          users.add([snap.data['avatarUrl'], snap.data['displayName']]),
        }
      });
    }

    return List.generate(users.length, (int index) {
      return ContactSearchResult(users[index][0], users[index][1], userIDs[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: AppTheme.appbarColor,
        title: Text('搜索用户', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: SearchBar<ContactSearchResult>(
            onSearch: searchContact,
            hintText: '搜索用户',
            placeHolder: Center(
              child: Text('Search Contacts'),
            ),
            emptyWidget: Center(
              child: Text('未找到用户'),
            ),
            onItemFound: (ContactSearchResult result, int index){
              return ContactCard(otherAvatar: result.avatarUrl, otherUsername: result.name, otherUserID: result.uid, sharedBlogID: widget.sharedBlogID, sharedMissionID: widget.sharedMissionID,);
            },
          ),
        ),
      ),
    );
  }
}


class ContactSearchResult {
  String avatarUrl;
  String name;
  String uid;
  ContactSearchResult(this.avatarUrl, this.name, this.uid);
}