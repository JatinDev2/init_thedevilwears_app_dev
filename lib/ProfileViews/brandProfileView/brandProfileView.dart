import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/HomeScreen/brandModel.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/ProfileViews/brandProfileView/tab1_bt_view.dart';
import 'package:lookbook/ProfileViews/brandProfileView/tab2_bt_view.dart';
import 'package:shimmer/shimmer.dart';

class BrandProfileView extends StatefulWidget{
  final BrandProfile brandProfile;
  const BrandProfileView({Key? key, required this.brandProfile}) : super(key: key);

  @override
  State<BrandProfileView> createState() => _BrandProfileViewState();
}

class _BrandProfileViewState extends State<BrandProfileView>
    with SingleTickerProviderStateMixin {
  String uid=LoginData().getUserId();
  late TabController _tabController;
  List<bool> _tabSelectedState = [true, false, false]; // Initially, the first tab is selected
  String descriptionsWithBullets="";


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
    List<String> userDescriptionList = widget.brandProfile.brandDescription!;

    descriptionsWithBullets = userDescriptionList.join('  •  ');

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


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        body: Material(
          color: Colors.white,
          // child:
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 280,
                  floating: true,
                  leading: Container(),
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                    Column(
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
                                     Material(
                                      elevation: 4,
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.none,
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: widget.brandProfile.brandProfilePicture!.isNotEmpty? Colors.white : Colors.transparent,
                                        child: widget.brandProfile.brandProfilePicture != null && widget.brandProfile.brandProfilePicture!.isNotEmpty
                                            ? CachedNetworkImage(
                                          imageUrl: widget.brandProfile.brandProfilePicture!, // Actual image URL
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(40),
                                              child: Image.asset("assets/brand.png", fit: BoxFit.cover, height: 80, width: 80,)), // Provide the path to your asset image
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
                                        "Hey,\nWe are ${widget.brandProfile.brandName}",
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
                                    widget.brandProfile.brandBio.isNotEmpty ? widget.brandProfile.brandBio : "No Description yet!",
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
                          ),
                          Tab(
                            icon: SvgPicture.asset("assets/tab2_bp.svg", color: _tabSelectedState[1] ? Colors.black : Colors.grey, ),
                          ),

                          Tab(
                            icon: SvgPicture.asset("assets/tab3_bp.svg", color: _tabSelectedState[2] ? Colors.black : Colors.grey, ),
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
                 Tab1_BP_View(
                  onTap: (){
                    setState(() {
                      _tabController.index=1;
                    });
                  },
                ),
                // tabThree(),
                // tabFour(),
                // Container(),
                BrandListing_View(brandProfile: widget.brandProfile,),
                Container(),
                // RequestsTab(),
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
