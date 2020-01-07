import 'package:cloud_firestore/cloud_firestore.dart';

class HomeListData {
  HomeListData({
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

  void queryData(){
    Firestore.instance.collection('news').snapshots().listen((data) =>
        data.documents.forEach((doc) => print(doc["Title"])
    ));
  }

  static List<HomeListData> homeList = <HomeListData>[
    HomeListData(
      imagePath: 'assets/hotel/hotel_1.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Wembley, London',
      reviews: 80,
    ),
    HomeListData(
      imagePath: 'assets/hotel/hotel_2.png',
      titleTxt: 'Queen Hotel',
      subTxt: 'Wembley, London',
      reviews: 74,
    ),
    HomeListData(
      imagePath: 'assets/hotel/hotel_3.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Wembley, London',
      reviews: 62,
    ),
    HomeListData(
      imagePath: 'assets/hotel/hotel_4.png',
      titleTxt: 'Queen Hotel',
      subTxt: 'Wembley, London',
      reviews: 90,
    ),
    HomeListData(
      imagePath: 'assets/hotel/hotel_5.png',
      titleTxt: 'Grand Royal Hotel',
      subTxt: 'Wembley, London',
      reviews: 240,
    ),
  ];
}