import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../listing/response_screen.dart';
import 'Tabs/Tab_1.dart';
import 'Tabs/Tab_2.dart';
import 'Tabs/Tab_3.dart';
import 'Tabs/Tab_4.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  List gridItems = [];
  late TabController _tabController;
  List<bool> _tabSelectedState = [true, false, false, false]; // Initially, the first tab is selected

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Call",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0f1015),
                    height: 24 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 13),
                SvgPicture.asset("assets/phone.svg"),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Message",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0f1015),
                    height: 24 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 13),
                SvgPicture.asset("assets/whatsapp.svg"),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/facebook.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/twitter.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/instagram.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/linkedin.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/google.svg"),
              ],
            ),
            SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    gridItems = GridItemData.generateItems();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    super.initState();
  }

  void _handleTabChange() {
    setState(() {
      // Reset all tab selected states to false
      _tabSelectedState = [false, false, false, false];
      // Set the selected tab's state to true
      _tabSelectedState[_tabController.index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 200,
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Material(
                                elevation: 4,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.none,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                          "https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w"),
                                    ),
                                    Material(
                                      elevation: 4,
                                      shape: CircleBorder(),
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        margin: EdgeInsets.only(right: 2, bottom: 3),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/edit.svg",
                                            height: 16,
                                            width: 16,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   width: 48,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "10",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000),
                                          height: 20 / 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        "Lookbooks",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6b6b6b),
                                          height: 20 / 12,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "37",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000),
                                          height: 20 / 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        "Listings",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6b6b6b),
                                          height: 20 / 12,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      bottomSheet(context);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SvgPicture.asset(
                                          "assets/contact.svg",
                                          height: 16,
                                          width: 13,
                                        ),
                                        const Text(
                                          "Contact",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff6b6b6b),
                                            height: 20 / 12,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 11),
                          child: const Text(
                            "Sabyasachi",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0f1015),
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 5, left: 11),
                            child: const Text(
                              "Hello, I am a Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff5a5a5a),
                              ),
                              textAlign: TextAlign.left,
                            )),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(
                          child: _tabSelectedState[0]
                              ? SvgPicture.asset(
                            "assets/tab1_s.svg",
                          )
                              : SvgPicture.asset(
                            "assets/tab1_un.svg",
                          ),
                        ),
                        Tab(
                          child: _tabSelectedState[1]
                              ? SvgPicture.asset(
                            "assets/tab2_s.svg",
                          )
                              : SvgPicture.asset(
                            "assets/tab2_un.svg",
                          ),
                        ),
                        Tab(
                          child: _tabSelectedState[2]
                              ? SvgPicture.asset(
                            "assets/tab3_s.svg",
                          )
                              : SvgPicture.asset(
                            "assets/tab3_un.svg",
                          ),
                        ),
                        Tab(
                          child: _tabSelectedState[3]
                              ? SvgPicture.asset(
                            "assets/tab4_s.svg",
                          )
                              : SvgPicture.asset(
                            "assets/tab4_un.svg",
                          ),
                        ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                tabOne(),
                tabTwo(),
                tabThree(),
                tabFour(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
