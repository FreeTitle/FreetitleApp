import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SubGroupContent extends StatefulWidget {
  const SubGroupContent({
    this.groupMember,
    this.groupName,
  });

  SubGroupContentState createState() => SubGroupContentState();
  final groupMember;
  final groupName;
}


class SubGroupContentState extends State<SubGroupContent> {

  List<String> avatarUrls;
  List<String> displayNames;

  TextEditingController _controller;

  Future<bool> _getUser;

  void initState() {
    super.initState();
    _controller = TextEditingController();
    _getUser = getUser();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> getUser() async {
    displayNames = List();
    avatarUrls = List();
    final userIDs = widget.groupMember;
    for (final userID in userIDs) {
      await Firestore.instance
          .collection('users')
          .document(userID)
          .get()
          .then((snap) {
        if (snap.data != null) {
          displayNames.add(snap.data['displayName']);
          avatarUrls.add(snap.data['avatarUrl']);
        }
      });
    }
    return true;
  }


  List<Widget> userList;
  List<Widget> buildUserList() {
    userList = List();
    for (int i = 0; i < displayNames.length; i++) {
      print(i);
      print(displayNames[i]);
      userList.add(
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(80.0)),
                      child: Image.network(avatarUrls[i], fit: BoxFit.cover,),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(displayNames[i].length >= 18
                  ? displayNames[i].substring(0, 18) + '...'
                  : displayNames[i])
                ],
              ),
            ),
            SizedBox(height: 2),
            Divider(color: Theme.of(context).accentColor),
          ],
        ),
      );
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text("小组备注",
                  style: Theme.of(context).textTheme.bodyText2
              ),
              margin: EdgeInsets.only(top: 10),
            ),
            TextField(
                controller: _controller,
                maxLength: 50,
                buildCounter: (_, {currentLength, maxLength, isFocused}) {
                  var remaining = maxLength - currentLength;
                  return Text('还可以输入 $remaining 个字',
                      semanticsLabel: 'character count',
                      style: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                              fontSize: 15,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.normal)));
                },
                onEditingComplete: null,
                onSubmitted: (String value) async {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thanks!'),
                        content: Text('You typed "$value".'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                decoration: new InputDecoration(
                    hintText: "Enter Something",
                    contentPadding: const EdgeInsets.all(20.0),
                    hintStyle: TextStyle(
                      color: Theme.of(context).accentColor.withOpacity(0.8),
                      fontWeight: FontWeight.w300,
                    )
                )
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text("组内成员(4)",
                  style: Theme.of(context).textTheme.bodyText2
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(color: Colors.black),
            Container(
              height: 43,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 2),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 43,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fitHeight, // otherwise the logo will be tiny
                      child: new Material(
                        type: MaterialType.transparency,
                        child: DottedBorder(
                          borderType: BorderType.Circle,
                          radius: Radius.circular(15),
                          strokeWidth: 3,
                          dashPattern: [10, 8],
                          color: Theme.of(context).highlightColor,
                          child: IconButton(
                            iconSize: 45,
                            color: Theme.of(context).highlightColor,
                            highlightColor: Colors.grey,
                            icon: Icon(Icons.add),
                            onPressed: () {
                              print("add clicked");
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text('添加成员'),
                ],
              ),
            ),
            Divider(color: Theme.of(context).accentColor),
            FutureBuilder<bool>(
              future: _getUser,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return Column(
                    children: buildUserList(),
                  );
                }
                else{
                  return SizedBox();
                }
              },
            ),
            SizedBox(height: 100),
            Container(
              height: 40,
              width: 230,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    print("remove group clicked");
                  },
                  highlightColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("删除此分组",
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
