import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/views/settings/settings.dart';

import 'my_profile.dart';
import 'team_group.dart';

import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/main.dart';

class MyView extends StatefulWidget {
  MyViewState createState() => MyViewState();
}

class MyViewState extends State<MyView> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: '基本信息'),
    Tab(text: '成员管理'),
  ];
  var userType = "团队";
  List userName = [
    "AH",
    "MC",
    "KD",
    "AL",
    "TY",
    "DT",
    "FC",
    "QA",
    "DK",
    "GG",
    "PO",
    "AH",
    "MC",
    "KD",
    "AL",
    "AH",
    "MC",
  ];
  List<Widget> buildAvatarList(userName) {
    List<Widget> avatarList = List();
    for (var i in userName) {
      avatarList.add(Column(
        children: <Widget>[
          Expanded(
            child: FittedBox(
              fit: BoxFit.fill, // otherwise the logo will be tiny
              child: CircleAvatar(
                backgroundColor: Colors.orange[100],
                child: Text(i),
              ),
            ),
          ),
          Text(i,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.normal,
              )),
        ],
      ));
    }
    avatarList.add(Column(
      children: <Widget>[
        Expanded(
          child: FittedBox(
            fit: BoxFit.fill, // otherwise the logo will be tiny
            child: new Material(
              type: MaterialType.transparency,
              child: DottedBorder(
                borderType: BorderType.Circle,
                radius: Radius.circular(15),
                strokeWidth: 3,
                dashPattern: [10, 8],
                color: Theme.of(context).highlightColor, 
                child: IconButton(
                  iconSize: 50,
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
        Text("Add",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.normal,
            )),
      ],
    ));

    avatarList.add(Column(
      children: <Widget>[
        Expanded(
          child: FittedBox(
            fit: BoxFit.fill, // otherwise the logo will be tiny
            child: new Material(
              type: MaterialType.transparency,
              child: DottedBorder(
                borderType: BorderType.Circle,
                radius: Radius.circular(15),
                strokeWidth: 3,
                dashPattern: [10, 8],
                color: Theme.of(context).highlightColor,
                child: IconButton(
                  iconSize: 50,
                  color: Theme.of(context).highlightColor,
                  highlightColor: Colors.grey,
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    print("remove clicked");
                  },
                ),
              ),
            ),
          ),
        ),
        Text("Remove",
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.normal,
            )),
      ],
    ));
    return avatarList;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var avatarList = buildAvatarList(userName);
    var factor = 13.0;
    if (screenSize.height < 800) {
      factor = 10.5;
    }
    return DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            centerTitle: true,
            title: Text(userType),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                  ),
                  onPressed: () {
                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
            bottom: TabBar(
              labelColor: AppTheme.primary,
              unselectedLabelColor: Theme.of(context).accentColor,
              indicatorColor: AppTheme.primary,
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              GetMyProfile(),
              Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left:25, right: 25, top: 25),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Text("全部成员",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold))),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                        semanticLabel: "Number",
                                      ),
                                      Text(
                                        userName.length.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Flexible(
                              child: SizedBox(
                                child: GridView.count(
                                  physics: new NeverScrollableScrollPhysics(),
                                  crossAxisCount: 5,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 3,
                                  children: avatarList,
                                ),
                              ),
                            )
                          ],
                        ),
                        height: 62 +
                            (avatarList.length / 5).ceil().toDouble() *
                                (screenSize.height / factor),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.grey.withOpacity(0.2),
                                offset: Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                    height: 300,
                    width: screenSize.width,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SizedBox(
                        child: GridView.count(
                          physics: new NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 50,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.1,
                          children: [
                            MyGroup(
                              groupName: "摄影组",
                              groupMember: [
                                "AH",
                                "MC",
                                "KD",
                                "AL",
                                "TY",
                              ],
                              groupNotes: "无",
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ));
  }
}
