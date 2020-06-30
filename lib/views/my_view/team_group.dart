import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/views/my_view/subgroup_view.dart';
import 'package:freetitle/views/settings/settings.dart';

import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/main.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class SubGroup extends StatefulWidget {
  const SubGroup({
    Key key,
    this.groupName,
    this.groupMember,
    this.groupNotes,
  }) : super(key: key);
  SubGroupState createState() => SubGroupState();
  final groupName;
  final groupMember; // Can be greater than 5
  final groupNotes;
}

class SubGroupState extends State<SubGroup> {

  List avatarUrls;

  Future<bool> getAvatar() async {
    avatarUrls = List();
    for(final uid in widget.groupMember){
      await Firestore.instance.collection('users').document(uid).get().then((snap) {
        if(snap.data != null){
          avatarUrls.add(snap.data['avatarUrl']);
        }
      });
    }
    return true;
  }


  List<Widget> buildAvatarList(avatarUrls) {
    List<Widget> avatarList = List();
    for (final avatarUrl in avatarUrls) {
      avatarList.add(
        Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius:
              const BorderRadius.all(Radius.circular(80.0)),
              child: Image.network(avatarUrl, fit: BoxFit.cover,),
            ),
          ),
        ],
      ),
      );
    }
    return avatarList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
              Text(widget.groupName,
                  style: Theme.of(context).textTheme.bodyText1.merge(
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      size: 16.0,
                      color: Colors.grey[600],
                      semanticLabel: "Number",
                    ),
                    Text(
                      "5",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 8),
                height: 30,
                child: FutureBuilder<bool>(
                  future: getAvatar(),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return RowSuper(
                        children: buildAvatarList(avatarUrls.length > 5 ? avatarUrls.sublist(0, 5) : avatarUrls),
                        innerDistance: -12.0,
                      );
                    }
                    else{
                      return SizedBox();
                    }
                  },
                )
              ),
              Spacer(),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  child: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => SubGroupContent(groupMember: widget.groupMember, groupName: widget.groupName),
                        )
                    );
                  },
                ),
              ),
            ],
          ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 6),
            child: Divider(height: 2, color: Theme.of(context).accentColor),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              "备注",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .merge(TextStyle(fontSize: 13, color: Colors.grey)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.groupNotes,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .merge(TextStyle(fontSize: 13, color: Colors.grey)),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(left: 5, right: 5, top: 5),
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
    );
  }
}
