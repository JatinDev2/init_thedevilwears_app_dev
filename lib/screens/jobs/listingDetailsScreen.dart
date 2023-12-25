import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common_widgets.dart';
import 'confirmJobListing.dart';
import 'job_model.dart';

class JobListingDetailsScreen extends StatefulWidget {
  final jobModel newJobModel;

  JobListingDetailsScreen({
    required this.newJobModel,
  });

  @override
  State<JobListingDetailsScreen> createState() => _JobListingDetailsScreenState();
}

class _JobListingDetailsScreenState extends State<JobListingDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          // Navigator.pushNamed(context, '/listingScreen');
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,)),
        title: const Text(
          "Listing",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff0f1015),
            height: 20/16,
          ),
          textAlign: TextAlign.left,
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/Vector.svg", height: 24, width: 24,),
            onPressed: () {

            },
          ),
      const Icon(IconlyLight.send, color: Colors.black, size: 24,),
          SizedBox(width: 18.w,),
          const Icon(IconlyLight.bookmark, color: Colors.black, size: 24,),
          SizedBox(width: 18.w,),

        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 23.h),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 23.w,
                    right: 23.w,
                    bottom: 50.h,
                    top: 21.h
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50.h,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: widget.newJobModel.tags.map((option){
                                return OptionChipDisplay(
                                  title: option,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),),
                    SizedBox(height: 27.h,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage:const NetworkImage("https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w",),
                        ),
                        SizedBox(width: 13.w,),
                        Text(widget.newJobModel.createdBy, style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0f1015),
                          height: 20/20,
                        ),),
                      ],
                    ),
                    SizedBox(height: 33.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildColumns("assets/Suitcase.svg","Job type", widget.newJobModel.jobType),
                        buildColumns("assets/jobProfile.svg","Job Profile", widget.newJobModel.jobProfile),
                        buildColumns("assets/Dollar.svg","Stipend", widget.newJobModel.stipend=="Unpaid"? widget.newJobModel.stipend : "${widget.newJobModel.stipendAmount}${widget.newJobModel.stipendVal}"),
                      ],
                    ),
                    const SizedBox(height: 33,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildColumns("assets/Calendar Minimalistic.svg","Duration", widget.newJobModel.jobDuration=="Project based" ?widget.newJobModel.jobDuration : "${widget.newJobModel.jobDurExact} ${widget.newJobModel.jobDurVal}"),
                        buildColumns("assets/Home 2.svg","Module", widget.newJobModel.jobType),
                        buildColumns("assets/Map Point.svg","Location", widget.newJobModel.officeLoc),
                      ],
                    ),

                    SizedBox(height: 40.h,),
                    const Text("Day to day responsibilities",style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 23/16,
                    ),),
                    SizedBox(height: 5.h,),
                    Text(widget.newJobModel.responsibilities, style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff666666),
                      height: 41/26,
                    ),),

                    SizedBox(height: 19.h,),

                    const Text("Job Perks",style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 23/16,
                    ),),
                    SizedBox(height: 5.h,),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.newJobModel.perks.length,
                        itemBuilder: (BuildContext context, int index){
                          return Text("• ${widget.newJobModel.perks[index]}",style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff666666),
                            height: 41/26,
                          ),);
                        }),

                    SizedBox(height: 18.h,),
                    const Text("Tentative Start Date",style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 19/16,
                    ),),
                    SizedBox(height: 5.h,),
                    Text(widget.newJobModel.tentativeStartDate, style: TextStyle(
                      color: const Color(0xff141414),
                      fontSize: 16.sp,
                    ),),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    SizedBox(height: 18.h,),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    const Text("Number of openings",style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 19/16,
                    ),),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    SizedBox(height: 5.h,),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    Text(widget.newJobModel.numberOfOpenings, style: TextStyle(
                      color: const Color(0xff141414),
                      fontSize: 16.sp,
                    ),),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){


                },
                child: Container(
                  height: 56.h,
                  width: 396.w,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5.0.r),
                  ),
                  child: const Center(
                      child: Text(
                        "Send your application",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 24/16,
                        ),
                        textAlign: TextAlign.left,
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),);
  }
  Widget buildColumns(String imgSrc, String heading, String value){
    // Define the maximum number of characters
    const int maxChars = 20;

    // Function to truncate text with an ellipsis if it's too long
    String truncateWithEllipsis(String text, int maxLength) {
      return (text.length <= maxLength) ? text : '${text.substring(0, maxLength)}...';
    }

    return Container(
      width: 100.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(imgSrc),
          SizedBox(height: 5.h,),
          Text(
            truncateWithEllipsis(heading, maxChars),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xff2e2e2e),
              height: 19/12,
            ),
          ),
          Text(
            // truncateWithEllipsis(value, maxChars),
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xff7f7f7f),
              height: 19/12,
            ),
          ),
        ],
      ),
    );
  }

}

