import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/HomeScreen/brandModel.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'Tabs/Tab1_BP.dart';
import 'Tabs/Tab2_BP.dart';
import 'Tabs/Tab3_BP.dart';
import 'editBrandProfile.dart';

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
 late Stream <DocumentSnapshot> brandProfileStream;
  late final Stream<bool> isAnyListingUnclicked;
  late BrandProfile brandProfile;

  Stream<bool> isAnyListingUnclickedStream() {
    CollectionReference collection = FirebaseFirestore.instance.collection('jobListing');
    return collection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      // Check each document to see if 'clicked' field is false
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && !(data['clicked'] as bool? ?? true)) {
          return true; // If any document has 'clicked' as false, return true
        }
      }
      return false; // If none have 'clicked' as false, return false
    });
  }

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
    isAnyListingUnclicked=isAnyListingUnclickedStream();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    brandProfileStream=FirebaseFirestore.instance
        .collection('brandProfiles')
        .doc(uid)
        .snapshots();
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
      DefaultTabController(
        length: 3,
                child: Scaffold(
                  backgroundColor: Colors.white,

                body: Material(
                  // child:
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            backgroundColor: Colors.white,
                            expandedHeight: 270,
                            floating: true,
                            pinned: false,
                            flexibleSpace: FlexibleSpaceBar(
                              background:
                              StreamBuilder<DocumentSnapshot>(
                                stream:brandProfileStream,
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
                        brandProfile = BrandProfile.fromMap(data);
                        List<String> userDescriptionList = (data['brandDescription'] is List<dynamic>)
                        ? List<String>.from(data['brandDescription'].map((item) => item.toString()))
                            : [];

                        String userProfilePic=data['brandProfilePicture'];
                        String userBio=data['brandBio'];

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
                                              : ClipRRect(
                                            borderRadius: BorderRadius.circular(40),
                                                child: Image.asset("assets/brand.png",
                                                                                          width: 80,
                                                                                          height: 80,
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                              )
                                        ),

                                        GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                              return EditBrandProfile(brandProfile: brandProfile,);
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
                                child:  Row(
                                  children: [
                                    Text(
                                      "Hey,\nWe are $userName",
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
                                // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                //   return EditProfile(studentProfile: studentProfile,);
                                // }));
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
                        );
                        }),

                            ),
                          ),
                          StreamBuilder<bool>(
                            stream: isAnyListingUnclicked,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (snapshot.hasError) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Text("Error: ${snapshot.error}"),
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Text("No data found"),
                                  ),
                                );
                              }
                              bool IsAnyUnclicked=snapshot.data!;
                                  return SliverPersistentHeader(
                                    delegate: _SliverAppBarDelegate(
                                      TabBar(
                                        controller: _tabController,
                                        labelColor: Colors.black,
                                        indicatorColor: Colors.black,
                                        tabs: [
                                          Tab(
                                            icon: SvgPicture.asset("assets/tab1_bp.svg", color: _tabSelectedState[0] ? Colors.black : Colors.grey),
                                          ),
                                          Tab(
                                            icon: Stack(
                                              clipBehavior: Clip.none, // Allows the dot to be positioned out of the bounds of the icon
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/tab2_bp.svg",
                                                  color: _tabSelectedState[1] ? Colors.black : Colors.grey,
                                                ),
                                                if (IsAnyUnclicked)
                                                  Positioned(
                                                    right: -3, // Adjust the position as needed
                                                    top: -3, // Adjust the position as needed
                                                    child: Container(
                                                      width: 6, // Size of the dot
                                                      height: 6, // Size of the dot
                                                      decoration: BoxDecoration(
                                                        color: Colors.red, // Color of the dot
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.white, // Color of the border around the dot
                                                          width: 1, // Width of the border around the dot
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Tab(
                                            icon: SvgPicture.asset("assets/tab3_bp.svg", color: _tabSelectedState[2] ? Colors.black : Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    pinned: true,
                                  );
                            },
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
    // Rebuild the SliverAppBarDelegate whenever its content changes
    return oldDelegate._tabBar != _tabBar;
  }
}

