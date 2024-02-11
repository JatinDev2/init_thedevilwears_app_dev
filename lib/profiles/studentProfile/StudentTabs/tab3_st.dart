import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Models/ProfileModels/brandModel.dart';
import 'package:lookbook/App%20Constants/pfpClass.dart';
import 'package:lookbook/Common%20Widgets/common_widgets.dart';
import 'package:lookbook/profiles/ProfileViews/studentProfileView/studentProfileView.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import '../../../App Constants/usedFunctions.dart';
import '../../../Models/ProfileModels/studentModel.dart';
import '../../../Preferences/LoginData.dart';
import '../../../Services/profiles.dart';
import '../../../screens/jobs/job_model.dart';
import '../../ProfileViews/brandProfileView/brandProfileView.dart';

class ListingAndProfiles {
  final List<BrandProfile> brandProfiles;
  final List<jobModel> jobModels;
  final List<StudentProfile> studentProfiles;

  ListingAndProfiles({required this.brandProfiles, required this.jobModels,required this.studentProfiles});
}

class ProfileWrapper {
  final BrandProfile? brandProfile;
  final StudentProfile? studentProfile;

  ProfileWrapper({this.brandProfile, this.studentProfile});
}


class Tab3St extends StatefulWidget {
  const Tab3St({super.key});

  @override
  State<Tab3St> createState() => _Tab3StState();
}

class _Tab3StState extends State<Tab3St> with TickerProviderStateMixin{

  late TabController _tabController;
  //fetchBookmarkedBrandProfilesStream
  late Stream<List<BrandProfile>> profileInfoStream;
  late Stream<List<jobModel>> jobListingsStream;
  late Stream<List<StudentProfile>> studentProfileStream;
  late Stream<ListingAndProfiles> combinedStream;


