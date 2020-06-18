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
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freetitle/views/my_view/team_management.dart';

class RemoveMemberPage extends StatefulWidget {
  const RemoveMemberPage({
    Key key,
    this.userID,
    this.member,
    this.displayNames,
    this.avatarUrls,
  }) : super(key: key);

  final String userID;
  final List member;
  final List<String> displayNames;
  final List<String> avatarUrls;

  _RemoveMemberPage createState() => _RemoveMemberPage();
}

class _RemoveMemberPage extends State<RemoveMemberPage> {
  String isToggled;

  Algolia algolia = AlgoliaSearch.algolia;
  SharedPreferences sharedPref;
  List<bool> contactList = [];
  List<String> userSelected = [];
  Future<bool> _getPlaceHolder;

  @override
  void initState() {
    _getPlaceHolder = getPlaceHolder();

    super.initState();
  }

  Future<bool> getPlaceHolder() async {
    for (var index = 0; index <= widget.member.length; index++) {
      contactList.add(true);
    }

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
    var member = widget.member;
    return Scaffold(
        appBar: AppBar(
          title: Text('删除成员'),
          actions: <Widget>[
            Container(
              width: 90,
              padding: EdgeInsets.only(right: 20, bottom: 8, top: 13),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    userSelected.forEach((element) {
                      HttpsCallable addMemberToGroup = CloudFunctions.instance
                          .getHttpsCallable(functionName: 'addMemberToGroup');
                      dynamic resp = addMemberToGroup
                          .call(<String, dynamic>{
                            'groupID': widget.userID,
                            'users': [
                              {"uid": element, "role": 'member'}
                            ],
                          })
                          .then((value) => print("function called"))
                          .catchError((err) {
                            print('Got error $err');
                          });
                    });
                    setState(() {
                      userSelected = [];
                    });
                  },
                  backgroundColor:
                      userSelected.length == 0 ? Colors.white : Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      side: userSelected.length == 0
                          ? BorderSide(color: Colors.grey, width: 1.2)
                          : BorderSide(color: Colors.transparent, width: 1.0)),
                  label: Text('确认(' + userSelected.length.toString() + ')',
                      style: TextStyle(
                          color: userSelected.length == 0
                              ? Colors.grey
                              : Colors.white))),
            )
          ],
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
                    hintText: 'Remove by user name',
                    placeHolder: ListView.builder(
                      itemCount: member.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        print(contactList);
                        print(member);
                        print(widget.displayNames);
                        return Expanded(
                            child: Row(children: <Widget>[
                          Container(
                              width: 30,
                              height: 30,
                              child: FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    contactList[index] = !contactList[index];
                                    contactList[index]
                                        ? userSelected.remove(member[index])
                                        : userSelected.add(member[index]);
                                  });
                                },
                                child: Icon(Icons.done,
                                    color: contactList[index]
                                        ? Colors.transparent
                                        : Colors.white),
                                backgroundColor: contactList[index]
                                    ? Colors.transparent
                                    : Colors.green,
                                elevation: 0.0,
                                heroTag: null,
                                shape: CircleBorder(
                                    side: contactList[index]
                                        ? BorderSide(
                                            color: Colors.grey, width: 1.0)
                                        : BorderSide(
                                            color: Colors.green, width: 1.0)),
                              )),
                          Expanded(
                              child: ContactCard(
                            otherAvatar: widget.avatarUrls[index],
                            otherUserID: member[index],
                            otherUsername: widget.displayNames[index],
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
                            width: 30,
                            height: 30,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  result._check = !result._check;
                                  result._check
                                      ? userSelected.remove(result.uid)
                                      : userSelected.add(result.uid);
                                });
                              },
                              child: Icon(Icons.done,
                                  color: result._check
                                      ? Colors.transparent
                                      : Colors.white),
                              backgroundColor: result._check
                                  ? Colors.transparent
                                  : Colors.green,
                              elevation: 0.0,
                              shape: CircleBorder(
                                  side: result._check
                                      ? BorderSide(
                                          color: Colors.grey, width: 1.0)
                                      : BorderSide(
                                          color: Colors.green, width: 1.0)),
                              heroTag: null,
                            )),
                        Expanded(
                            child: ContactCard(
                          otherAvatar: result.avatarUrl,
                          otherUsername: result.name,
                          otherUserID: result.uid,
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
