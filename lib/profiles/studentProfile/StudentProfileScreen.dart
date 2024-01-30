import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/App%20Constants/colorManager.dart';
import '../../Models/ProfileModels/studentModel.dart';
import '../../App Constants/launchingFunctions.dart';
import 'StudentTabs/tab1_st.dart';
import 'StudentTabs/tab2_st.dart';
import 'StudentTabs/tab3_st.dart';
import 'edit_profile.dart';

class StudentProfileScreen extends StatefulWidget{
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  List gridItems = [];
  String uid=LoginData().getUserId();
  bool isDataLoading=true;
  late TabController _tabController;
  List<bool> _tabSelectedState = [true, false, false];// Initially, the first tab is selected
  late Stream<DocumentSnapshot> profileInfoStream;
  late StudentProfile studentProfile;


  @override
  void initState() {
    // fetchId().then((value) {
    //   setState(() {
    //     isDataLoading = false;
    //     uid = value;
    //   });
    // });
    // gridItems = GridItemData.generateItems();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    profileInfoStream=getStudentProfileStream(uid);
    super.initState();
  }

  void _handleTabChange() {
    setState(() {
      // Reset all tab selected states to false
      _tabSelectedState = [false, false, false];
      // Set the selected tab's state to true
      _tabSelectedState[_tabController.index] = true;
    });
  }

  // Future<String> fetchId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('userId');
  //   return userId!;
  // }
  Stream<DocumentSnapshot> getStudentProfileStream(String uid) {
    return FirebaseFirestore.instance
        .collection('studentProfiles')
        .doc(uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: profileInfoStream,
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
          var userDescriptionList=<dynamic>[];
          String userName="";
          String descriptionsWithBullets="";
          String userProfilePic="";
          String userBio="";

          // Check if the snapshot has data and is not null.
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            studentProfile = StudentProfile.fromMap(data);
            projectsList = (data['projects'] is List<dynamic>) ? List<dynamic>.from(data['projects']) : [];
            workList = (data['Work Experience'] is List<dynamic>) ? List<dynamic>.from(data['Work Experience']) : [];
            // userDescriptionList=(data['userDescription'] is List<dynamic>) ? List<dynamic>.from(data['userDescription']) : [];
            List<String> userDescriptionList = (data['userDescription'] is List<dynamic>)
                ? List<String>.from(data['userDescription'].map((item) => item.toString()))
                : [];
            userProfilePic= data["userProfilePicture"];

             descriptionsWithBullets = userDescriptionList.join('  •  ');

            userName="${data["firstName"]} ${data["lastName"]}";
            userBio=data["userBio"];

          }

          return Scaffold(
            body: Material(
              child: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        expandedHeight: 270,
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
                                            backgroundColor: Colors.transparent,
                                            child: (userProfilePic != null && userProfilePic.isNotEmpty)
                                                ? ClipOval(
                                              child: Image.network(
                                                userProfilePic,
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                              ),
                                            )
                                                : SvgPicture.asset(
                                              "assets/devil.svg",
                                              width: 80,
                                              height: 80,
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                                return EditProfile(studentProfile: studentProfile,);
                                              }));
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
                                           LaunchingFunction().bottomSheet(
                                               context: context,
                                               userPhoneNumber: studentProfile.phoneNumber!,
                                               userFaceBook: studentProfile.userFacebook!,
                                               userTwitter: studentProfile.userTwitter!,
                                               userInsta: studentProfile.userInsta!,
                                               userLinkedIn: studentProfile.userLinkedin!,
                                               userGmail: studentProfile.userEmail!
                                           );
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
                                  child:  Row(
                                    children: [
                                  Text(
                                  "Hey,\nI’m $userName",
                                  style: const TextStyle(
                                  fontFamily: "Poppins",
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff0f1015),
                                    // height: 48/24,
                                  ),
                                textAlign: TextAlign.left,
                              )
                                    ],
                                  )
                              ),
                              SizedBox(height: 8,),

                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Description'),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            descriptionsWithBullets,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                        shape: RoundedRectangleBorder( // Add this line
                                          borderRadius: BorderRadius.circular(10), // Adjust the radius
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 5, left: 11),
                                  child: Text(
                                    descriptionsWithBullets,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),


                              SizedBox(height: 8,),

                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                    return EditProfile(studentProfile: studentProfile,);
                                  }));
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(top: 5, left: 11),
                                    child:  Text(
                                        (userBio!=null && userBio.isNotEmpty) ? userBio : "How would you like to describe yourself?",
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff5a5a5a),
                                      ),
                                      textAlign: TextAlign.left,
                                    )),
                              ),
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
                                child:  SvgPicture.asset("assets/tab1_st_s.svg",color: _tabSelectedState[0] ?Colors.black : ColorsManager.unSelectedTabColor,)),
                              Tab(
                                child: SvgPicture.asset("assets/tab2_s.svg",color: _tabSelectedState[1]? Colors.black : ColorsManager.unSelectedTabColor,)),

                              Tab(
                                child: SvgPicture.asset(
                                  "assets/tab4_s.svg", color: _tabSelectedState[2]? Colors.black : ColorsManager.unSelectedTabColor,)
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
                      Tab2St(),
                      Tab3St(),
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
