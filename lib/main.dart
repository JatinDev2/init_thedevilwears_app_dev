import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Provider/google_auth_provider.dart';
import 'package:lookbook/Services/autheticationAPIs.dart';
import 'package:lookbook/screens/home/home_screen.dart';
import 'package:lookbook/screens/jobs/filterScreen.dart';
import 'package:lookbook/screens/lookbook/lookbook_details_screen.dart';
import 'package:lookbook/screens/lookbook/lookbook_images_slider_screen.dart';
import 'package:lookbook/screens/lookbook/lookbook_image_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'instaLogin/instagram_model.dart';
import 'splashScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('LoginData');
  await Firebase.initializeApp();
  // await FirebaseApi().initNotification();
  // initUniLinks(); // Initialize uni_links package
  runApp(const MyApp());
  print("Aceess token is : ${LoginData().getUserAccessToken()}");
  print("user id is : ${LoginData().getUserId()}");

  if(LoginData().getIsLoggedIn()==true && LoginData().getUserType()=="Company" ){
    await InstagramModel().refreshLongLivedToken(LoginData().getUserAccessToken()).then((value) {
      FirebaseAuthAPIs().updateOrCreateAccessToken(LoginData().getUserId(), LoginData().getUserAccessToken());
    });
  }
}

Future<void> initUniLinks() async {
  // Ensure that you call `await getInitialLink()` during app initialization
  try {
    final initialLink = await getInitialLink();
    handleDeepLink(initialLink);
  } catch (e) {
    // Handle any errors
  }

  // Listen for incoming links
  getLinksStream().listen((String? link) {
    handleDeepLink(link);
  });
}

