import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile/StudentTabs/tab1_st.dart';
import 'Tabs/Tab1_BP.dart';
import 'Tabs/Tab2_BP.dart';
import 'Tabs/Tab3_BP.dart';

class BrandProfileScreen extends StatefulWidget{
  const BrandProfileScreen({Key? key}) : super(key: key);

  @override
  State<BrandProfileScreen> createState() => _BrandProfileScreenState();
}

class _BrandProfileScreenState extends State<BrandProfileScreen>
    with SingleTickerProviderStateMixin {
  String uid=LoginData().getUserId();
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
    _tabController = TabController(length: 3, vsync: this);
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
    return
    // StreamBuilder<DocumentSnapshot>(
    //     stream: FirebaseFirestore.instance
    //         .collection('Profiles')
    //         .doc(uid)
    //         .snapshots(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //       if (snapshot.hasError) {
    //         return Center(child: Text("Error: ${snapshot.error}"));
    //       }
    //       if (!snapshot.hasData || !snapshot.data!.exists) {
    //         return Center(child: Text("No data found"));
    //       }
    //       else{
    //         var data = snapshot.data!.data() as Map<String, dynamic>;
    //         var projectsList = (data['projects'] is List<dynamic>) ? List<dynamic>.from(data['projects']) : [];
    //         var workList = (data['Work Experience'] is List<dynamic>) ? List<dynamic>.from(data['Work Experience']) : [];


            // return
              Scaffold(
                backgroundColor: Colors.white,

              body: Material(
                // child:
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          backgroundColor: Colors.white,
                          expandedHeight: 200,
                          floating: true,
                          pinned: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background:

                            StreamBuilder<DocumentSnapshot>(
                              stream:FirebaseFirestore.instance
                                  .collection('brandProfiles')
                                  .doc(uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text("No data found"));
                      }
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      String userName=data['brandName'];
                      List<String> userDescriptionList = (data['userDescription'] is List<dynamic>)
                      ? List<String>.from(data['brandDescription'].map((item) => item.toString()))
                          : [];
                      String descriptionsWithBullets = userDescriptionList.join('  •  ');
                     return Column(
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
                                const Material(
                                  elevation: 4,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.none,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(
                                            "https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w"),
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/Global.svg", height: 20, width: 20,),
                                        const Text(
                                          "Website",
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/Letter.png", height: 20, width: 20,),
                                        const Text(
                                          "Email",
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
                                      width: 28,
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
                              child: const Row(
                                children: [
                                  Text(
                                    "Gucci • ",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0f1015),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Student",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffababab),
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )
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
                      );
                      }),

                          ),
                        ),
                      DefaultTabController(
                      length: 3,
                          child: SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                controller: _tabController,
                                labelColor: Colors.black,
                                indicatorColor: Colors.black,
                                tabs: [
                                  Tab(
                                    icon: SvgPicture.asset("assets/tab1_bp.svg", color: _tabSelectedState[0] ? Colors.black : Colors.grey, )
                                    // child: _tabSelectedState[0]
                                    //     ? SvgPicture.asset(
                                    //   "assets/tab1_st_s.svg",
                                    // )
                                    //     : SvgPicture.asset(
                                    //   "assets/tab1_st_un.svg",
                                    // ),
                                  ),
                                  Tab(
                                    icon: SvgPicture.asset("assets/tab2_bp.svg", color: _tabSelectedState[1] ? Colors.black : Colors.grey, ),
                                    // child: _tabSelectedState[1]
                                    //     ? SvgPicture.asset(
                                    //   "assets/tab2_s.svg",
                                    // )
                                    //     : SvgPicture.asset(
                                    //   "assets/tab2_un.svg",
                                    // ),
                                  ),

                                  Tab(
                                    icon: SvgPicture.asset("assets/tab3_bp.svg", color: _tabSelectedState[2] ? Colors.black : Colors.grey, ),

                                    // child: _tabSelectedState[2]
                                    //     ? SvgPicture.asset(
                                    //   "assets/tab4_s.svg",
                                    // )
                                    //     : SvgPicture.asset(
                                    //   "assets/tab4_un.svg",
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children:  [
                        const Tab1_BP(),
                        // tabThree(),
                        // tabFour(),
                        // Container(),
                        BrandListingsTab(),
                        // Container(),
                        RequestsTab(),
                      ],
                    ),
                  ),
                // ),
              ),
            );
        //   }
        //
        // }
    // );
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
