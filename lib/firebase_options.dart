// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCMVJ9h9o3woMMjYTTNilsY9JXkZqya3Vo',
    appId: '1:499908502762:web:1515fe516bed7d3284a393',
    messagingSenderId: '499908502762',
    projectId: 'thedevilwears-845f3',
    authDomain: 'thedevilwears-845f3.firebaseapp.com',
    storageBucket: 'thedevilwears-845f3.appspot.com',
    measurementId: 'G-5DYJ2JP37P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrw1r0QZffOr4sBQ7nmdJfUy1ralJa_GE',
    appId: '1:499908502762:android:9e938d83249a3e8684a393',
    messagingSenderId: '499908502762',
    projectId: 'thedevilwears-845f3',
    storageBucket: 'thedevilwears-845f3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwtZbcVcOAhcDQHkCTwEAq1RSI4Os2zr0',
    appId: '1:499908502762:ios:788b4a69c93b0cf884a393',
    messagingSenderId: '499908502762',
    projectId: 'thedevilwears-845f3',
    storageBucket: 'thedevilwears-845f3.appspot.com',
    androidClientId: '499908502762-5ja46t3o5695hesmrrs7ic1bstvd39o9.apps.googleusercontent.com',
    iosClientId: '499908502762-prvksejm3v7e34d3bma259a1vkagfl1h.apps.googleusercontent.com',
    iosBundleId: 'in.lookbook.lookbook',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwtZbcVcOAhcDQHkCTwEAq1RSI4Os2zr0',
    appId: '1:499908502762:ios:788b4a69c93b0cf884a393',
    messagingSenderId: '499908502762',
    projectId: 'thedevilwears-845f3',
    storageBucket: 'thedevilwears-845f3.appspot.com',
    androidClientId: '499908502762-5ja46t3o5695hesmrrs7ic1bstvd39o9.apps.googleusercontent.com',
    iosClientId: '499908502762-prvksejm3v7e34d3bma259a1vkagfl1h.apps.googleusercontent.com',
    iosBundleId: 'in.lookbook.lookbook',
  );
}
