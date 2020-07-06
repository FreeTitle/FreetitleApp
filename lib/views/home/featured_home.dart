import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freetitle/app_theme.dart';
import 'package:freetitle/views/home/event_card.dart';
import 'package:freetitle/views/home/publication_list.dart';
import 'package:freetitle/views/home/project_card.dart';
import 'package:freetitle/views/home/event_card.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class FeaturedHome extends StatefulWidget {
  const FeaturedHome({
    Key key,
    this.scrollController,
  }) : super(key: key);

  final scrollController;

  _FeaturedHome createState() => _FeaturedHome();
}

class _FeaturedHome extends State<FeaturedHome> with TickerProviderStateMixin {
  List publications = List();

  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // Future<bool> getPublications() async {
  //   publications.clear();
  //   await Firestore.instance.collection('publications').orderBy('pubDate', descending: true).getDocuments().then((snap) {
  //     if(snap.documents.isNotEmpty){
  //       snap.documents.forEach((p) {
  //         if(p.data['ready'] == true)
  //           publications.add(p.data);
  //       });
  //     }
  //   });
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.centerLeft,
            child: Image.asset(
                'assets/label_event.png',
                scale: 2,
              ),),
          SingleChildScrollView(
            child: Row(children: <Widget>[
              EventCard(),
              EventCard(),
              EventCard(),
              EventCard(),
              EventCard(),
            ],),
            scrollDirection: Axis.horizontal,
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.centerLeft,
            child: Image.asset(
                'assets/label_project.png',
                scale: 2,
              ),),
          Column(
            children: <Widget>[
              ProjectCard(),
              ProjectCard(),
              ProjectCard(),
              ProjectCard(),
              ProjectCard(),
            ],
          ),
        ],
      ),
    );
    //   return FutureBuilder<bool>(
    //     future: getPublications(),
    //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
    //       if(snapshot.connectionState == ConnectionState.done){
    //         return LiquidPullToRefresh(
    //           scrollController: widget.scrollController,
    //           color: AppTheme.primary,
    //           showChildOpacityTransition: false,
    //           onRefresh: () async {
    //             publications.clear();
    //             await Firestore.instance.collection('publications').orderBy('pubDate', descending: true).getDocuments().then((snap) {
    //               if(snap.documents.isNotEmpty){
    //                 snap.documents.forEach((p) {
    //                   if(p.data['ready'] == true)
    //                     publications.add(p.data);
    //                 });
    //               }
    //             });
    //           },
    //           child: StaggeredGridView.countBuilder(
    //             padding: EdgeInsets.all(16.0),
    //             key: PageStorageKey('Featured'),
    //             itemCount: publications.length,
    //             crossAxisCount: 4,
    //             itemBuilder: (BuildContext context, int index) {
    //               return PublicationTile(publication: publications[index],);
    //             },
    //             staggeredTileBuilder: (int index) =>
    //                 StaggeredTile.fit(2),
    //             mainAxisSpacing: 16.0,
    //             crossAxisSpacing: 16.0,
    //           ),
    //         );
    //       }
    //       else {
    //         return Center(
    //           child: Text('Loading'),
    //         );
    //       }
    //     },
    //   );
    // }
  }

//class PublicationTile extends StatefulWidget {
//
//  _PublicationTile createState() => _PublicationTile();
//}

// class PublicationTile extends StatelessWidget{

//   const PublicationTile(
//   {Key key,
//     this.publication
//   }) : super(key : key);

//   final Map publication;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//           color: Theme.of(context).primaryColorDark,
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Theme.of(context).primaryColorLight.withOpacity(0.2),
//               offset: const Offset(4, 4),
//               blurRadius: 8,
//             ),
//           ],
//       ),

//       child: InkWell(
//         onTap: () {
//           Navigator.push<dynamic>(
//             context,
//             MaterialPageRoute<dynamic>(
//               builder: (BuildContext context) => PublicationView(contentIDs: publication['blogIDList'], title: publication['title'], cover: publication['cover'], typeList: publication['typeList'],),
//             ),
//           );
//         },
//         child: ClipRRect(
//           borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//           child: Column(
//             children: <Widget>[
//               Image.network(publication['cover']),
//               SizedBox(height: 10,),
//               Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Text(
//                   publication['title'],
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     letterSpacing: 0.27,
//                     color: Theme.of(context).accentColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//     );
//   }
// }

// class ProfileTile extends StatefulWidget {

//   _ProfileTile createState() => _ProfileTile();
// }

// class _ProfileTile extends State<ProfileTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//           color: AppTheme.white
//       ),
//       child: Center(
//         child: CircleAvatar(
//           backgroundColor: Colors.white,
//           child: Text('freetitle'),
//         ),
//       ),
//     );
//   }
// }

// class WelcomeTile extends StatefulWidget {

//   _WelcomeTile createState() => _WelcomeTile();
// }

// class _WelcomeTile extends State<WelcomeTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//           color: AppTheme.white
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(left: 30, top: 30, bottom: 30),
//         child: Text('Welcome to FreeTitle', style: AppTheme.headline,),
//       ),
//     );
//   }
// }
}
