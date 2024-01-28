import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/HomeScreen/brandModel.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Services/profiles.dart';
import 'package:lookbook/screens/profile/profileModels/educationModel.dart';
import 'package:lookbook/screens/profile/profileModels/workModel.dart';
import 'package:shimmer/shimmer.dart';
import 'HomeScreen/studentModel.dart';
import 'ProfileViews/brandProfileView/brandProfileView.dart';
import 'ProfileViews/studentProfileView/studentProfileView.dart';

class NewHomeScreen extends StatefulWidget{
  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  late Future<List<StudentProfile>> futureList;
  late Future<List<BrandProfile>> brandList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureList= fetchStudentProfiles();
    brandList=fetchBrandProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              SizedBox(height: 16,),
              Row(
                children: [
                  SizedBox(width: 5,),
                  SvgPicture.asset("assets/devil.svg"),
                  SizedBox(width: 9,),
                   Text(
                    "The Devil Wears",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
          bottom:   TabBar(
            unselectedLabelColor: Color(0xff9D9D9D),
            labelColor: Color(0xff000000),
            indicatorColor: Colors.black,
            tabs: [
              Tab(child: Text(
                "Explore Talents",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 24/16,
                ),
                textAlign: TextAlign.left,
              ),),
              Tab(child: Text(
                "Explore opportunities",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 24/16,
                ),
                textAlign: TextAlign.left,
              ),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TalentGrid(futureList: futureList,),
            OpportunitiesGrid(futureList: brandList,),
          ],
        ),
      ),
    );
  }
}

class TalentGrid extends StatefulWidget {
  final Future<List<StudentProfile>> futureList;

  TalentGrid({Key? key, required this.futureList}) : super(key: key);
  @override
  State<TalentGrid> createState() => _TalentGridState();
}

class _TalentGridState extends State<TalentGrid> {

  String formatCompanyNames(List<WorkModel>? workExperience, {int maxDisplay = 1}) {
    if (workExperience == null || workExperience.isEmpty) {
      return 'No Companies';
    }
    String allCompanies = workExperience.map((e) => e.companyName).join(', ');
    List<String> companyList = allCompanies.split(', ');
    if (companyList.length <= maxDisplay) {
      return allCompanies;
    } else {
      String displayedCompanies = companyList.take(maxDisplay).join(', ');
      int remainingCount = companyList.length - maxDisplay;
      return '$displayedCompanies, ...+${remainingCount}';
    }
  }

  String getLatestInstituteName(List<EducationModel>? educationList) {
    if (educationList == null || educationList.isEmpty) {
      return 'No Education Info';
    }
    educationList.sort((a, b) => b.timePeriod.compareTo(a.timePeriod));
    return educationList.first.instituteName;
  }

  List<StudentProfile> sortStudentProfiles(
      List<StudentProfile> profiles,
      List<String> currentUserJobProfiles,
      List<String> currentUserInterests
      ) {
    profiles.sort((a, b) {
      int scoreA = calculateProfileMatchScore(a, currentUserJobProfiles, currentUserInterests);
      int scoreB = calculateProfileMatchScore(b, currentUserJobProfiles, currentUserInterests);
      return scoreB.compareTo(scoreA);
    });
    return profiles;
  }

  int calculateProfileMatchScore(StudentProfile profile, List<String> jobProfiles, List<String> interests) {
    bool matchesJobProfile = jobProfiles.any((jobProfile) => profile.userDescription?.contains(jobProfile) ?? false);
    int matchingInterestsCount = profile.interestedOpportunities?.where((interest) => interests.contains(interest)).length ?? 0;
    if (matchesJobProfile && matchingInterestsCount > 0) {
      return 1000 + matchingInterestsCount;
    } else if (matchesJobProfile) {
      return 500;
    } else if (matchingInterestsCount > 0) {
      return 100 + matchingInterestsCount;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudentProfile>>(
      future: widget.futureList, // Assuming fetchStudentProfiles() is defined and returns a Future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return  GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 3 / 3.2,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return ShimmerTalentCard();
            },
          );
        } else if (snapshot.hasError) {
          // If we run into an error, display it to the user
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          // If there's no data, let the user know
          return Center(child: Text("No talents found."));
        }

        List<StudentProfile> profiles = snapshot.data!;
        profiles=sortStudentProfiles(profiles, LoginData().getUserJobProfile() ,LoginData().getUserInterests());
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 3 / 3.2,
          ),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            // Get the data for this index
            StudentProfile profile = profiles[index];
            String workString = formatCompanyNames(profile.workExperience);

            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return StudentProfileView(studentProfile: profile,);
                }));
              },
              child: TalentCard(
                // Pass the necessary data to the TalentCard
                name: "${profile.firstName ?? 'Unknown'} ${profile.lastName ?? ''}",
                designation: profile.userDescription?.join(" • ") ?? 'No description',
                company: workString,
                imageUrl: profile.userProfilePicture!.isNotEmpty? profile.userProfilePicture : "",
                education: profile.education!=null && profile.education!.isNotEmpty ? getLatestInstituteName(profile.education) : "No Education",
              ),
            );
          },
        );
      },
    );
  }
}

class TalentCard extends StatelessWidget {
  final String name;
  final String designation;
  final String company;
  final String? imageUrl;
  final String education;

