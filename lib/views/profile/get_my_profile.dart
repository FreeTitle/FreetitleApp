import 'package:freetitle/model/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:freetitle/views/profile/profile.dart';

class GetMyProfile extends StatefulWidget {

  _GetMyProfile createState() => _GetMyProfile();
}

class _GetMyProfile extends State<GetMyProfile>{

  UserRepository _userRepository;
  String userID;

  @override
  void initState(){
    _userRepository = UserRepository();
    super.initState();
  }

  Future<bool> getData() async {
    await _userRepository.getUser().then((snap) => {
      userID = snap.uid,
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(userID != null){
            return Profile(userID: userID, isMyProfile: true, );
          }
          else{
            return Text('User file broken');
          }
        }
    );
  }
}