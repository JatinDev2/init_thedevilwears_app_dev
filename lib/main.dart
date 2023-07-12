import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookbook/screens/home/home_screen.dart';
import 'package:lookbook/screens/listing/Details_Screen.dart';
import 'package:lookbook/screens/listing/FiltersScreen_Listing.dart';
import 'package:lookbook/screens/lookbook/lookbook_details_screen.dart';
import 'package:lookbook/screens/lookbook/lookbook_images_slider_screen.dart';
import 'package:lookbook/screens/lookbook/lookbook_image_details.dart';
import 'package:lookbook/screens/search/FiltersScreen.dart';

void main() {
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
        return MaterialApp(
          title: 'LookBook',
          theme: ThemeData(
            primaryColor: Colors.black,
            // useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          home: HomeScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == '/listingFilterScreen') {
              // Retrieve the arguments passed when navigating to '/listingFilterScreen'
              final arguments = settings.arguments as List<String>;

              return MaterialPageRoute(
                builder: (context) => FiltersScreen_Listing(selectedOptionsSourcing: arguments),
              );
            }
            // Handle other named routes here if needed
          },
          routes: <String, WidgetBuilder>{
            '/homeScreen': (BuildContext ctx) => HomeScreen(),
            '/lookbookDetailsScreen': (BuildContext ctx) => LookbookDetailsScreen(),
            '/lookbookImagesSliderScreen': (BuildContext ctx) => LookbookImagesSliderScreen(),
            '/lookbookImageDetailsScreen': (BuildContext ctx) => LookbookImageDetailsScreen(),
            '/searchFilterScreen': (BuildContext ctx) => FiltersScreen(),
            'listingDetailsScreen' : (BuildContext ctx) => Details_Screen(),
          },
          debugShowCheckedModeBanner: false,
        );

      },
    );
  }
}

