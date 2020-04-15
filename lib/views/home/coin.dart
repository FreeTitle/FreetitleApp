
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/model/user_repository.dart';

class CoinPage extends StatefulWidget {
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {

  UserRepository _userRepository;
  String userID;
  Map userData;

  Future<bool> getData() async {
    _userRepository = UserRepository();
    await _userRepository.getUser().then((snap) {
      userID = snap.uid;
    });


    await Firestore.instance.collection('users').document(userID).get().then((snap) {
      userData = snap.data;
    });

    return true;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('金币', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("金币可以用来：", style: AppTheme.body1Bold,),
            Text("给其他人的文章/活动/评论点赞（不限次数），高赞的文章/活动/评论会排名靠前，"),
            Text("(开发中) 使用金币永久解锁那些被作者设为需要金币解锁的文章。"),
            Text("做这些可以获取金币：", style: AppTheme.body1Bold,),
            Text("文章/活动/评论被其他人点赞次数转化为收到的金币，"),
            Text("新用户登录获得20金币，每日签到获得1金币，"),
            Text("文章发布后过24小时未删除奖励10金币，"),
            Text("(开发中) 设置文章为需要金币解锁，读者只能看到部分，解锁全文所消费金币归作者，"),
            Text("(开发中) 转发至其他社交账号,"),
            Text("(开发中) 通过分享邀请码让朋友注册，两人都收获金币，"),
            Text("(开发中) 微信充值官方人员由于有权限通过其他账号发文，所以发布文章奖励结算时不奖励文章拥有人而奖励实际操作人。"),
            SizedBox(height: 20,),
            FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  Timestamp lastClaimTime = userData['lastClaimTime'];
                  if(lastClaimTime == null){
                    return Center(
                      child: InkWell(
                        onTap: () async {
                          await Firestore.instance.collection('users').document(userID).updateData({
                            'coins': FieldValue.increment(1),
                            'lastClaimTime': DateTime.now(),
                          });
                          setState(() {

                          });
                        },
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: AppTheme.primary,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.stars,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  else if(lastClaimTime.toDate().day < DateTime.now().day){
                    return Center(
                      child: InkWell(
                        onTap: () async {
                          await Firestore.instance.collection('users').document(userID).updateData({
                            'coins': FieldValue.increment(1),
                            'lastClaimTime': DateTime.now(),
                          });
                          setState(() {

                          });
                        },
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: AppTheme.primary,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.stars,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  else{
                    return Center(
                      child: Text("今日奖励已领取"),
                    );
                  }
                }
                else{
                  return Center(
                    child: Text('Loading...'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}