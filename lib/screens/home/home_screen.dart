import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:lookbook/screens/lookbook/lookbook_screen.dart';
import 'package:lookbook/screens/listing/listing_screen.dart';
import 'package:lookbook/screens/search/HomePage.dart';
import 'package:lookbook/screens/search/search_screen.dart';
import 'package:lookbook/screens/profile/profile_screen.dart';
import 'package:lookbook/widgets/custom_icon.dart';
import 'package:lookbook/widgets/status_bar_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  var _selected = 0;
  late TabController _tabController;

  /// Select bottom nav item
  _select(int indx) {
    setState(() => _selected = indx);
    _tabController.animateTo(indx);
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => _select(_tabController.index));
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selected = index;
    });
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
      bottomNavigationBar: SizedBox(
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
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
