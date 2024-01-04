import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/final_screen.dart';
import 'instagram_constant.dart';
import 'instagram_model.dart';

class InstagramView extends StatelessWidget {
  final Map<String,List<String>>map;
   InstagramView({
    super.key,
   required this.map,
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
  try {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');
    final phoneNumber = prefs.getString('phoneNumber');
    final userEmail = prefs.getString('userEmail');
    final userType = prefs.getString('userType');
    final userId = prefs.getString('userId');
    await usersCollection.doc("$userId").set({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber!.replaceAll(" ", ""),
      'userEmail': userEmail,
      'preferences': map,
      'userType': userType,
      'instaUserName':instaUserName,
    }).then((value) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return ConfirmedLoginScreen();
      }));
    });
    print('User added to Firestore');
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
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => HomeView(
              //       token: instagram.authorizationCode.toString(),
              //       name: instagram.username.toString(),
              //     ),
              //   ),
              // );
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