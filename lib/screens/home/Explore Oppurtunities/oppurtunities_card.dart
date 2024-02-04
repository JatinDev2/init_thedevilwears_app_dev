import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import '../../../Services/profiles.dart';


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
  double cornerRadius = 16;
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
                  child: widget.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
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
                  )
                      : Container( // If imageUrl is empty, display the local asset image
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/brand.png"),
                        fit: BoxFit.cover,
                      ),
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
                        '${widget.clothingType}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff3f3f3f),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${widget.jobOpenings} Job openings, ${widget.location}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8a8a8a),
                        ),
                        overflow: TextOverflow.ellipsis,
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

