import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lookbook/Services/profiles.dart';
import 'package:lookbook/App%20Constants/colorManager.dart';
import 'package:lookbook/screens/jobs/job_model.dart';
import 'package:lookbook/screens/jobs/listingDetailsScreen.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import '../Preferences/LoginData.dart';
import '../App Constants/pfpClass.dart';
import '../screens/jobs/Applications/previewApplication.dart';
import '../screens/jobs/Applications/viewApplicationsScreen.dart';


// ----------------------------------Building Columns in the Job Listing Card-----------------------------------------------
class BuildInfoColumns extends StatelessWidget {
  final String heading_text;
  final String info_text;

  BuildInfoColumns({
    required this.heading_text,
    required this.info_text,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40,
        child: Column(
          children: [
            Text(
              heading_text,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff9a9a9a),
                height: 18 / 12,
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(4.0),
                child: Text(
                  info_text,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff424242),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ----------------------------------Building Job Listing Card-----------------------------------------------------------
class BuildCustomJobCard extends StatefulWidget {
  final jobModel listing;

  const BuildCustomJobCard({
    super.key,
    required this.listing,
  });

  @override
  State<BuildCustomJobCard> createState() => _BuildCustomJobCardState();
}

class _BuildCustomJobCardState extends State<BuildCustomJobCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late bool isBookmarked;
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // Initialize the isBookmarked state
    // You will replace this with the actual bookmarked state from user's profile
    isBookmarked = LoginData().getBookmarkedJobListings().contains(widget.listing.docId);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
    if (isBookmarked) {
      ProfileServices().bookmarkJobListing(LoginData().getUserId(),widget.listing.docId);
      _animationController.forward();
    } else {
      ProfileServices().removeBookmarkedJobListing(LoginData().getUserId(),widget.listing.docId);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: InkWell(
        onTap: () {
          bool status =
              widget.listing.applicationsIDS.contains(LoginData().getUserId());
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return JobListingDetailsScreen(
                newJobModel: widget.listing, hasApplied: status);
          }));
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 18.h),
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: widget.listing.tags.map((option) {
                        return OptionChipDisplay(
                          title: option,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BrandProfilePicClass(
                    imgUrl: widget.listing.brandPfp,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    widget.listing.createdBy,
                    style: TextStyle(
                      // fontFamily: "Poppins",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff0f1015),
                      height: (20 / 18).h,
                    ),
                    textAlign: TextAlign.left,
                  )),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              margin: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
              color: const Color(0xffF9F9F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildInfoColumns(
                      heading_text: "Work Mode",
                      info_text: widget.listing.workMode),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 1.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(
                      heading_text: "Location",
                      info_text: widget.listing.officeLoc),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 1.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(
                      heading_text: "Stipend",
                      info_text: widget.listing.stipend != "Unpaid"
                          ? "${widget.listing.stipendAmount}${widget.listing.stipendVal}"
                          : "${widget.listing.stipend}"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Responsibilities ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2F2F2F),
                      ),
                      children: [
                        TextSpan(
                          // text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                          // text: "}"
                          text: widget.listing.responsibilities,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff424242),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        getTimeAgo(widget.listing.createdAt),
                        // "37 Mins ago",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8b8b8b),
                          height: (18 / 12).h,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            // // Create a shareable link to the Details_Screen for the specific listing
                            // String listingId = listing.userId!; // Replace with the actual ID of the listing
                            // String shareableLink = 'https://in.lookbook.lookbook/details/$listingId';
                            // // Use the url_launcher package to open the share dialog
                            // launch(shareableLink);

                            // Create a deep link to the next page in your app
                            String deepLink =
                                'myapp://next_page'; // Replace with your actual deep link structure

                            // Share the deep link using the share package
                            Share.share('Check out this listing: $deepLink',
                                subject: 'Listing Details');
                          },
                          icon: const Icon(IconlyLight.send)),
                      IconButton(
                        onPressed: toggleBookmark,
                        icon: AnimatedBuilder(
                          animation: _animationController,
                          builder: (_, Widget? child) {
                            return Icon(
                              isBookmarked
                                  ? IconlyBold.bookmark
                                  : IconlyLight.bookmark,
                              color: Colors.black,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo(String timestampString) {
    // Convert the Firestore timestamp string to a DateTime
    DateTime timestamp = DateTime.parse(timestampString);

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the time difference
    Duration difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // Format the timestamp in a custom way if it's more than a week ago
      String formattedDate = DateFormat('MMM d, yyyy').format(timestamp);
      return 'on $formattedDate';
    }
  }
}



// ----------------------------------Building Job Listing Card for Brand View-----------------------------------------------------------
class BuildCustomBrandJobListingCard extends StatelessWidget {
  final jobModel listing;

  const BuildCustomBrandJobListingCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return JobListingDetailsScreen(
              newJobModel: listing,
              hasApplied: false,
            );
          }));
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: listing.tags.map((option) {
                        return OptionChipDisplay(
                          title: option,
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BrandProfilePicClass(
                    imgUrl: listing.brandPfp,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    listing.createdBy,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff0f1015),
                      height: (20 / 18).h,
                    ),
                    textAlign: TextAlign.left,
                  )),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              color: const Color(0xffF9F9F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildInfoColumns(
                      heading_text: "Work Mode", info_text: listing.workMode),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 2.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(
                      heading_text: "Location", info_text: listing.officeLoc),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 2.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(
                      heading_text: "Stipend",
                      info_text: listing.stipend != "Unpaid"
                          ? "${listing.stipendAmount}${listing.stipendVal}"
                          : "${listing.stipend}"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Responsibilities ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2F2F2F),
                      ),
                      children: [
                        TextSpan(
                          // text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                          // text: "}"
                          text: listing.responsibilities,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xff424242),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        getTimeAgo(listing.createdAt),
                        // "37 Mins ago",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8b8b8b),
                          height: (18 / 12).h,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      if (!listing.clicked)
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0.h, horizontal: 8.0.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(14.0.r),
                          ),
                          child: Text(
                            "New",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: (20 / 13).h,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      SizedBox(
                        width: 5.w,
                      ),
                      if (LoginData().getUserType() != "Person")
                        InkWell(
                          onTap: () {
                            if (!listing.clicked) {
                              print("Yo i was tapped");
                              FirebaseFirestore firestore =
                                  FirebaseFirestore.instance;
                              DocumentReference docRef = firestore
                                  .collection('jobListing')
                                  .doc(listing.docId);
                              // Update the 'clicked' field of this document
                              docRef.update({'clicked': true}).then((_) {
                                print('Document successfully updated');
                              }).catchError((error) {
                                // Handle any errors here
                                print('Error updating document: $error');
                              });
                            }
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return AllAplicationsScreen(
                                jobId: listing.docId,
                              );
                            }));
                          },
                          child: Text(
                            "${listing.applicationCount} Applications",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                              height: (20 / 13).h,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo(String timestampString) {
    // Convert the Firestore timestamp string to a DateTime
    DateTime timestamp = DateTime.parse(timestampString);

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the time difference
    Duration difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // Format the timestamp in a custom way if it's more than a week ago
      String formattedDate = DateFormat('MMM d, yyyy').format(timestamp);
      return 'on $formattedDate';
    }
  }
}


// ----------------------------------Building Job Listing Card for Student View-----------------------------------------------------------
class BuildJobCardForStudent extends StatefulWidget {
  final jobModel listing;
  final Map applicationData;

  const BuildJobCardForStudent({
    super.key,
    required this.listing,
    required this.applicationData,
  });

  @override
  State<BuildJobCardForStudent> createState() => _BuildJobCardForStudentState();
}

class _BuildJobCardForStudentState extends State<BuildJobCardForStudent> {
  TextStyle getStatusTextStyle(String status) {
    Color color;
    switch (status) {
      case "ShortListed":
        color = Colors.orange;
        break;
      case "Pending":
        color = Colors.orange;
        break;
      case "Rejected":
        color = Colors.red;
        break;
      case "Accepted":
        color = Colors.green;
        break;
      default:
        color = Colors.red; // Assuming default is 'Under Review - Rejected'
    }

    return TextStyle(
      fontFamily: "Poppins",
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color, // This is dynamically assigned based on the status
      height: 19 / 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return PreviewJobApplocation(
              additionalinfo: widget.applicationData['additional info'],
              listing: widget.listing,
              jobType: '',
              education: '',
              name: '',
              workString: '',
              pageLabel: '',
            );
          }));
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: widget.listing.brandPfp!.isNotEmpty
                        ? Colors.white
                        : Colors.transparent,
                    child: widget.listing.brandPfp != null &&
                            widget.listing.brandPfp.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                widget.listing.brandPfp!, // Actual image URL
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 25,
                              backgroundImage: imageProvider,
                            ),
                          )
                        : CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  "assets/brand.png",
                                  fit: BoxFit.cover,
                                  height: 80,
                                  width: 80,
                                )), // Provide the path to your asset image
                          ),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Applied to:",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          height: 15 / 10,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.listing.createdBy,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff0f1015),
                          height: (20 / 18).h,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )),
                  Spacer(),
                  Text(
                    getTimeAgo(widget.applicationData['timeStamp'].toString()),
                    // "37 Mins ago",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8b8b8b),
                      height: (18 / 12).h,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              color: const Color(0xffF9F9F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildInfoColumns(
                      heading_text: "Role",
                      info_text: widget.listing.jobProfile),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 2.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(
                      heading_text: "Job Type",
                      info_text: widget.listing.jobType),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 2.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(
                      heading_text: "Work Mode",
                      info_text: widget.listing.workMode),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Responsibilities ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2F2F2F),
                      ),
                      children: [
                        TextSpan(
                          // text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                          // text: "}"
                          text: widget.listing.responsibilities,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xff424242),
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Divider(
                    height: 1.h,
                    thickness: 1.h,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            (() {
                              switch (widget.applicationData['status']) {
                                case "ShortListed":
                                  return "assets/pending.svg";
                                case "Rejected":
                                  return "assets/underReview.svg"; // Assuming you have a 'rejected.svg' asset.
                                case "Accepted":
                                  return "assets/accepted.svg";
                                default:
                                  return "assets/pending.svg";
                              }
                            })(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.applicationData['status'],
                        style: getStatusTextStyle(
                            widget.applicationData['status']),
                      ),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: const Text(
                                    'Are you sure you want to delete your application?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  actionsPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            ProfileServices()
                                                .deleteApplicationStatus(
                                                    widget.listing.docId)
                                                .then((value) {
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Container(
                                            height: 44.h,
                                            width: 150.w,
                                            decoration: BoxDecoration(
                                              color: Color(0xffE6E6E6),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Center(
                                              child: const Text(
                                                "Yes",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff373737),
                                                  height: 24 / 16,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            height: 44.h,
                                            width: 150.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Center(
                                              child: const Text(
                                                "No",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff373737),
                                                  height: 24 / 16,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Delete Application",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff111111),
                              height: 19 / 12,
                            ),
                            textAlign: TextAlign.left,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo(String timestampString) {
    // Convert the Firestore timestamp string to a DateTime
    DateTime timestamp = DateTime.parse(timestampString);

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the time difference
    Duration difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // Format the timestamp in a custom way if it's more than a week ago
      String formattedDate = DateFormat('MMM d, yyyy').format(timestamp);
      return 'on $formattedDate';
    }
  }
}


// ----------------------------------Chips to display options using Wrap-----------------------------------------------------------
class OptionChipDisplay extends StatelessWidget {
  final String title;

  const OptionChipDisplay({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return title.isNotEmpty
        ? Container(
            margin:
                EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0, bottom: 4.0),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: ColorsManager.greyishColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}


// ----------------------------------Chips to display & select - unselect options using Wrap-----------------------------------------------------------
class FilterOptionChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const FilterOptionChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            top: 9.0,
            left: selected ? 3.0 : 6.0,
            right: selected ? 3.0 : 6.0,
            bottom: 9.0),
        padding: selected
            ? EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 2.h,
              )
            : EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : ColorsManager.greyishColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? Colors.white : Color(0xff303030),
                height: 18 / 12,
              ),
            ),
            if (selected)
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.clear,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
