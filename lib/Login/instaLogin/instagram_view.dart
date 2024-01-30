import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Services/autheticationAPIs.dart';
import '../../screens/home/old_home_screen.dart';
import '../final_screen.dart';
import 'instagram_constant.dart';
import 'instagram_model.dart';

class InstagramView extends StatelessWidget {
  final Map<String,List<String>>map;
  final String label;
   InstagramView({
    super.key,
   required this.map,
     required this.label,
});
  // const InstagramView({Key? key}) : super(key: key);
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final webview = FlutterWebviewPlugin();
      final InstagramModel instagram = InstagramModel();

      buildRedirectToHome(webview, instagram, context);

      return WebviewScaffold(
        url: InstagramConstant.instance.url,
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context),
      );
    });
  }

  Future<void> addUser(BuildContext context,String instaUserName) async {
    // final prefs = await SharedPreferences.getInstance();
  try {
    InstagramModel().exchangeForLongLivedToken().then((value) {
      FirebaseAuthAPIs().updateOrCreateAccessToken(LoginData().getUserId(),LoginData().getUserAccessToken());
    });
    if(label=="Login"){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace HomeScreen with your home screen widget
            (Route<dynamic> route) => false, // Conditions for routes to remove; false removes all
      );
    }
    else{
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const ConfirmedLoginScreen();
      }));
      print('User added to Firestore');
    }

  } catch (e) {
    print('Error adding user to Firestore: $e');
  }
}

  Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
      InstagramModel instagram, BuildContext context) async {
    webview.onUrlChanged.listen((String url) async {
      if (url.contains(InstagramConstant.redirectUri)) {
        instagram.getAuthorizationCode(url);
        await instagram.getTokenAndUserID().then((isDone) {
          if (isDone) {
            instagram.getUserProfile().then((isDone) async {
              await webview.close();
              print('${instagram.username} logged in!');

              await addUser(context,instagram.username.toString() );
            });
          }
        });
      }
    });
  }

  AppBar buildAppBar(BuildContext context) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Instagram Login',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.black),
        ),
      );
}