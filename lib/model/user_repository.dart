import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freetitle/views/my_view/my_view.dart';
import 'package:freetitle/views/profile/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:freetitle/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    /**
     * google sign in, return the current user
     */
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser user = await _firebaseAuth.currentUser();
    print('In user repository ${user}');
    await Firestore.instance.collection('users').document(user.uid).get()
        .then((snap) {
      if (snap.data == null) {
        Firestore.instance.collection('users').document(user.uid).setData({
          'displayName': user.displayName,
          'email': user.email,
          'avatarUrl': user.photoUrl,
        });
      }
    });

    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String username, String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseUser user = await _firebaseAuth.currentUser();

    await user.sendEmailVerification().catchError((e) {
      print('email error $e');
    }).whenComplete(() {
      print('email sent');
    });

    Firestore.instance.collection('users').document(user.uid).setData({
      'displayName': username,
      'email': email,
      'avatarUrl': 'https://firebasestorage.googleapis.com/v0/b/freetitle.appspot.com/o/default-user.jpg?alt=media&token=63dfd982-e9ca-4a3e-a432-d8c193de459a',
    });
  }

  Future<void> resetPassword({String password}) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    await user.updatePassword(password).catchError((e) {
      print('error changing password $e');
      throw e;
    }).whenComplete(() {
      print('password changed');
    });

    return user.uid;
  }

  Future<void> resetEmail({String email}) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance.collection('users').document(user.uid).updateData({
      'email': email,
    });
    await user.updateEmail(email).catchError((e) {
      print('error changing email $e');
      throw e;
    }).whenComplete(() {
      print('email changed');
    });

    return user.uid;
  }

  Future<void> resetUsername({String username}) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await Firestore.instance.collection('users').document(user.uid).updateData({
      'displayName': username,
    });

    return user.uid;
  }

  Future<void> signOut() async {
    SharedPreferences sharedPref;
    await SharedPreferences.getInstance().then((pref) {
      sharedPref = pref;
    });
    await sharedPref.remove('currentUser');
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
//    return Future.wait([
//      _firebaseAuth.signOut(),
//      _googleSignIn.signOut(),
//    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return (await _firebaseAuth.currentUser());
  }

  Future<String> getUserID() async {
    var user = await getUser();
    return user.uid;
  }

  Future<Map> getUserData() async {
    var uid = await getUserID();
    var userRef = await Firestore.instance.collection('users').document(uid).get();
    return userRef.data;
  }

  Widget getUserWidget(BuildContext context, String uid, Map userData,
      {color = AppTheme.nearlyWhite}) {
    String userName = userData['displayName'];
    if (userName.length > 15) {
      userName = userName.substring(0, 15) + "...";
    }
    String avatarURL = userData['avatarUrl'];
    Image avatar = Image.network(avatarURL, fit: BoxFit.cover,);
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  Profile(userID: uid, isMyProfile: false),
//                        builder: (BuildContext context) => MyProfile(userID: uid, isMyProfile: false, userName: userName,),
            ),
          );
        },
        child: Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
//                          boxShadow: <BoxShadow>[
//                            BoxShadow(
//                                color: AppTheme.grey.withOpacity(0.6),
//                                offset: const Offset(2.0, 4.0),
//                                blurRadius: 2),
//                          ],
              ),
              child: ClipRRect(
                borderRadius:
                const BorderRadius.all(Radius.circular(60.0)),
                child: avatar,
              ),
            ),
            SizedBox(width: 10,),
            Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).accentColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}