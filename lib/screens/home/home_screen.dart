import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/screens/lookbook/lookbook_screen.dart';
import 'package:lookbook/screens/listing/listing_screen.dart';
import 'package:lookbook/screens/search/search_screen.dart';
import 'package:lookbook/screens/profile/profile_screen.dart';
import 'package:lookbook/widgets/custom_icon.dart';
import 'package:lookbook/widgets/status_bar_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../listing/response_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  var _selected = 0;
  late TabController _tabController;

  List gridItems = [];
  bool isPopupVisible = false;

  void togglePopup(){
    setState(() {
      isPopupVisible = !isPopupVisible;
    });
  }
  /// Select bottom nav item
  _select(int indx) {
    setState(() => _selected = indx);
    _tabController.animateTo(indx);
  }

  @override
  void initState() {
    setSharedPrefrence();
    gridItems = GridItemData.generateItems();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => _select(_tabController.index));
    super.initState();
  }

  void setSharedPrefrence()async{
    final prefs = await SharedPreferences.getInstance(); // Obtain SharedPreferences instance
    await prefs.setBool('isHomePage', true);
  }


  void _onItemTapped(int index) {
    setState(() {
      _selected = index;
    });
  }

  void bottomSheet(BuildContext context) async{
   await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          )
        ),
        context: context, builder: (context) =>
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 26,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Call",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0f1015),
                      height: 24/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 13,),
                  SvgPicture.asset("assets/phone.svg"),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Message",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0f1015),
                      height: 24/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 13,),
                  SvgPicture.asset("assets/whatsapp.svg"),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/facebook.svg"),
                  SizedBox(width: 24,),
                  SvgPicture.asset("assets/twitter.svg"),
                  SizedBox(width: 24,),
                  SvgPicture.asset("assets/instagram.svg"),
                  SizedBox(width: 24,),
                  SvgPicture.asset("assets/linkedin.svg"),
                  SizedBox(width: 24,),
                  SvgPicture.asset("assets/google.svg"),
                ],
              ),
              SizedBox(height: 26,),
            ],
          ),
        )
    );
   togglePopup();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabItems = [
      LookbookScreen(),
      SearchScreen(
        height: MediaQuery.of(context).viewInsets.bottom > 0 ? MediaQuery.of(context).size.height : 0,
      ),
      ListingScreen(),
      ProfileScreen()
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StatusBarAppBar(),
      body: _tabItems[_selected],
      bottomNavigationBar: !isPopupVisible?SizedBox(
        height: 70,
        child: BottomNavigationBar(
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(IconlyLight.home),
              activeIcon: CustomIcon(selectedIcon: IconlyBold.home),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(IconlyLight.search),
              activeIcon: CustomIcon(selectedIcon: IconlyBold.search),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(IconlyLight.document),
              activeIcon: CustomIcon(selectedIcon: IconlyBold.document),
              label: '',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(IconlyLight.profile),
              activeIcon: CustomIcon(selectedIcon: IconlyBold.profile),
              label: '',
            ),
          ],
          currentIndex: _selected,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color(0xFF0F1015),
          onTap: _onItemTapped,
          // type: BottomNavigationBarType.fixed,
        ),
      ) :  null,
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