  Stream<ListingAndProfiles> fetchAllData() {
    Stream<List<BrandProfile>> profileInfoStream = ProfileServices().fetchBookmarkedBrandProfilesStream();
    Stream<List<jobModel>> jobListingsStream = ProfileServices().streamBookMarkedJobListings();
    Stream<List<StudentProfile>> studentProfileStream=ProfileServices().fetchBookmarkedStudentProfilesStream();

    return Rx.combineLatest3(
      profileInfoStream,
      jobListingsStream,
      studentProfileStream,
          (List<BrandProfile> brandProfiles, List<jobModel> jobModels,List<StudentProfile> studentProfiles) {
        return ListingAndProfiles(brandProfiles: brandProfiles.isNotEmpty? brandProfiles : [], jobModels: jobModels.isNotEmpty? jobModels: [], studentProfiles: studentProfiles.isNotEmpty? studentProfiles: [],);
      },
    );
  }



  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    profileInfoStream=ProfileServices().fetchBookmarkedBrandProfilesStream();
    jobListingsStream=ProfileServices().streamBookMarkedJobListings();
    studentProfileStream=ProfileServices().fetchBookmarkedStudentProfilesStream();
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
                }
                else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No data available');
                }
                else{
                  List<BrandProfile> profiles = snapshot.data!.brandProfiles;
                  List<StudentProfile> studentProfiles=snapshot.data!.studentProfiles;
                  List<dynamic> combinedList=[];
                  if(profiles.isNotEmpty && studentProfiles.isNotEmpty){
                    combinedList = []..addAll(profiles)..addAll(studentProfiles);
                  }
                  else if(profiles.isNotEmpty && studentProfiles.isEmpty){
                    combinedList=profiles;
                  }
                  else if(profiles.isEmpty && studentProfiles.isNotEmpty){
                    combinedList=studentProfiles;
                  }

                  combinedList.shuffle(Random());

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
                       physics: BouncingScrollPhysics(),
                      itemCount: combinedList.length,
                      itemBuilder: (context, index) {

                        var profile = combinedList[index];
                        if(profile.userType=="Company"){
                          return InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                  return BrandProfileView(brandProfile: profile);
                                }));
                              },
                              child: JobCard(brandProfile: profile,));
                        }
                        else{
                          String companies="";
                          String workedAs_profiles="";
                          String education="";

                          StudentProfile newProfile=profile;
                          if(newProfile.workExperience!=null && newProfile.workExperience!.isNotEmpty){
                            companies = newProfile.workExperience!.map((work) => work.companyName).join(
                                ', ');
                            workedAs_profiles=newProfile.workExperience!.map((work) => work.roleInCompany).join(
                                ', ');
                          }
                          else{
                            companies="Not Worked anywhere yet!";
                            workedAs_profiles="Not Worked anywhere yet!";
                          }
                          if(newProfile.education!=null && newProfile.education!.isNotEmpty){
                            education=newProfile.education!.map((edu) => edu.instituteName).join(
                                ', ');
                          }
                          else{
                            education="No education added yet!";
                          }

                          return  ProfileCard(
                            imageUrl: newProfile.userProfilePicture!,
                            name: "${newProfile.firstName} ${newProfile.lastName}",
                            jobProfile: newProfile.userDescription!.join(' • '),
                            workedWith: companies,
                            workedAs: workedAs_profiles,
                            education: education,
                            uid: newProfile.userId!,
                            studentProfile: profile,
                          );
                        }

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
                            physics: BouncingScrollPhysics(),
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
                      child:Icon(
                        isBookmarked
                            ? IconlyBold.bookmark
                            : IconlyLight.bookmark,
                        color: Colors.black,
                        size: 32.sp,
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


class ProfileCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String jobProfile;
  final String uid;
  final String workedWith;
  final String workedAs;
  final String education;
  final StudentProfile studentProfile;

  ProfileCard({
    required this.imageUrl,
    required this.name,
    required this.jobProfile,
    required this.workedWith,
    required this.workedAs,
    required this.education,
    required this.uid,
    required this.studentProfile
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late bool isBookmarked;
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    print(widget.uid);
    isBookmarked = LoginData().getBookmarkedStudentProfiles().contains(widget.uid);
    print(LoginData().getBookmarkedStudentProfiles());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return StudentProfileView(studentProfile: widget.studentProfile);
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  StudentProfilePicClassRadiusClass(imgUrl: widget.imageUrl, radius: 32.r),
                    const SizedBox(width: 12),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.name,
                                style:  TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff0f1015),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    String deepLink =
                                        'myapp://next_page';

                                    Share.share('Check out this listing: $deepLink',
                                        subject: 'Listing Details');
                                  },
                                  child:  Icon(IconlyLight.send,size: 32.sp,)),
                              SizedBox(width: 16,),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isBookmarked = !isBookmarked;
                                  });
                                  if (isBookmarked) {
                                    print("hihihi");
                                    ProfileServices().bookmarkStudentProfile(LoginData().getUserId(),widget.uid);
                                    _animationController.forward();
                                  } else {
                                    print("klkk");
                                    ProfileServices().removeBookmarkedStudentProfile(LoginData().getUserId(),widget.uid);
                                    _animationController.reverse();
                                  }
                                },
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (_, Widget? child) {
                                    return Icon(
                                      isBookmarked
                                          ? IconlyBold.bookmark
                                          : IconlyLight.bookmark,
                                      color: Colors.black,
                                      size: 32.sp,
                                    );
                                  },
                                ),
                              ),
                                  // Icon(
                                  //   // isBookmarked
                                  //   //     ?
                                  // IconlyBold.bookmark,
                                  //       // : IconlyLight.bookmark,
                                  //   color: Colors.black,
                                  // ),
                            ],
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
                                        widget.jobProfile,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        // overflow: TextOverflow.ellipsis,
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
                            child: Text(
                                DisplayFunctions().concatToDisplay(widget.jobProfile.split(' • '),2),
                              style:  TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff616161),
                              // height: 19/12,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6,),
                _buildInfoSection('Worked with:', widget.workedWith),
                SizedBox(height: 6,),
                _buildInfoSection('Worked as:', widget.workedAs),
                SizedBox(height: 6,),
                _buildInfoSection('Education', widget.education),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style:  TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xffadadad),
            height: 19/12,
          ),
        ),
        // SizedBox(height: 1.h),
        Text(items,style:  TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xff000000),
          height: 21/12,
        ),),
      ],
    );
  }
}
