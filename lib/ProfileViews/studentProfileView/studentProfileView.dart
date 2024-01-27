import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/HomeScreen/studentModel.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/ProfileViews/studentProfileView/tab1_st_view.dart';
import 'package:lookbook/colorManager.dart';
import 'package:shimmer/shimmer.dart';

import '../../launchingFunctions.dart';

class StudentProfileView extends StatefulWidget{
  final StudentProfile studentProfile;
  const StudentProfileView({Key? key, required this.studentProfile}) : super(key: key);

  @override
  State<StudentProfileView> createState() => _StyudentProfileViewState();
}

class _StyudentProfileViewState extends State<StudentProfileView>
    with SingleTickerProviderStateMixin {
  List gridItems = [];
  String uid=LoginData().getUserId();
  bool isDataLoading=true;
  late TabController _tabController;
  List<bool> _tabSelectedState = [true,false];// Initially, the first tab is selected
  late Stream<DocumentSnapshot> profileInfoStream;
  String descriptionsWithBullets="";

  @override
  void initState() {
    List<String> userDescriptionList = widget.studentProfile.userDescription!;
    descriptionsWithBullets = userDescriptionList.join('  •  ');
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    // profileInfoStream=getStudentProfileStream(uid);
    super.initState();
  }

  void _handleTabChange() {
    setState(() {
      // Reset all tab selected states to false
      _tabSelectedState = [false,false];
      // Set the selected tab's state to true
      _tabSelectedState[_tabController.index] = true;
    });
  }



  @override
  Widget build(BuildContext context) {
            return Scaffold(
              body: Material(
                child: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          leading: Container(),
                          backgroundColor: Colors.white,
                          expandedHeight: 310,
                          floating: true,
                          pinned: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppBar(
                                  leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,), onPressed: (){
                                    Navigator.of(context).pop();
                                  },),
                                  backgroundColor: Colors.white,
                                  title: const Text(
                                    "Profile",
                                    style:  TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff0f1015),
                                      height: 20/16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3.0),
                                        child: Material(
                                          elevation: 4,
                                          shape: const CircleBorder(),
                                          clipBehavior: Clip.none,
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: widget.studentProfile.userProfilePicture!.isNotEmpty? Colors.white : Colors.transparent,
                                            child: widget.studentProfile.userProfilePicture != null && widget.studentProfile.userProfilePicture!.isNotEmpty
                                                ? CachedNetworkImage(
                                              imageUrl: widget.studentProfile.userProfilePicture!, // Actual image URL
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                                radius: 40,
                                                backgroundImage: imageProvider,
                                              ),
                                            )
                                                : CircleAvatar( // Fallback to asset image
                                              radius: 40,
                                              backgroundColor: Colors.transparent,
                                              child: SvgPicture.asset("assets/devil.svg", fit: BoxFit.cover,height: 70,), // Provide the path to your asset image
                                            ),
                                          ),
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
                                      widget.studentProfile.projects!=null && widget.studentProfile.projects!.length!=0? widget.studentProfile.projects!.length.toString() : "0",
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
                                                widget.studentProfile.workExperience!=null && widget.studentProfile.workExperience!.length!=0? widget.studentProfile.workExperience!.length.toString() : "0",
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
                                          InkWell(
                                            onTap: (){
                                              LaunchingFunction().bottomSheet(
                                                  context: context,
                                                  userPhoneNumber: widget.studentProfile.phoneNumber!,
                                                  userFaceBook: widget.studentProfile.userFacebook ?? "",
                                                  userTwitter: widget.studentProfile.userTwitter ?? "",
                                                  userInsta: widget.studentProfile.userInsta ?? "",
                                                  userLinkedIn: widget.studentProfile.userLinkedin ?? "",
                                                  userGmail: widget.studentProfile.userEmail!
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
                                          "Hey,\nI’m ${widget.studentProfile.firstName} ${widget.studentProfile.lastName}",
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

                                Container(
                                    margin: const EdgeInsets.only(top: 8, left: 11),
                                    child:  Text(
                      widget.studentProfile.userBio?? "No Description yet!",
                                      style:const TextStyle(
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
                                    child:  SvgPicture.asset("assets/tab1_st_s.svg",color: _tabSelectedState[0] ?Colors.black : ColorsManager.unSelectedTabColor,)),
                                Tab(
                                    child:  SvgPicture.asset("assets/tab4_s.svg",color: _tabSelectedState[0] ?Colors.black : ColorsManager.unSelectedTabColor,)),

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
                         Tab1StView(studentProfile: widget.studentProfile,),
                        // tabThree(),
                        // tabFour(),
                        // Tab2St(),
                        Container(),
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