void handleDeepLink(String? link) {
  if (link != null) {
    // Parse the link and extract parameters
    final Uri uri = Uri.parse(link);
    final String? listingId = uri.queryParameters['listingId'];

    // Navigate to the appropriate screen using the listing ID
    if (listingId != null) {

      // Navigate to the Details_Screen with the listing ID
      // Example: Navigator.push(...)
      // Navigator.of(context).push(MaterialPageRoute(builder: (_){
      //   return Details_Screen(
      //     listing: ListModel(listingType: '', location: '', eventCategory: '', eventDate: '', instaHandle: '', productDate: '', requirement: '', toStyleName: ''
      //
      //     ),
      //   )
      // }));
    }
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late StreamSubscription _linkSubscription;

  @override
  // This widget is the root of your application.
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
            title: 'LookBook',
            theme: ThemeData(
              // primaryColor: Colors.black,
              useMaterial3: false,
              colorScheme: const ColorScheme.light(
                primary: Color(0xffFF9431),
              ),

              // useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            // home: HomeScreen(),
            // home: FirstPage(),
          // home:
          // NewHomeScreen(),
          home: SplashScreen(),
          // const FirstPage()
          // PhoneNumber_Screen()
          // HomeScreen(),
          // CreateNewJobListing(),
          // FilterJobListings(),
          // JobListScreen(),
          // StudentProfileScreen(),
          // BrandProfileScreen(),
          // InstagramMediaWidget(),
          // OptionsInScreen(),
          // PhoneNumber_Screen(),
          // OptionsInScreen(),
          // InterestScreen(),
          // OppurtunitiesScreen(),
          // PhoneNumber_Screen(),
          // StreamBuilder(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return Scaffold(
          //         body: Center(
          //           child: Text("Something went wrong"),
          //         ),
          //       );
          //     } else if (snapshot.hasData) {
          //       return FutureBuilder(
          //         future: SharedPreferences.getInstance(),
          //         builder: (context, prefsSnapshot) {
          //           if (prefsSnapshot.connectionState == ConnectionState.waiting) {
          //             return SplashScreen();
          //           } else if (prefsSnapshot.hasData) {
          //             final prefs = prefsSnapshot.data as SharedPreferences;
          //             final phoneVerified = prefs.getBool('phoneVerified') ?? false;
          //             final optionSelected = prefs.getBool('optionSelected') ?? false;
          //             final isHomePage= prefs.getBool('isHomePage') ?? false;
          //             if(isHomePage){
          //               return HomeScreen();
          //             }
          //           else if (phoneVerified && optionSelected){
          //               return HomeScreen();
          //             }
          //               else if(phoneVerified && !optionSelected){
          //                 return OptionsInScreen();
          //             }
          //             else if(!phoneVerified && !optionSelected) {
          //               return PhoneNumber_Screen();
          //             }
          //             else{
          //               return SplashScreen();
          //             }
          //           } else{
          //             // Handle the case when SharedPreferences loading failed
          //             return Scaffold(
          //               body: Center(
          //                 child: Text("Failed to load SharedPreferences"),
          //               ),
          //             );// StreamBuilder(
          // //   stream: FirebaseAuth.instance.authStateChanges(),
          // //   builder: (context, snapshot) {
          // //     if (snapshot.hasError) {
          // //       return Scaffold(
          // //         body: Center(
          // //           child: Text("Something went wrong"),
          // //         ),
          // //       );
          // //     } else if (snapshot.hasData) {
          // //       return FutureBuilder(
          // //         future: SharedPreferences.getInstance(),
          // //         builder: (context, prefsSnapshot) {
          // //           if (prefsSnapshot.connectionState == ConnectionState.waiting) {
          // //             return FirstPage();
          // //           } else if (prefsSnapshot.hasData) {
          // //             final prefs = prefsSnapshot.data as SharedPreferences;
          // //             final phoneVerified = prefs.getBool('phoneVerified') ?? false;
          // //             if (phoneVerified){
          // //               return HomeScreen();
          // //             } else {
          // //               return PhoneNumber_Screen();
          // //             }
          // //           } else {
          // //             // Handle the case when SharedPreferences loading failed
          // //             return Scaffold(
          // //               body: Center(
          // //                 child: Text("Failed to load SharedPreferences"),
          // //               ),
          // //             );
          // //           }
          // //         },
          // //       );
          // //     } else {
          // //       return FirstPage();
          // //     }
          // //   },
          //           }
          //         },
          //       );
          //     } else {
          //       return SplashScreen();
          //     }
          //   },
          // ),

              onGenerateRoute: (settings) {
              // if (settings.name == '/listingFilterScreen') {
              //   // Retrieve the arguments passed when navigating to '/listingFilterScreen'
              //   final arguments = settings.arguments as List<String>;
              //
              //   return MaterialPageRoute(
              //     builder: (context) => FiltersScreen_Listing(selectedOptionsSourcing: arguments),
              //   );
              // }
              // Handle other named routes here if needed
              if (settings.name == '/listingFilterJobScreen') {
                // Retrieve the arguments passed when navigating to '/listingFilterScreen'
                final arguments = settings.arguments as List;

                return MaterialPageRoute(
                  builder: (context) => FilterJobListings(selectedOptions: arguments,),
                );
              }
              // if (settings.name == '/listingPreviewScreenFirst') {
              //   // Retrieve the arguments passed when navigating to '/listingFilterScreen'
              //   final arguments = settings.arguments as List;
              //   return MaterialPageRoute(
              //     builder: (context) => PreviewScreen_First(selectedItems: arguments,),
              //   );
              // }
              //
              // if (settings.name == '/listingPreviewScreenSecond') {
              //   // Retrieve the arguments passed when navigating to '/listingFilterScreen'
              //   final arguments = settings.arguments as List;
              //   return MaterialPageRoute(
              //     builder: (context) => PreviewScreen_Second(selectedItems: arguments,),
              //   );
              // }
              //
              // if (settings.name == '/newlistingform') {
              //   // Retrieve the arguments passed when navigating to '/listingFilterScreen'
              //   final arguments = settings.arguments as String;
              //   return MaterialPageRoute(
              //     builder: (context) => NewListingForm(listingType: arguments,),
              //   );
              // }

              // if (settings.name == '/listinglookbookdetails') {
              //   // Retrieve the arguments passed when navigating to '/listingFilterScreen'
              //   final arguments = settings.arguments as Map<String, dynamic>;
              //
              //   return MaterialPageRoute(
              //     builder: (context) => LookbookGridScreen(
              //       headText: arguments['headText'],
              //       subText: arguments['subText'],
              //       previousSelectedItems: arguments['previousSelectedItems'],
              //     ),
              //   );
              // }
            },
            routes: <String, WidgetBuilder>{
              '/homeScreen': (BuildContext ctx) => HomeScreen(),
              '/lookbookDetailsScreen': (BuildContext ctx) => LookbookDetailsScreen(),
              '/lookbookImagesSliderScreen': (BuildContext ctx) => LookbookImagesSliderScreen(),
              '/lookbookImageDetailsScreen': (BuildContext ctx) => LookbookImageDetailsScreen(),
              // '/searchFilterScreen': (BuildContext ctx) => FiltersScreen(),
              // '/listingScreen' : (BuildContext ctx) => ListingScreen(),
              // 'listingDetailsScreen' : (BuildContext ctx) => Details_Screen(),
              // '/listingResponseScreen' : (BuildContext ctx) => ResponseScreen(),
              // '/listingConfirmResponseScreen' : (BuildContext ctx) => ConfirmScreen(),
              // '/newlistingOptionsScreen' : (BuildContext ctx) => OptionsScreen(),
            },
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

// GoRouter _appRoute=GoRouter(routes: <RouteBase>[
//   GoRoute(
//       path: "/",
//   builder: (BuildContext context, GoRouterState state){
//         return FirstPage();
//   }
//   ),
//   GoRoute(
//       path: "/listingDetail",
//       builder: (BuildContext context, GoRouterState state){
//         return FirstPage();
//       }
//   ),
// ])