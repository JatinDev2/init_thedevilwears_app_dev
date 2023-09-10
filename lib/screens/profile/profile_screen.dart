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

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{
  List gridItems = [];
  late TabController _tabController;
  List<bool> _tabSelectedState = [true, false, false, false]; // Initially, first tab is selected

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
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
                SizedBox(
                  width: 48,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
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
                    SizedBox(
                      width: 32,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
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
                    SizedBox(
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
            child: Text(
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
              margin: EdgeInsets.only(top: 5, left: 11),
              child: Text(
                "Hello, I am a Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff5a5a5a),
                ),
                textAlign: TextAlign.left,
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            // color: Colors.blue,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black, // Set the selected tab label color
              indicatorColor: Colors.black, // Set the indicator color
              tabs: [
                Tab(
                  child: _tabSelectedState[0]?  SvgPicture.asset(
                    "assets/tab1_s.svg",
                  ) :  SvgPicture.asset(
                    "assets/tab1_un.svg",
                  ),
                ),
                Tab(
                  child: _tabSelectedState[1]?  SvgPicture.asset(
                    "assets/tab2_s.svg",
                  ) :  SvgPicture.asset(
                    "assets/tab2_un.svg",
                  ),
                ), Tab(
                  child: _tabSelectedState[2]?  SvgPicture.asset(
                    "assets/tab3_s.svg",
                  ) :  SvgPicture.asset(
                    "assets/tab3_un.svg",
                  ),
                ), Tab(
                  child: _tabSelectedState[3]?  SvgPicture.asset(
                    "assets/tab4_s.svg",
                  ) :  SvgPicture.asset(
                    "assets/tab4_un.svg",
                  ),
                ),// Replace with your desired tab labels
                // Tab(
                //   child:SvgPicture.asset("assets/tab2_un.svg") ,
                // ),
                // Tab(
                //   child: SvgPicture.asset("assets/tab3_un.svg"),
                // ),
                // Tab(
                //   child: SvgPicture.asset("assets/tab4_un.svg"),
                // ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                tabOne(),
                tabTwo(),
                tabThree(),
                tabFour(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
