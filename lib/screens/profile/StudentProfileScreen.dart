import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../listing/response_screen.dart';
import 'StudentTabs/tab1_st.dart';
import 'editProfile/editProfileScreen.dart';

class StudentProfileScreen extends StatefulWidget{
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  List gridItems = [];
  String uid="";
  bool isDataLoading=true;
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
    fetchId().then((value) {
      setState(() {
        isDataLoading = false;
        uid = value;
      });
    });
    gridItems = GridItemData.generateItems();
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

  Future<String> fetchId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId!;
  }

  @override
  Widget build(BuildContext context) {
    return isDataLoading? Scaffold(body: Center(child: CircularProgressIndicator(),),) : StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Profiles')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        // if (!snapshot.hasData || !snapshot.data!.exists) {
        //   return Center(child: Text("No data found"));
        // }
else{
          var projectsList = <dynamic>[];
          var workList = <dynamic>[];

          // Check if the snapshot has data and is not null.
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            projectsList = (data['projects'] is List<dynamic>) ? List<dynamic>.from(data['projects']) : [];
            workList = (data['Work Experience'] is List<dynamic>) ? List<dynamic>.from(data['Work Experience']) : [];
          }
          // var data = snapshot.data!.data() as Map<String, dynamic> ?? {};
          // var projectsList = (data['projects'] is List<dynamic>) ? List<dynamic>.from(data['projects']) : [];
          // var workList = (data['Work Experience'] is List<dynamic>) ? List<dynamic>.from(data['Work Experience']) : [];

          return Scaffold(
            body: Material(
              child: DefaultTabController(
                length: 3,
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
                                          GestureDetector(
                                            onTap: (){
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                              //   return EditProfileScreen();
                                              // }));
                                            },
                                            child: Material(
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
                                            Text(
                                              projectsList.length.toString(),
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff000000),
                                                height: 20 / 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            const Text(
                                              "Projects",
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
                                            Text(
                                              workList.length.toString(),
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff000000),
                                                height: 20 / 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            const Text(
                                              "Work X",
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
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Srishti Doshi • ",
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
                                  "assets/tab1_st_s.svg",
                                )
                                    : SvgPicture.asset(
                                  "assets/tab1_st_un.svg",
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
                    children:  [
                      const Tab1St(),
                      // tabThree(),
                      // tabFour(),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

      }
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
