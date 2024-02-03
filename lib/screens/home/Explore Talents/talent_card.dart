import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Services/profiles.dart';
import 'package:shimmer/shimmer.dart';

class TalentCard extends StatefulWidget {
  final String name;
  final String designation;
  final String company;
  final String? imageUrl;
  final String education;
  final String uid;

  const TalentCard({
    Key? key,
    required this.name,
    required this.designation,
    required this.company,
    this.imageUrl,
    required this.education,
    required this.uid,
  }) : super(key: key);

  @override
  State<TalentCard> createState() => _TalentCardState();
}

class _TalentCardState extends State<TalentCard> {
 late bool isBookmarked;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isBookmarked=LoginData().getBookmarkedStudentProfiles().contains(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = 48;
    final double avatarBorderWidth = 4;

    return Container(
      margin: EdgeInsets.only(top: avatarRadius + avatarBorderWidth),
      child: Stack(
        clipBehavior: Clip.none,
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
                  // SizedBox(height: 2),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff0f1015),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            // height: 18 / 12,
                          ),
                        ),
                        TextSpan(
                          text: ' • ${widget.designation}',
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
                    widget.company,
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
                    widget.education,
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
          if(LoginData().getUserId()!=widget.uid)
          Positioned(
            top: 20.h,
            right: 10.w,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: InkWell(
                child: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.black : Colors.grey,
                ),
                onTap: () {
                  setState((){
                    isBookmarked = !isBookmarked;
                  });
                  if(isBookmarked){
                    ProfileServices().bookmarkStudentProfile(LoginData().getUserId(),widget.uid);
                  }
                  else{
                    ProfileServices().removeBookmarkedStudentProfile(LoginData().getUserId(),widget.uid);
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: -(avatarRadius + avatarBorderWidth - 8.h),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: widget.imageUrl!.isNotEmpty? Colors.white : Colors.transparent,
              child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: widget.imageUrl!, // Actual image URL
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
