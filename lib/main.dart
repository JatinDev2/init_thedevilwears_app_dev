import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookbook/Provider/google_auth_provider.dart';
import 'package:lookbook/screens/home/home_screen.dart';
import 'package:lookbook/screens/listing/Confirmation_screen.dart';
import 'package:lookbook/screens/listing/Details_Screen.dart';
import 'package:lookbook/screens/listing/FiltersScreen_Listing.dart';
import 'package:lookbook/screens/listing/PreviewScreen_first.dart';
import 'package:lookbook/screens/listing/PriviewScreen_second.dart';
import 'package:lookbook/screens/listing/listing_screen.dart';
import 'package:lookbook/screens/listing/lookbook_details_grid.dart';
import 'package:lookbook/screens/listing/new_listing/new_listing_form.dart';
import 'package:lookbook/screens/listing/new_listing/options_screen.dart';
import 'package:lookbook/screens/listing/response_screen.dart';
import 'package:lookbook/screens/lookbook/lookbook_details_screen.dart';
import 'package:lookbook/screens/lookbook/lookbook_images_slider_screen.dart';
import 'package:lookbook/screens/lookbook/lookbook_image_details.dart';
import 'package:lookbook/screens/search/FiltersScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/first_screen.dart';
import 'Login/options_screen.dart';
import 'Login/phoneNumber_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(
              create: (context) => GoogleSignInProvider(),
            ),
          ],
          child: MaterialApp(
            title: 'LookBook',
            theme: ThemeData(
              primaryColor: Colors.black,
              // useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            // home: HomeScreen(),
            // home: FirstPage(),
          home:
          // HomeScreen(),
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Something went wrong"),
                  ),
                );
              } else if (snapshot.hasData) {
                return FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (context, prefsSnapshot) {
                    if (prefsSnapshot.connectionState == ConnectionState.waiting) {
                      return FirstPage();
                    } else if (prefsSnapshot.hasData) {
                      final prefs = prefsSnapshot.data as SharedPreferences;
                      final phoneVerified = prefs.getBool('phoneVerified') ?? false;
                      final optionSelected = prefs.getBool('optionSelected') ?? false;
                      if (phoneVerified && optionSelected){
                        return HomeScreen();
                      }
                        else if(phoneVerified && !optionSelected){
                          return OptionsInScreen();
                      }
                      else {
                        return PhoneNumber_Screen();
                      }
                    } else{
                      // Handle the case when SharedPreferences loading failed
                      return Scaffold(
                        body: Center(
                          child: Text("Failed to load SharedPreferences"),
                        ),
                      );// StreamBuilder(
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
          //             return FirstPage();
          //           } else if (prefsSnapshot.hasData) {
          //             final prefs = prefsSnapshot.data as SharedPreferences;
          //             final phoneVerified = prefs.getBool('phoneVerified') ?? false;
          //             if (phoneVerified){
          //               return HomeScreen();
          //             } else {
          //               return PhoneNumber_Screen();
          //             }
          //           } else {
          //             // Handle the case when SharedPreferences loading failed
          //             return Scaffold(
          //               body: Center(
          //                 child: Text("Failed to load SharedPreferences"),
          //               ),
          //             );
          //           }
          //         },
          //       );
          //     } else {
          //       return FirstPage();
          //     }
          //   },

                    }
                  },
                );
              } else {
                return FirstPage();
              }
            },
          ),

              onGenerateRoute: (settings) {
              if (settings.name == '/listingFilterScreen') {
                // Retrieve the arguments passed when navigating to '/listingFilterScreen'
                final arguments = settings.arguments as List<String>;

                return MaterialPageRoute(
                  builder: (context) => FiltersScreen_Listing(selectedOptionsSourcing: arguments),
                );
              }
              // Handle other named routes here if needed

              if (settings.name == '/listingPreviewScreenFirst') {
                // Retrieve the arguments passed when navigating to '/listingFilterScreen'
                final arguments = settings.arguments as List;
                return MaterialPageRoute(
                  builder: (context) => PreviewScreen_First(selectedItems: arguments,),
                );
              }

              if (settings.name == '/listingPreviewScreenSecond') {
                // Retrieve the arguments passed when navigating to '/listingFilterScreen'
                final arguments = settings.arguments as List;
                return MaterialPageRoute(
                  builder: (context) => PreviewScreen_Second(selectedItems: arguments,),
                );
              }

              if (settings.name == '/newlistingform') {
                // Retrieve the arguments passed when navigating to '/listingFilterScreen'
                final arguments = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) => NewListingForm(listingType: arguments,),
                );
              }

              if (settings.name == '/listinglookbookdetails') {
                // Retrieve the arguments passed when navigating to '/listingFilterScreen'
                final arguments = settings.arguments as Map<String, dynamic>;

                return MaterialPageRoute(
                  builder: (context) => LookbookGridScreen(
                    headText: arguments['headText'],
                    subText: arguments['subText'],
                    previousSelectedItems: arguments['previousSelectedItems'],
                  ),
                );
              }
            },
            routes: <String, WidgetBuilder>{
              '/homeScreen': (BuildContext ctx) => HomeScreen(),
              '/lookbookDetailsScreen': (BuildContext ctx) => LookbookDetailsScreen(),
              '/lookbookImagesSliderScreen': (BuildContext ctx) => LookbookImagesSliderScreen(),
              '/lookbookImageDetailsScreen': (BuildContext ctx) => LookbookImageDetailsScreen(),
              '/searchFilterScreen': (BuildContext ctx) => FiltersScreen(),
              '/listingScreen' : (BuildContext ctx) => ListingScreen(),
              'listingDetailsScreen' : (BuildContext ctx) => Details_Screen(),
              '/listingResponseScreen' : (BuildContext ctx) => ResponseScreen(),
              '/listingConfirmResponseScreen' : (BuildContext ctx) => ConfirmScreen(),
              '/newlistingOptionsScreen' : (BuildContext ctx) => OptionsScreen(),
            },
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

