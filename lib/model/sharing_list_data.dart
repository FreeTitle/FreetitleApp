import 'package:cloud_firestore/cloud_firestore.dart';

class SharingListData {
  SharingListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.reviews = 80,
    this.viewed = 99,
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  int reviews;
  int viewed;

  static void queryData(){
    print('query');
    Firestore.instance.collection('news').snapshots().listen((data) =>
        data.documents.forEach((doc) => print(doc["Title"])
    ));
  }

  static List<SharingListData> sharingList = <SharingListData>[
    SharingListData(
      imagePath: 'assets/images/ml.jpeg',
      titleTxt: '【浮樂作品】梦鹿 | “她是一头鹿，她有一个宿命 ”',
      subTxt: '贼喜鹊',
      reviews: 80,
    ),
    SharingListData(
      imagePath: 'assets/images/nz.jpeg',
      titleTxt: '《哪吒：魔童降世》：过三关，砸烂天，不为馒头为口气',
      subTxt: '红肠 ',
      reviews: 74,
    ),
    SharingListData(
      imagePath: 'assets/images/lqm.jpeg',
      titleTxt: '【浮樂摄影】“起风了，去看展” | 利奇马登陆魔都的前一天',
      subTxt: 'Freetitle',
      reviews: 62,
    ),
    SharingListData(
      imagePath: 'assets/images/lj.jpeg',
      titleTxt: '【浮樂专访】生活在角色中 || 李钜：“我在美国学表演”',
      subTxt: 'Freetitle',
      reviews: 90,
    ),
  ];
}