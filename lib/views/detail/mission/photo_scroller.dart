import 'package:flutter/material.dart';

class PhotoScroller extends StatelessWidget{
  PhotoScroller(this.photoURLs);
  final List<String> photoURLs;

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = photoURLs[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.asset(
          photo,
          width: 160.0,
          height: 120.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Photos',
            style: textTheme.subhead.copyWith(fontSize: 18.0),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(100.0),
          child: ListView.builder(
            itemCount: photoURLs.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 8.0, left: 20.0),
            itemBuilder: _buildPhoto
          ),
        )
      ],
    );
  }
}