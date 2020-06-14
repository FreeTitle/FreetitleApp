import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:dotted_border/dotted_border.dart';

class GroupContent extends StatefulWidget {
  GroupContentState createState() => GroupContentState();
}

class GroupContentState extends State<GroupContent> {
  var groupName = "摄影组";
  List groupUserName_ = ["UN", "HG", "KK"];

  List<Widget> buildUserList(groupUserName, groupUserURL) {
    List<Widget> userList = List();
    for (int i = 0; i < groupUserName.length; i++) {
      print(i);
      print(groupUserName[i]);
      userList.add(
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    child: Text(groupUserName[i]),
                  ),
                  SizedBox(width: 20),
                  Text(groupUserName[i])
                ],
              ),
            ),
            SizedBox(height: 2),
            Divider(color: Colors.black),
          ],
        ),
      );
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller;
    var screenSize = MediaQuery.of(context).size;

    void initState() {
      super.initState();
      _controller = TextEditingController();
    }

    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text("小组备注",
                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold))),
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
                  contentPadding: const EdgeInsets.all(20.0))),
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text("组内成员(4)",
                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold))),
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
                  child: Expanded(
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
                ),
                SizedBox(width: 20),
                Text('添加成员'),
              ],
            ),
          ),
          Divider(color: Colors.black),
          Column(
            children: buildUserList(groupUserName_, null),
          ),
          SizedBox(height: 200),
          Container(
            height: 40,
            width: 230,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
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
    );
  }
}
