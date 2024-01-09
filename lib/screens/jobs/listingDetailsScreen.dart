import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/screens/profile/profileModels/workModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/profiles.dart';
import '../common_widgets.dart';
import 'Applications/previewApplication.dart';
import 'Applications/previewTab.dart';
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
  TextEditingController additionalInfoController= TextEditingController();
  bool isSubmitLoading=false;

  void _showDialog(BuildContext context, String workString, String education, String name, String jobType) {
    setState(() {
      isLoading=false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Your Application",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff0f1015),
                          height: 20/18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                  SizedBox(height: 33.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        // backgroundImage: NetworkImage("image_url"),
                        radius: 30.0.r,
                      ),
                      SizedBox(width: 11.w),
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           name,
                           style: const TextStyle(
                             fontFamily: "Poppins",
                             fontSize: 16,
                             fontWeight: FontWeight.w600,
                             color: Color(0xff0f1015),
                             height: 20/16,
                           ),
                           textAlign: TextAlign.left,
                         ),
                         Text(
                           jobType,
                           style: const TextStyle(
                             fontFamily: "Poppins",
                             fontSize: 14,
                             fontWeight: FontWeight.w400,
                             color: Color(0xff616161),
                             height: 19/14,
                           ),
                           textAlign: TextAlign.left,
                         ),
                       ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  const Text(
                    "Worked with",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff7d7d7d),
                      height: 19/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  ExpandableText(
                    workString, // Your text goes here
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff7d7d7d),
                    ),
                    expandText: 'more',
                    collapseText: '...less',
                    maxLines: 2,
                    linkColor: Color(0xffa8a8a8),
                    linkStyle: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffa8a8a8),
                    ),
                    linkEllipsis: true,
                    animation: true,
                    animationDuration: Duration(milliseconds: 500), // Custom animation duration
                    animationCurve: Curves.easeInOut, // Custom animation curve
                    collapseOnTextTap: true,
                  ),

                  SizedBox(height: 30.h),
                  const Text(
                    "Education",
                    style:  TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff7d7d7d),
                      height: 21/14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(education),
                  SizedBox(height: 25.h),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff000000),
                      height: 19/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: additionalInfoController,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      hintText: "What additional information would you like to provide?\n\nWe recommend adding relevant projects links & giving a small write-up about why you are the right fit for this role",
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff787878),
                    ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: isSubmitLoading? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                    children: [
                      if(!isSubmitLoading)
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return PreviewJobApplocation(
                                additionalinfo: additionalInfoController.text,
                                listing: widget.newJobModel,
                                jobType: jobType,
                                education: education,
                                name: name,
                                workString: workString,
                              );
                            }));
                          },
                          child: Container(
                            height: 56.h,
                            width: 134.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffE6E6E6),
                              borderRadius: BorderRadius.circular(5.0.r),
                            ),
                            child: Center(
                              child:  Text(
                                "Preview",
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

                      if(!isSubmitLoading)
                        GestureDetector(
                            onTap: ()async{
                              setState((){
                                 isSubmitLoading=true;
                              });
                              final prefs = await SharedPreferences.getInstance();
                              final userId = prefs.getString('userId');
                              final firstName = prefs.getString('firstName');
                              final lastName = prefs.getString('lastName');
                              Map<String,dynamic> applicationData={
                                "additionalInfo" : additionalInfoController.text,
                                "userId":  userId,
                                "workedAt": workString,
                                "education":education,
                                "statusOfApplication":"Pending",
                                "appliedBy":name,
                                "createdBy": "$firstName $lastName",
                                "jobProfile":jobType,
                              };
                              // Reference to Firestore
                              final firestore = FirebaseFirestore.instance;

                              try {
                                // Reference to the specific job listing document
                                DocumentReference jobRef = firestore.collection('jobListing').doc(widget.newJobModel.docId);

                                DocumentSnapshot jobSnapshot = await jobRef.get();
                                if (!jobSnapshot.exists) {
                                  throw Exception('Job listing not found');
                                }
                                CollectionReference applicationsRef = jobRef.collection('Applications');

                                await firestore.runTransaction((transaction) async {
                                  transaction.set(applicationsRef.doc(userId), applicationData, SetOptions(merge: true));
                                  transaction.update(jobRef, {
                                    'applicationCount': FieldValue.increment(1),
                                    'clicked': false
                                  });
                                });
                                print('Application successfully created');
                                setState(() {
                                    isSubmitLoading=false;
                                });
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                              } catch (e) {
                                print('Error creating application: $e');
                                throw e; // Rethrow the exception
                              }
                            },

                          child: Container(
                            height: 56.h,
                            width: 134.w,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5.0.r),
                            ),
                            child: Center(
                                child:isSubmitLoading?
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
                      if(isSubmitLoading)
                        Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isLoading=false;

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
                onTap: () async{
                  setState(() {
                    isLoading=true;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  // final userId = prefs.getString('userId');
                  final firstName = prefs.getString('firstName');
                  final lastName = prefs.getString('lastName');
                  String workString="";
                  String education="";

                  ProfileServices().fetchWorkExperienceCompanies().then((value) {
                    workString=value;
                    ProfileServices().fetchLatestEducation().then((educationVal) {
                      education=educationVal!;
                      _showDialog(context, workString,education ,"${firstName} ${lastName}","Fashion Stylist");
                    });
                  });
                },
                child: Container(
                  height: 56.h,
                  width: 396.w,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5.0.r),
                  ),
                  child:  Center(
                      child: isLoading ? const CircularProgressIndicator( color:  Colors.white,) : const Text(
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

