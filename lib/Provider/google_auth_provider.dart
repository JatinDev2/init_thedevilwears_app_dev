// import "package:flutter/material.dart";
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class GoogleSignInProvider extends ChangeNotifier{
//   final googleSignIn= GoogleSignIn();
//
//   GoogleSignInAccount? _user;
//
//   GoogleSignInAccount get user => _user!;
//
//   Future googleLogIn() async{
//    final googleUser= await googleSignIn.signIn();
//    if(googleUser==null) return;
//
//    _user=googleUser;
//
//    final googleAuth= await googleUser.authentication;
//
//    final credential =GoogleAuthProvider.credential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    await FirebaseAuth.instance.signInWithCredential(credential);
//   notifyListeners();
//   }
//
//
//   Future logout() async{
//     await googleSignIn.disconnect();
//     FirebaseAuth.instance.signOut();
// }
// }
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<bool> googleLogIn() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return false;

    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      LoginData().writeUserEmail(value.user!.email.toString());
      LoginData().writeUserId(value.user!.uid.toString());
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('userEmail', value.user!.email.toString());
      // print("(((((((******************************))))))))))");
      // print(value.user!.uid.toString());
      // await prefs.setString('userId', value.user!.uid.toString());
    });
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

}
