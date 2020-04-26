import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoScreen extends StatelessWidget {

  PhotoScreen({Key key, @required this.photoUrl, @required this.photoType}) : super(key : key);

  final String photoUrl;
  final String photoType;

  @override
  Widget build(BuildContext context) {
    ImageProvider img;
    if(photoType == 'asset') {
      img = AssetImage(photoUrl);
    }
    else if(photoType == 'network') {
      img = NetworkImage(photoUrl);
    }
    else{
      return SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
          width: 400,
          height: 400,
          child: PhotoView(
            imageProvider: img,
          )
      ),
    );
  }
}