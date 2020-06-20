import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:freetitle/views/settings/settings.dart';

import 'my_view.dart';
import 'team_group.dart';

import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/main.dart';


class TeamManagement extends StatefulWidget{
  TeamManagement({
    Key key,
    @required this.userID,
  }) : super(key: key);

  final String userID;

  _TeamManagementState createState() => _TeamManagementState();
}

class _TeamManagementState extends State<TeamManagement> {

  /////----Start of dummy data----///
//  List groupNameList = ["摄影组", "后期组", "外场组"];
//  List groupMemberList = [
//    [
//      "AH",
//      "MC",
//      "KD",
//      "AL",
//      "TY",
//      "DT",
//    ],
//    [
//      "AH",
//      "MC",
//      "KD",
//      "AL",
//      "TY",
//      "DT",
//    ],
//    [
//      "AH",
//      "MC",
//      "KD",
//    ]
//  ];
//  List groupNotesList = [
//    "Purchase equipment before 11/1",
//    "None",
//    "Some other stuffs"
//  ];
  
  Map userData = Map();
  List members = List();

  List<String> displayNames;
  List<String> avatarUrls;

  Future<bool> getUser(userIDs) async {
    displayNames = List();
    avatarUrls = List();
    for(final userID in userIDs){
      await Firestore.instance.collection('users').document(userID).get().then((snap) {
        if(snap.data != null){
          displayNames.add(snap.data['displayName']);
          avatarUrls.add(snap.data['avatarUrl']);
        }
      });
    }
    return true;
  }


  List<Widget> buildAvatarList() {
    List<Widget> avatarList = List();
    for (var i = 0; i < displayNames.length;i++) {
      String displayName = displayNames[i];
      String avatarUrl = avatarUrls[i];

      avatarList.add(
          InkWell(
            onTap: () {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Profile(userID: members[i], isMyProfile: false,)
                )
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(80.0)),
                    child: Image.network(avatarUrl, fit: BoxFit.cover,),
                  ),
                ),
                SizedBox(height: 4,),
                Text(displayName.length >= 7 ? displayName.substring(0, 7) + '...' : displayName,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
          )
      );
    }
    avatarList.add(Column(
      children: <Widget>[
        Container(
                  height: 50,
                  width: 50,
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
        SizedBox(height: 4,),
        Text("Add",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 10,
              fontWeight: FontWeight.normal,
            )),
      ],
    ));

    avatarList.add(Column(
      children: <Widget>[
        Container(
                  height: 50,
                  width: 50,
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
                  iconSize: 45,
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
        SizedBox(height: 4,),
        Text("Remove",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 10,
              fontWeight: FontWeight.normal,
            )),
      ],
    ));
    return avatarList;
  }

  // Builds the list for displaying department group info
  List<Widget> buildGroupList(subGroups) {
    List<Widget> groupList = List();
    for (final subGroup in subGroups) {
      groupList.add(SubGroup(
        groupName: subGroup['name'] != null ? subGroup['name'] : "错误",
        groupMember: subGroup['members'] != null ? subGroup['members'] : [],
        groupNotes: subGroup['note'] != null ? subGroup['note'] : "暂无",
      ));
    }
    groupList.add(
      Container(
        padding: EdgeInsets.only(bottom: 96, top: 5, left: 5, right: 5),
        child: Container(
          height: 10,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {

              },
              highlightColor: Colors.transparent,
              child:
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Text("添加新的分组"),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.0),
                bottomLeft: Radius.circular(7.0),
                bottomRight: Radius.circular(7.0),
                topRight: Radius.circular(7.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.2),
                  offset: Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
        ),
      ),
    );
    return groupList;
  }

  @override
  Widget build(BuildContext context) {
    double factor = 12;
    var screenSize = MediaQuery.of(context).size;
    if (screenSize.height < 800) {
      factor = 10.5;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('users').document(widget.userID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return Center(
                child: Text('Loading...'),
              );
            default:
              if(snapshot.data.data != null){
                userData = snapshot.data.data;
//                members = userData['members'];
//                members.forEach((member) { 
//                  
//                });
                if(userData.containsKey('members')){
                  members = userData['members'].map((member) => member['userID']).toList();
                }
                return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 25, right: 25, top: 25),
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
                                            members.length.toString(),
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
                                Container(
                                  height:
                                  (members.length / 5).ceil().toDouble() *
                                      (screenSize.height / factor),
                                  child: FutureBuilder<bool>(
                                    future: getUser(members),
                                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                                      if(snapshot.connectionState == ConnectionState.done) {
                                        return GridView.count(
                                          physics: new NeverScrollableScrollPhysics(),
                                          crossAxisCount: 5,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 3,
                                          childAspectRatio: 0.9,
                                          children: buildAvatarList(),
                                        );
                                      }
                                      else {
                                        return SizedBox();
                                      }
                                    },
                                  )
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.notifications,
                                        color: Colors.grey[600],
                                        semanticLabel: "notifications",
                                      ),
                                      Text(
                                        "群公告",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    userData['announcement'] != null ? userData['announcement'] : "暂时还没有群公告~",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
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
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          width: screenSize.width,
                          height: 400,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            child: GridView.count(
                              physics: new NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 5,
                              childAspectRatio: 1.15,
                              children: buildGroupList(userData['subGroups'] != null ? userData['subGroups'] : []),
                            ),
                          ),
                        ),
                      ],
                    )
                );
              }
              else{
                return Center(
                  child: Text('User file broken'),
                );
              }
          }
        },
      )
    );
  }
}