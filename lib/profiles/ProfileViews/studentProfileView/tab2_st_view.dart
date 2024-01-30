import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Models/ProfileModels/brandModel.dart';
import 'package:lookbook/App%20Constants/pfpClass.dart';
import 'package:lookbook/Common%20Widgets/common_widgets.dart';
import 'package:rxdart/rxdart.dart';
import '../../../App Constants/usedFunctions.dart';
import '../../../Preferences/LoginData.dart';
import '../../../Services/profiles.dart';
import '../../../screens/jobs/job_model.dart';
import '../../ProfileViews/brandProfileView/brandProfileView.dart';
import '../../studentProfile/StudentTabs/tab3_st.dart';


class Tab2StView extends StatefulWidget {
  const Tab2StView({super.key});

  @override
  State<Tab2StView> createState() => _Tab2StViewState();
}

class _Tab2StViewState extends State<Tab2StView> with TickerProviderStateMixin{

  late TabController _tabController;
  //fetchBookmarkedBrandProfilesStream
  late Stream<List<BrandProfile>> profileInfoStream;
  late Stream<List<jobModel>> jobListingsStream;
  late Stream<ListingAndProfiles> combinedStream;

  Stream<ListingAndProfiles> fetchAllData() {
    Stream<List<BrandProfile>> profileInfoStream = ProfileServices().fetchBookmarkedBrandProfilesStream();
    Stream<List<jobModel>> jobListingsStream = ProfileServices().streamBookMarkedJobListings();

    return Rx.combineLatest2(
      profileInfoStream,
      jobListingsStream,
          (List<BrandProfile> brandProfiles, List<jobModel> jobModels) {
        return ListingAndProfiles(brandProfiles: brandProfiles, jobModels: jobModels, studentProfiles: []);
      },
    );
  }



  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    profileInfoStream=ProfileServices().fetchBookmarkedBrandProfilesStream();
    jobListingsStream=ProfileServices().streamBookMarkedJobListings();
    combinedStream=fetchAllData();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            elevation: 1,
            child: TabBar(

              controller: _tabController,
              tabs: [
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: Text(
                          "Saved Profiles",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        )),
                  ),
                ),
                Tab(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: Text(
                          "Saved Listings",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.left,
                        )),
                  ),
                ),
              ],
              indicatorColor: Colors.transparent,
              labelColor: const Color(0xff282828),
              unselectedLabelColor: const Color(0xff9D9D9D),
            ),
          ),

          StreamBuilder<ListingAndProfiles>(
              stream: combinedStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No data available');
                }
                else{
                  List<BrandProfile> profiles = snapshot.data!.brandProfiles;
                  List<jobModel> jobListings=snapshot.data!.jobModels;
                  return Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                          ),
                          padding: EdgeInsets.all(4),
                          child:
                          ListView.builder(
                            itemCount: profiles.length,
                            itemBuilder: (context, index) {
                              BrandProfile profile = profiles[index];
                              return JobCard(brandProfile: profile,);
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                          ),
                          padding: EdgeInsets.all(4),
                          child:
                          ListView.builder(
                            itemCount: jobListings.length,
                            itemBuilder: (context, index) {
                              jobModel listing = jobListings[index];
                              return BuildCustomJobCard(listing: listing,);
                            },
                          ),
                        ),
                      ],
                    ),
                  );

                }
              }
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatefulWidget {
  final BrandProfile brandProfile;
  JobCard({
    required this.brandProfile,
  });
  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBookmarked=true;



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return BrandProfileView(brandProfile: widget.brandProfile);
        }));
      },
      child: Card(
        elevation: 4.w,
        shadowColor: Colors.grey.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            gradient: const LinearGradient(
              colors: [
                Colors.white,
                Colors.white70,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BrandProfilePicRadiusClass(imgUrl: widget.brandProfile.brandProfilePicture, radius: 48.r),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.brandProfile.brandName,
                        style:  TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0f1015),
                          height: 21/14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        DisplayFunctions().concatToDisplay(widget.brandProfile.brandDescription, 3),
                        style:  TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3f3f3f),
                          height: 21/13,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "${widget.brandProfile.numberOfApplications} Job openings ${widget.brandProfile.location.isNotEmpty?",${widget.brandProfile.location}" : ""}",
                        style:  TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8a8a8a),
                          height: 19/13,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.h),
                  child: GestureDetector(
                    onTap: () {
                      setState((){
                        isBookmarked = !isBookmarked;
                      });
                      if(isBookmarked){
                        ProfileServices().bookmarkBrandProfile(LoginData().getUserId(),widget.brandProfile.userId);
                      }
                      else{
                        ProfileServices().removeBookmarkedBrandProfile(LoginData().getUserId(),widget.brandProfile.userId);
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.bookmark,
                        color: isBookmarked ? Colors.black : Colors.white,
                        size: 24.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
