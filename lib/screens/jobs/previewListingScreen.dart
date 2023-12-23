import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common_widgets.dart';
import 'confirmJobListing.dart';
import 'job_model.dart';

class PreviewJobListing extends StatefulWidget {
  final jobModel newJobModel;

  PreviewJobListing({
   required this.newJobModel,
});

  @override
  State<PreviewJobListing> createState() => _PreviewJobListingState();
}

class _PreviewJobListingState extends State<PreviewJobListing> {
  bool isLoading=false;
  final CollectionReference listCollection = FirebaseFirestore.instance.collection('jobListing');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,), onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.white,
        title: const Text(
          "Preview your listing",
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
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(
      left: 23.w,
          right: 23.w,
          bottom: 50.h,
              top: 21.h
      ),
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

            SizedBox(height: 18.h,),
            const Text("Number of openings",style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff2e2e2e),
              height: 19/16,
            ),),
            SizedBox(height: 5.h,),
            Text(widget.newJobModel.numberOfOpenings, style: TextStyle(
              color: const Color(0xff141414),
              fontSize: 16.sp,
            ),),

                  SizedBox(height: 37.h,),
                  Row(
                    mainAxisAlignment: isLoading? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                    children: [
                      if(!isLoading)
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 56.h,
                            width: 176.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffE6E6E6),
                              borderRadius: BorderRadius.circular(5.0.r),
                            ),
                            child: Center(
                              child:  Text(
                                "Back",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff373737),
                                  height: (24/16).h,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),

                      if(!isLoading)
                        GestureDetector(
                          onTap: ()async{
                              final prefs = await SharedPreferences.getInstance();
                              final userId = prefs.getString('userId');
                              final firstName = prefs.getString('firstName');
                              final lastName = prefs.getString('lastName');
                              listCollection.add({
                                "jobType": widget.newJobModel.jobType,
                                "jobProfile": widget.newJobModel.jobProfile,
                                "responsibilities": widget.newJobModel.responsibilities,
                                "jobDuration": widget.newJobModel.jobDuration,
                                "jobDurationExact": widget.newJobModel.jobDurExact,
                                "workMode": widget.newJobModel.workMode,
                                "officeLoc": widget.newJobModel.officeLoc,
                                "tentativeStartDate": widget.newJobModel.tentativeStartDate,
                                "stipend": widget.newJobModel.stipend,
                                "stipendAmount":widget.newJobModel.stipendAmount,
                                "numberOfOpenings": widget.newJobModel.numberOfOpenings,
                                "perks": widget.newJobModel.perks,
                                "createdAt": DateTime.now().toString(),
                                "createdBy": "$firstName $lastName",
                                "userId": userId,
                                "jobDurVal":widget.newJobModel.jobDurVal,
                                "stipendVal":widget.newJobModel.stipendVal,
                                "tags": widget.newJobModel.tags,
                              }).then((value) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                  return const ConfirmJobListingScreen();
                                }));
                              });
                          },
                          child: Container(
                            height: 56.h,
                            width: 176.w,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5.0.r),
                            ),
                            child: Center(
                                child:isLoading?
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                ) :  Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff010100),
                                    height: (24/16).h,
                                  ),
                                  textAlign: TextAlign.left,
                                )
                            ),
                          ),
                        ),
                      if(isLoading)
                        Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  )
                ],
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