  const TalentCard({
    Key? key,
    required this.name,
    required this.designation,
    required this.company,
    this.imageUrl,
    required this.education,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Determine the size of the avatar relative to the card
    final double avatarRadius = 48;
    final double avatarBorderWidth = 4; // Adjust the border width as needed

    return Container(
      margin: EdgeInsets.only(top: avatarRadius + avatarBorderWidth), // To push the entire card down
      child: Stack(
        clipBehavior: Clip.none, // Allows the avatar to overlap the card
        alignment: Alignment.topCenter,
        children: <Widget>[
          // The card background
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.only(
                top: avatarRadius + avatarBorderWidth + 8.h,
                bottom: 18.h,
                left: 16.w,
                right: 16.w,
              ),
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // SizedBox(height: 2), // Space for the avatar
                  RichText(
                    overflow: TextOverflow.ellipsis, // Prevent text from overflowing
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff0f1015), // default text color
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            // height: 18 / 12,
                          ),
                        ),
                        TextSpan(
                          text: ' • $designation',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff000000),
                            // height: 19 / 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),
                  Text(
                    company,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5d5d5d),
                      // height: 14/11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    education,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff8b8b8b),
                      // height: 14/11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // The avatar image
          Positioned(
            top: -(avatarRadius + avatarBorderWidth - 8.h),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: imageUrl!.isNotEmpty? Colors.white : Colors.transparent,
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: imageUrl!, // Actual image URL
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CircleAvatar(
                    radius: avatarRadius - avatarBorderWidth,
                    backgroundColor: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: avatarRadius - avatarBorderWidth,
                  backgroundImage: imageProvider,
                ),
              )
                  : CircleAvatar( // Fallback to asset image
                radius: avatarRadius - avatarBorderWidth,
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset("assets/devil.svg", fit: BoxFit.cover,height: 70,), // Provide the path to your asset image
              ),
            ),
          )


        ],
      ),
    );


  }
}


class OpportunitiesGrid extends StatelessWidget {
  final Future<List<BrandProfile>> futureList;
  OpportunitiesGrid({
    required this.futureList,
});

  @override
  Widget build(BuildContext context) {
    // Placeholder for the actual grid
    return FutureBuilder<List<BrandProfile>>(
      future: futureList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return  GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 3 / 3.2,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return ShimmerCustomCard();
            },
          );
        } else if (snapshot.hasError) {
          // If we run into an error, display it to the user
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          // If there's no data, let the user know
          return Center(child: Text("No talents found."));
        }

        List<BrandProfile> profiles = snapshot.data!;
        // profiles=sortStudentProfiles(profiles, LoginData().getUserJobProfile() ,LoginData().getUserInterests());
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 3 / 3.2,
          ),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            // Get the data for this index
            BrandProfile profile = profiles[index];
            // String workString = formatCompanyNames(profile.workExperience);

            return InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return BrandProfileView(brandProfile: profile,);
                }));
              },
              child: CustomCard(
           imageUrl:"https://cdn-academyblog.pressidium.com/wp-content/uploads/2020/01/fashion-abby-yang-spring-2020-collections-8.jpg",
           companyName: profile.brandName,
          companyType: profile.companyName,
            clothingType:profile.companyName,
           jobOpenings:profile.numberOfApplications,
          location:profile.location,
                brandId:profile.userId,
              ),
            );
          },
        );
      },
    );
  }
}


class CustomCard extends StatefulWidget {
  final String imageUrl;
  final String companyName;
  final String companyType;
  final String clothingType;
  final int jobOpenings;
  final String location;
  final String brandId;

  const CustomCard({
    Key? key,
    required this.imageUrl,
    required this.companyName,
    required this.companyType,
    required this.clothingType,
    required this.jobOpenings,
    required this.location,
    required this.brandId,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  double cornerRadius = 16; // Adjust as needed
  late bool isBookmarked;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(LoginData().getBookmarkedBrandProfiles());
     isBookmarked = LoginData().getBookmarkedBrandProfiles().contains(widget.brandId);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.h),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.companyName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0f1015),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${widget.companyType} • ${widget.clothingType}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3f3f3f),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${widget.jobOpenings} Job openings, ${widget.location}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8a8a8a),
                        ),
                      ),
                    ],
                  ),
                ),
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
                  ProfileServices().bookmarkBrandProfile(LoginData().getUserId(),widget.brandId);
                }
                else{
                  ProfileServices().removeBookmarkedBrandProfile(LoginData().getUserId(),widget.brandId);
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
    );
  }
}



class ShimmerTalentCard extends StatelessWidget {
  final double avatarRadius = 48;
  final double avatarBorderWidth = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: avatarRadius + avatarBorderWidth),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: <Widget>[
          // Shimmer effect for the card background
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 200, // Adjust the height as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Shimmer effect for the avatar image
          Positioned(
            top: -(avatarRadius + avatarBorderWidth - 8),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerCustomCard extends StatelessWidget {
  final double cornerRadius;

  const ShimmerCustomCard({
    Key? key,
    this.cornerRadius = 16, // Default corner radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126.h,
      margin: EdgeInsets.all(0.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 118.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(cornerRadius)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 40, // Adjust height as needed
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  // SizedBox(height: 8.0), // Adjust spacing as needed
                  // Shimmer.fromColors(
                  //   baseColor: Colors.grey[300]!,
                  //   highlightColor: Colors.grey[100]!,
                  //   child: Container(
                  //     height: 20, // Adjust height as needed
                  //     width: double.infinity,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // SizedBox(height: 8.0), // Adjust spacing as needed
                  // Shimmer.fromColors(
                  //   baseColor: Colors.grey[300]!,
                  //   highlightColor: Colors.grey[100]!,
                  //   child: Container(
                  //     height: 20, // Adjust height as needed
                  //     width: double.infinity,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

