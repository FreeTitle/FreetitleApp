import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:freetitle/app_theme.dart';
import 'package:algolia/algolia.dart';
import 'package:freetitle/model/algolias_search.dart';
import 'package:freetitle/views/chat/chat_list_view.dart';
import 'package:freetitle/views/chat/contact_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddRemovePage extends StatefulWidget {
  const AddRemovePage({
    Key key,
    this.sharedBlogID,
    this.sharedMissionID,
  }) : super(key: key);

  final String sharedBlogID;
  final String sharedMissionID;

  _AddRemovePage createState() => _AddRemovePage();
}

class _AddRemovePage extends State<AddRemovePage> {
  Algolia algolia = AlgoliaSearch.algolia;
  bool unchecked = true;
  SharedPreferences sharedPref;
  List contactList;

  Future<bool> _getPlaceHolder;

  @override
  void initState() {
    _getPlaceHolder = getPlaceHolder();

    super.initState();
  }

  Future<bool> getPlaceHolder() async {
    await SharedPreferences.getInstance().then((pref) {
      sharedPref = pref;
      List<String> jsonChats;
      jsonChats = sharedPref.getStringList('chatlist');
      contactList = List();

      if (jsonChats != null) {
        jsonChats.forEach((chat) {
          contactList.add(json.decode(chat));
        });
      }
    });
    return true;
  }

  /// searchContact
  ///  Input: String search - text to be searched
  ///  Return: Future<List<ContactSearchResult>> that will be used to build
  ///    contact list
  Future<List<ContactSearchResult>> searchContact(String search) async {
    // Query Algolia to get matched users
    AlgoliaQuery query =
        algolia.instance.instance.index('users').search(search);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List userIDs = List();
    snap.hits.forEach((h) {
      userIDs.add(h.objectID);
    });

    List users = List();

    for (var uid in userIDs) {
      await Firestore.instance
          .collection('users')
          .document(uid)
          .get()
          .then((snap) {
        if (snap.data.isNotEmpty) {
          users.add([snap.data['avatarUrl'], snap.data['displayName']]);
        }
      });
    }

    return List.generate(users.length, (int index) {
      return ContactSearchResult(
          users[index][0], users[index][1], userIDs[index], true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
//        brightness: Brightness.dark,
//        backgroundColor: AppTheme.appbarColor,
          title: Text('添加成员'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder<bool>(
          future: _getPlaceHolder,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SearchBar<ContactSearchResult>(
                    onSearch: searchContact,
                    hintText: 'Search by user name',
                    placeHolder: ListView.builder(
                      itemCount: contactList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Expanded(
                            child: Row(children: <Widget>[
                          Container(
                              width: 40,
                              height: 40,
                              child: FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    unchecked = !unchecked;
                                  });
                                },
                                child: Icon(Icons.done,
                                    color: unchecked
                                        ? Colors.transparent
                                        : Colors.white),
                                backgroundColor:
                                    unchecked ? Colors.white : Colors.green,
                                elevation: 0.0,
                                heroTag: null,
                              )),
                          Expanded(
                              child: ContactCard(
                            otherAvatar: contactList[index]['avatar'],
                            otherUserID: contactList[index]['otherUserID'],
                            otherUsername: contactList[index]['displayName'],
                            sharedBlogID: widget.sharedBlogID,
                            sharedMissionID: widget.sharedMissionID,
                          )),
                        ]));
                      },
                    ),
                    emptyWidget: Center(
                      child: Text('未找到用户'),
                    ),
                    onItemFound: (ContactSearchResult result, int index) {
                      return Expanded(
                          child: Row(children: <Widget>[
                        Container(
                            width: 40,
                            height: 40,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  result._check = !result._check;
                                });
                              },
                              child: Icon(Icons.done,
                                  color: result._check
                                      ? Colors.transparent
                                      : Colors.white),
                              backgroundColor:
                                  result._check ? Colors.white : Colors.green,
                              elevation: 0.0,
                              heroTag: null,
                            )),
                        Expanded(
                            child: ContactCard(
                          otherAvatar: result.avatarUrl,
                          otherUsername: result.name,
                          otherUserID: result.uid,
                          sharedBlogID: widget.sharedBlogID,
                          sharedMissionID: widget.sharedMissionID,
                        ))
                      ]));
                    },
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('搜索用户'),
              );
            }
          },
        ));
  }
}

class ContactSearchResult {
  String avatarUrl;
  String name;
  String uid;
  bool _check;
  ContactSearchResult(this.avatarUrl, this.name, this.uid, this._check);
}
