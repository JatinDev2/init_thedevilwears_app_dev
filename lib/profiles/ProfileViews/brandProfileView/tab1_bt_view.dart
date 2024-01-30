import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Models/ProfileModels/brandModel.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Login/instaLogin/insta_test.dart';
import '../../../Login/instaLogin/instagram_model.dart';

class Tab1_BP_View extends StatefulWidget {
  final VoidCallback onTap;
  final BrandProfile brandProfile;

  const Tab1_BP_View({
    required this.onTap,
    required this.brandProfile,
    super.key,
  });

  @override
  State<Tab1_BP_View> createState() => _Tab1_BP_ViewState();
}

class _Tab1_BP_ViewState extends State<Tab1_BP_View> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var cellSize = screenWidth / 3;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        color: Colors.white,
        // margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Text(
                  "About ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1a1a1a),
                    height: 19/16,
                  ),
                  textAlign: TextAlign.left,
                ),
                Spacer(),

              ],
            ),
            SizedBox(height: 16.h,),
            buildProfileContainer("Founded in" , "Company Size" , "January,2018", "28 employees"),
            SizedBox(height: 8.h,),
            buildProfileContainer("Location" , "Industry" , "Mumbai, India", "Styling"),
            SizedBox(height: 30.h,),
            Row(
              children: [
                const Text(
                  "Job Openings",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1a1a1a),
                    height: 19/16,
                  ),
                  textAlign: TextAlign.left,
                ),
                Spacer(),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "View all",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xfff54e44),
                      height: 19/13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

              ],
            ),
            SizedBox(height: 23.h,),
            const Text(
              "Additional Info",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a1a1a),
                height: 19/16,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 11.h,),
            const Text(
              "Hello, I am a Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xff5a5a5a),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 21.h,),
            const Text(
              "Social media",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a1a1a),
                height: 19/16,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 14.h,),
            FutureBuilder<List<InstagramMedia>>(
              future: InstagramModel.fetchMedia(widget.brandProfile.accessToken, widget.brandProfile.instaUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator or shimmer effect
                  return _buildShimmerEffect(cellSize);
                } else if (snapshot.hasError) {
                  // Handle errors
                  return const Center(child: Text('No Posts yet!'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Handle no data
                  return const Center(child: Text('No Posts yet!'));
                } else {
                  // Build the grid view
                  // List<String> imageUrls = snapshot.data!;
                  List<InstagramMedia> mediaList = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Adjust the number of columns
                      childAspectRatio: 1, // Aspect ratio for each cell
                      crossAxisSpacing: 4.w, // Spacing between cells
                      mainAxisSpacing: 4.h, // Spacing between rows
                    ),
                    itemCount: mediaList.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: mediaList[index].mediaUrl,
                        placeholder: (context, url) => _buildShimmerEffect(cellSize),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 127.w,
                        height: 127.h,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileContainer(String head1, String head2, String data1, String data2){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 75.h,
          width: 184.w,
          decoration:  BoxDecoration(
            color:  Color(0xffF9F9F9)
            // color: Colors.blue
            ,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                head1,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff171717),
                  height: 19/14,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                data1,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                  height: 19/12,
                ),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
        SizedBox(width: 9.w,),
        Container(
          height: 75.h,
          width: 184.w,
          decoration:  BoxDecoration(
            color:  Color(0xffF9F9F9),
            // color: Colors.orange,

            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                head2,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff171717),
                  height: 19/14,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                data2,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff000000),
                  height: 19/12,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildShimmerEffect(double size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
      ),
    );
  }


}
