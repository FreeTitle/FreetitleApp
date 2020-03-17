import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';

class UserCard extends StatelessWidget{
  const UserCard(
      {Key key,
        this.userData,
      }
  ): super(key: key);

  final userData;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow:  <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 48,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 4, bottom: 4),
                                      child: Text(
                                        'Coins',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.1,
                                          color: AppTheme.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 20,
                                          height: 25,
                                          child: Icon(
                                            Icons.attach_money,
                                            size: 17,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 0, bottom: 3),
                                          child: Text(
                                            userData['coins'] != null ? userData['coins'].toString() : '0',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 16,
                                              color: AppTheme.darkerText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                height: 48,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(80.0)),
                                child: Image.network(userData['avatarUrl'], fit: BoxFit.fill,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
                            child: Text(
                              userData['displayName'].length > 15 ? userData['displayName'].substring(0,15)+'...' : userData['displayName'],
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.grey,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 8),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: AppTheme.nearlyBlack.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Blogs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: -0.2,
                            color: AppTheme.darkText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            height: 4,
                            width: 70,
                            decoration: BoxDecoration(
                              color:
                              AppTheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      AppTheme.primary,
                                      AppTheme.primary.withOpacity(0.1),
                                    ]),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4.0)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            userData['blogs'] != null ? userData['blogs'].length.toString() : '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppTheme.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Missions',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: -0.2,
                                color: AppTheme.darkText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                height: 4,
                                width: 70,
                                decoration: BoxDecoration(
                                  color:
                                  AppTheme.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          AppTheme.secondary,
                                          AppTheme.secondary.withOpacity(0.1),
                                        ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                userData['missions'] != null ? userData['missions'].length.toString() : '0',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppTheme.grey
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Bookmarks',
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: -0.2,
                                color: AppTheme.darkText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 0, top: 4),
                              child: Container(
                                height: 4,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyBlue.withOpacity(0.2),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 70,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        gradient:
                                        LinearGradient(colors: [
                                          AppTheme.nearlyBlue,
                                          AppTheme.nearlyBlue.withOpacity(0.1),
                                        ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                userData['bookmarks'] != null ? userData['bookmarks'].length.toString() : '0',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: AppTheme.grey
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}