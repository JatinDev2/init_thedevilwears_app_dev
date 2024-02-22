// import 'dart:async';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lookbook/Preferences/LoginData.dart';
// import 'package:lookbook/Provider/google_auth_provider.dart';
// import 'package:lookbook/Services/autheticationAPIs.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'package:uni_links/uni_links.dart';
// import 'Login/instaLogin/instagram_model.dart';
// import 'screens/splashScreen.dart';
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init('LoginData');
//   await Firebase.initializeApp();
//   runApp(const MyApp());
//   print("Aceess token is : ${LoginData().getUserAccessToken()}");
//   print("user id is : ${LoginData().getUserId()}");
//   FirebaseCrashlytics.instance.setCustomKey('userType', LoginData().getUserType());
//   FirebaseCrashlytics.instance.setCustomKey('userId', LoginData().getUserId());
//   FlutterError.onError = (FlutterErrorDetails details) {
//     FirebaseCrashlytics.instance.setCustomKey('details', details.exceptionAsString());
//     FirebaseCrashlytics.instance.recordFlutterError(details);
//   };
//
//
//   if(LoginData().getIsLoggedIn()==true && LoginData().getUserType()=="Company" ){
//     await InstagramModel().refreshLongLivedToken(LoginData().getUserAccessToken()).then((value) {
//       FirebaseAuthAPIs().updateOrCreateAccessToken(LoginData().getUserId(), LoginData().getUserAccessToken());
//     });
//   }
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   // late StreamSubscription _linkSubscription;
//
//   @override
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(414, 896),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MultiProvider(
//           providers:  [
//             ChangeNotifierProvider<GoogleSignInProvider>(
//               create: (context) => GoogleSignInProvider(),
//             ),
//           ],
//           child: MaterialApp(
//             title: 'LookBook',
//             theme: ThemeData(
//               // primaryColor: Colors.black,
//               useMaterial3: false,
//               colorScheme: const ColorScheme.light(
//                 primary: Color(0xffFF9431),
//               ),
//               textTheme: GoogleFonts.poppinsTextTheme(),
//             ),
//           home: SplashScreen(),
//
//             debugShowCheckedModeBanner: false,
//           ),
//         );
//       },
//     );
//   }
// }


import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Provider/google_auth_provider.dart';
import 'package:lookbook/Services/autheticationAPIs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'Login/instaLogin/instagram_model.dart';
import 'screens/splashScreen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('LoginData');
  await Firebase.initializeApp();
  runApp(const MyApp());
  print("Aceess token is : ${LoginData().getUserAccessToken()}");
  print("user id is : ${LoginData().getUserId()}");
  FirebaseCrashlytics.instance.setCustomKey('userType', LoginData().getUserType());
  FirebaseCrashlytics.instance.setCustomKey('userId', LoginData().getUserId());
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.setCustomKey('details', details.exceptionAsString());
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  if(LoginData().getIsLoggedIn()==true && LoginData().getUserType()=="Company" ){
    await InstagramModel().refreshLongLivedToken(LoginData().getUserAccessToken()).then((value) {
      FirebaseAuthAPIs().updateOrCreateAccessToken(LoginData().getUserId(), LoginData().getUserAccessToken());
    });
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _linkSubscription = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
     print("Couldn't open deep link");
    });
  }

  // void _handleDeepLink(Uri uri) {
  //   // Parse the uri and navigate to the desired screen
  //   // Example: if the uri is 'https://example.com/deleteProfile'
  //   if (uri.host == 'example.com' && uri.path == '/deleteProfile') {
  //     Navigator.of(context).push(MaterialPageRoute(builder: (_){
  //       return const SplashScreen();
  //     }))
  //   }
  // }

  void _handleDeepLink(Uri uri) {
    if (uri.host == 'eorxqgcoze4zwo1.m.pipedream.net') {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const SplashScreen()));
    }
  }

  @override
  void dispose() {
    _linkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers:  [
            ChangeNotifierProvider<GoogleSignInProvider>(
              create: (context) => GoogleSignInProvider(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'LookBook',
            theme: ThemeData(
              // primaryColor: Colors.black,
              useMaterial3: false,
              colorScheme: const ColorScheme.light(
                primary: Color(0xffFF9431),
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            home: SplashScreen(),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
