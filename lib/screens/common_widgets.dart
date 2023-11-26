import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lookbook/screens/jobs/job_model.dart';
import 'package:share/share.dart';
import 'listing/Details_Screen.dart';
import 'listing/new_listing/List_Model.dart';

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


class BuildCustomCard extends StatelessWidget {
  final ListModel listing;
  const BuildCustomCard({
    super.key,
    required this.listing,
});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return Details_Screen(listing: listing);
            }));
            // Navigator.pushNamed(context, 'listingDetailsScreen');
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(2.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: listing.tags!.map((option) {
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
                margin: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        "https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                        child: Text(
                          "${listing.createdBy}",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0f1015),
                            height: 20 / 18,
                          ),
                          textAlign: TextAlign.left,
                        )),
                    Container(
                      child: Column(
                        children: [
                          const Text(
                            "Required on ",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff0f1015),
                            ),
                          ),
                          Text(
                            listing.productDate,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff0f1015),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: const Color(0xffF9F9F9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BuildInfoColumns(heading_text: "For", info_text: listing.toStyleName),
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      height: 50,
                      width: 2,
                      color: const Color(0xffB7B7B9),
                    ),
                    BuildInfoColumns(heading_text:"Location", info_text:listing.location),
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      height: 50,
                      width: 2,
                      color: const Color(0xffB7B7B9),
                    ),
                    BuildInfoColumns(heading_text:"Event", info_text:listing.eventCategory),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Requirements ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2F2F2F),
                        ),
                        children: [
                          TextSpan(
                            // text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                            // text: "}"
                            text: listing.requirement,
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          getTimeAgo(listing.timeStamp!),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8b8b8b),
                            height: 18 / 12,
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
                              String deepLink = 'myapp://next_page'; // Replace with your actual deep link structure

                              // Share the deep link using the share package
                              Share.share('Check out this listing: $deepLink', subject: 'Listing Details');

                            }, icon: const Icon(IconlyLight.send)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(IconlyLight.bookmark)),
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


class BuildCustomJobCard extends StatelessWidget {
  final jobModel listing;

   const BuildCustomJobCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (_){
          //   return Details_Screen(listing: listing);
          // }));
          // Navigator.pushNamed(context, 'listingDetailsScreen');
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: listing.tags.map((option){
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
                   CircleAvatar(
                    radius: 20.r,
                    backgroundImage: const NetworkImage(
                      "https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",
                    ),
                  ),
                   SizedBox(
                    width: 6.w,
                  ),
                  Expanded(
                      child: Text(
                        listing.createdBy,
                        style:  TextStyle(
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
              padding:  EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              margin:  EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.h),
              color: const Color(0xffF9F9F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BuildInfoColumns(heading_text: "Work Mode", info_text: listing.workMode),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 2.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(heading_text:"Location", info_text:listing.officeLoc),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 2.0.h),
                    height: 50.h,
                    width: 2.w,
                    color: const Color(0xffB7B7B9),
                  ),
                  BuildInfoColumns(heading_text:"Stipend", info_text:listing.stipend!="Unpaid" ? "${listing.stipendAmount}${listing.stipendVal}"  : "${listing.stipend}"),
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
                      style:  TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2F2F2F),
                      ),
                      children: [
                        TextSpan(
                          // text: ' A mustard yellow traditional outfit is required for Alia Bhatt for her new movie promotions. The fabric...',
                          // text: "}"
                          text: listing.responsibilities,
                          style:  TextStyle(
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
                        style:  TextStyle(
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
                            String deepLink = 'myapp://next_page'; // Replace with your actual deep link structure

                            // Share the deep link using the share package
                            Share.share('Check out this listing: $deepLink', subject: 'Listing Details');

                          }, icon: const Icon(IconlyLight.send)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(IconlyLight.bookmark)),
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


class OptionChipDisplay extends StatelessWidget {
  final String title;

  const OptionChipDisplay({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return title.isNotEmpty? Container(
      margin:  EdgeInsets.only(
          top: 4.0.h,
          left: 4.0.w,
          right: 4.0.w,
          bottom: 4.0.h
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color:const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: Colors.black,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    ) : Container();
  }
}
