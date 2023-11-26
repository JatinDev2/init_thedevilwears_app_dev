import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common_widgets.dart';
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
                      Text(widget.newJobModel.createdBy, style: TextStyle(
                        color: const Color(0xff0F1015),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                  SizedBox(height: 33.h,),
                  Text("Job Type", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                  Text(widget.newJobModel.jobType, style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                  ),),
                  SizedBox(height: 18.h,),
                  Text("Job Profile", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                  Text(widget.newJobModel.jobProfile, style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                  ),),
                  SizedBox(height: 18.h,),
                  Text("Day to day responsibilities", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                  Text(widget.newJobModel.responsibilities, style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                  ),),
                  // SizedBox(height: 10.h,),
                  Text("Job Duration", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),

                  Row(children: [
                    Text(widget.newJobModel.jobDuration,style: TextStyle(
                      color: const Color(0xff141414),
                      fontSize: 16.sp,
                    ),),
                    if(widget.newJobModel.jobDurExact.isNotEmpty)
                      Text("(${widget.newJobModel.jobDurExact} ${widget.newJobModel.jobDurVal}",style: TextStyle(
                        color: const Color(0xff141414),
                        fontSize: 16.sp,
                      ),),
                  ],),
                  SizedBox(height: 18.h,),
                  Text("Work Mode", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                  Text(widget.newJobModel.workMode, style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                  ),),
                  SizedBox(height: 18.h,),
                  Text("Office Location", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                  Text(widget.newJobModel.officeLoc, style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                  ),),
                  SizedBox(height: 18.h,),
                  Text("Tentative Start Date", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                  Text(widget.newJobModel.tentativeStartDate, style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                  ),),
                  SizedBox(height: 18.h,),
                  Text("Stipend", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                  if(widget.newJobModel.stipend=="Unpaid")
                  Text(widget.newJobModel.stipend, style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                  ),),
                  if(widget.newJobModel.stipend!="Unpaid")
                    Text("${widget.newJobModel.stipend} (${widget.newJobModel.stipendAmount}${widget.newJobModel.stipendVal})", style: TextStyle(
                      color: const Color(0xff141414),
                      fontSize: 16.sp,
                    ),),
                  SizedBox(height: 18.h,),
                  Text("Perks", style: TextStyle(
                    color: const Color(0xff141414),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 5.h,),
                 ListView.builder(
                   shrinkWrap: true,
                     itemCount: widget.newJobModel.perks.length,
                     itemBuilder: (BuildContext context, int index){
                   return Text("${index+1}. ${widget.newJobModel.perks[index]}");
                 }),
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
                              jobModel newJobModel=jobModel(
                                jobType: widget.newJobModel.jobType,
                                jobProfile: widget.newJobModel.jobProfile,
                                responsibilities: widget.newJobModel.responsibilities,
                                jobDuration: widget.newJobModel.jobDuration,
                                jobDurExact: widget.newJobModel.jobDurExact,
                                workMode: widget.newJobModel.workMode,
                                officeLoc: widget.newJobModel.officeLoc,
                                tentativeStartDate: widget.newJobModel.tentativeStartDate,
                                stipend: widget.newJobModel.stipend,
                                stipendAmount:widget.newJobModel.stipendAmount,
                                numberOfOpenings: widget.newJobModel.numberOfOpenings,
                                perks: widget.newJobModel.perks,
                                createdAt: DateTime.now().toString(),
                                createdBy: "${firstName} + ${lastName}",
                                userId: userId!,
                                jobDurVal:widget.newJobModel.jobDurVal,
                                stipendVal:widget.newJobModel.stipendVal,
                                tags:widget.newJobModel.tags,
                              );
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
}

