import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freetitle/app_theme.dart';

class FeaturedHome extends StatefulWidget {

  const FeaturedHome(
  {Key key,
  }) : super(key : key);

  _FeaturedHome createState() => _FeaturedHome();
}

class _FeaturedHome extends State<FeaturedHome>{

  List publications = List();

  Future<bool> getPublications() async {
    publications.clear();
    await Firestore.instance.collection('publications').orderBy('pubDate', descending: true).getDocuments().then((snap) => {
      if(snap.documents.isNotEmpty){
        snap.documents.forEach((p) => {
          if(p.data['ready'] == true)
            publications.add(p.data),
        })
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getPublications(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return InkWell(
            onTap: () {

            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child:StaggeredGridView.countBuilder(
                key: PageStorageKey('Featured'),
                itemCount: publications.length,
                crossAxisCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return PublicationTile(publication: publications[index],);
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.fit(2),
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
            ),
          );
        }
        else {
          return Center(
            child: Text('Loading'),
          );
        }
      },
    );
  }
}

//class PublicationTile extends StatefulWidget {
//
//  _PublicationTile createState() => _PublicationTile();
//}

class PublicationTile extends StatelessWidget{

  const PublicationTile(
  {Key key,
    this.publication
  }) : super(key : key);

  final Map publication;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          color: AppTheme.white
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Column(
          children: <Widget>[
            Image.network(publication['cover']),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                publication['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class ProfileTile extends StatefulWidget {

  _ProfileTile createState() => _ProfileTile();
}

class _ProfileTile extends State<ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          color: AppTheme.white
      ),
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text('freetitle'),
        ),
      ),
    );
  }
}


class WelcomeTile extends StatefulWidget {

  _WelcomeTile createState() => _WelcomeTile();
}

class _WelcomeTile extends State<WelcomeTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          color: AppTheme.white
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 30, bottom: 30),
        child: Text('Welcome to FreeTitle', style: AppTheme.headline,),
      ),
    );
  }
}
