import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackGroundMessage(RemoteMessage message) async{
  print("Title : ${message.notification?.title}");
  print("Body : ${message.notification?.body}");
  print("Payload : ${message.data}");
}

class FirebaseApi{
  final _firebaseMessaging=FirebaseMessaging.instance;

  Future<void> initNotification() async{
    await _firebaseMessaging.requestPermission();
    final fcmToken=await _firebaseMessaging.getToken();
    print("Token : ${fcmToken}");

    FirebaseMessaging.onBackgroundMessage(handleBackGroundMessage);
  }
}