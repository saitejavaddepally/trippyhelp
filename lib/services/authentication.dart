import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_on_click/services/database.dart';
import 'package:travel_on_click/ui/helper/sharedpref_helper.dart';
import 'package:travel_on_click/ui/screens/home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  getCurrentUser() async {
    // ignore: await_only_futures
    return await _auth.currentUser;
  }

// Sign In with email and password

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString().substring(30),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

// Sign Up with Email and Password
   Future<User?>  signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = credential.user;
      return user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString().substring(36),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

// Google sign in
  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;

    SharedPreferenceHelper().saveUserId(userDetails!.uid);
    SharedPreferenceHelper().saveUserEmail(userDetails.email);
    SharedPreferenceHelper()
        .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
    SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
    SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);

    Map<String, dynamic> userInfoMap = {
      "email": userDetails.email,
      "username": userDetails.email!.replaceAll("@gmail.com", ""),
      "name": userDetails.displayName,
      "profile": userDetails.photoURL,
      "userId": userDetails.uid
    };

    DatabaseMethods()
        .addUserInfoToDB(userDetails.uid, userInfoMap)
        .then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await _auth.signOut();
  }
}
