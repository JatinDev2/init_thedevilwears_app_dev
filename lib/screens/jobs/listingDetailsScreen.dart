import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/App%20Constants/colorManager.dart';
import 'package:lookbook/App%20Constants/launchingFunctions.dart';
import 'package:shimmer/shimmer.dart';
import '../../Services/profiles.dart';
import '../../App Constants/pfpClass.dart';
import '../../Common Widgets/common_widgets.dart';
import 'Applications/previewApplication.dart';
import 'job_model.dart';

class JobListingDetailsScreen extends StatefulWidget {
  final jobModel newJobModel;
  final bool hasApplied;

  JobListingDetailsScreen({
    required this.newJobModel,
    required this.hasApplied,
  });

  @override
  State<JobListingDetailsScreen> createState() => _JobListingDetailsScreenState();
}

class _JobListingDetailsScreenState extends State<JobListingDetailsScreen> {
  TextEditingController additionalInfoController= TextEditingController();
  bool isSubmitLoading=false;
 

  void _showDialog(BuildContext context, String workString, String education, String name, String jobType, String imgUrl, String completeJobType) {
    setState(() {
      isLoading=false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var screenWidth = MediaQuery.of(context).size.width;
        var screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: screenWidth * 0.95,
            height: screenHeight * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 20.h,bottom:5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 13.w,),
                       Text(
                        "Your Application",
                        style: TextStyle(
                          // fontFamily: "Poppins",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff0f1015),
                          height: 20/18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1,thickness: 1,color: Color(0xffE7E7E7),),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 31.w, vertical: 31.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        // SizedBox(height: 33.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StudentProfilePicClassRadiusClass(imgUrl: imgUrl, radius: 25.r,),
                            SizedBox(width: 11.w),
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 name,
                                 style: const TextStyle(
                                   // fontFamily: "Poppins",
                                   fontSize: 16,
                                   fontWeight: FontWeight.w600,
                                   color: Color(0xff0f1015),
                                   height: 20/16,
                                 ),
                                 textAlign: TextAlign.left,
                               ),
                               InkWell(
                                 onTap: () {
                                   showDialog(
                                     context: context,
                                     builder: (BuildContext context) {
                                       return AlertDialog(
                                         title: const Text('Description'),
                                         content: SingleChildScrollView(
                                           child: Text(
                                             completeJobType,
                                             style: const TextStyle(
                                               // fontFamily: "Poppins",
                                               fontSize: 16,
                                               fontWeight: FontWeight.w400,
                                               color: Colors.black,
                                             ),
                                           ),
                                         ),
                                         actions: <Widget>[
                                           TextButton(
                                             child: const Text('Close'),
                                             onPressed: () {
                                               Navigator.of(context).pop(); // Close the dialog
                                             },
                                           ),
                                         ],
                                         shape: RoundedRectangleBorder( // Add this line
                                           borderRadius: BorderRadius.circular(10), // Adjust the radius
                                         ),
                                       );
                                     },
                                   );
                                 },
                                 child: Container(
                                   margin: const EdgeInsets.only(top: 2),
                                   child: Text(
                                     jobType,
                                     style: const TextStyle(
                                       // fontFamily: "Poppins",
                                       fontSize: 14,
                                       fontWeight: FontWeight.w400,
                                       color: Color(0xff616161),
                                       height: 19/14,
                                     ),
                                     textAlign: TextAlign.left,
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ),
                               ),

                             ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        const Text(
                          "Worked with",
                          style: TextStyle(
                            // fontFamily: "Poppins",
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
                            // fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff7d7d7d),
                          ),
                          expandText: 'more',
                          collapseText: '...less',
                          maxLines: 2,
                          linkColor: Color(0xffa8a8a8),
                          linkStyle: const TextStyle(
                            // fontFamily: "Poppins",
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
                            // fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff7d7d7d),
                            height: 19/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(education, style:  TextStyle(
                          // fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff7d7d7d),
                        ),),
                        SizedBox(height: 25.h),
                        const Text(
                          "Additional Information",
                          style: TextStyle(
                            // fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff000000),
                            height: 19/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xffF9F9F9),
                            borderRadius: BorderRadius.circular(8.0.r)
                          ),
                          child: TextFormField(
                            controller: additionalInfoController,
                            maxLines: 7,
                            decoration: const InputDecoration(
                              hintText: "What additional information would you like to provide?\n\nWe recommend adding relevant projects links & giving a small write-up about why you are the right fit for this role",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                              // fontFamily: "Poppins",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff787878),
                            ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 16),
                        Spacer(),
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
                                      pageLabel: "Listing Details",
                                    );
                                  }));
                                },
                                child: Container(
                                  height: 58.h,
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE6E6E6),
                                    borderRadius: BorderRadius.circular(8.0.r),
                                  ),
                                  child: Center(
                                    child:  Text(
                                      "Preview",
                                      style: TextStyle(
                                        // fontFamily: "Poppins",
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
                                onTap: () async {
                                  if (!widget.hasApplied) {
                                    setState(() {
                                      isSubmitLoading = true;
                                    });

                                    Map<String, dynamic> applicationData = {
                                      "additionalInfo": additionalInfoController.text,
                                      "userId": LoginData().getUserId(),
                                      "workedAt": workString,
                                      "education": education,
                                      "statusOfApplication": "Pending",
                                      "appliedBy": name,
                                      "createdBy": widget.newJobModel.createdBy,
                                      "jobProfile": jobType,
                                      "userPfp":LoginData().getUserProfilePicture(),
                                      "userGmail":LoginData().getUserEmail(),
                                      "userPhoneNumber":LoginData().getUserPhoneNumber(),
                                    };

                                    // Reference to Firestore
                                    final firestore = FirebaseFirestore.instance;

                                    try {
                                      // Reference to the specific job listing document
                                      DocumentReference jobRef = firestore.collection('jobListing').doc(widget.newJobModel.docId);

                                      // Reference to student profile document
                                      DocumentReference studentRef = firestore.collection('studentProfiles').doc(LoginData().getUserId());

                                      DocumentSnapshot jobSnapshot = await jobRef
                                          .get();
                                      if (!jobSnapshot.exists) {
                                        throw Exception('Job listing not found');
                                      }
                                      CollectionReference applicationsRef = jobRef
                                          .collection('Applications');

                                      await firestore.runTransaction((transaction) async {
                                        DocumentSnapshot studentSnapshot = await transaction.get(studentRef);

                                        // Initialize applicationsApplied as an empty list
                                        List<Map<String, dynamic>> applicationsApplied = [];

                                        // Get the data from the studentSnapshot
                                        var studentData = studentSnapshot.data() as Map<String, dynamic>?;

                                        // Check if studentData is not null and contains 'applicationsApplied'
                                        if (studentData != null && studentData.containsKey('applicationsApplied')) {
                                          applicationsApplied = List<Map<String, dynamic>>.from(studentData['applicationsApplied']);
                                        }

                                        // Prepare the application map to be added
                                        Map<String, dynamic> applicationMap = {
                                          'brandName': widget.newJobModel.createdBy,
                                          'timeStamp': DateTime.now().toString(),
                                          'status': "Pending",
                                          'jobId': widget.newJobModel.docId,
                                          'additional info':additionalInfoController.text
                                        };

                                        // Add the new application map to the list
                                        applicationsApplied.add(applicationMap);

                                        // Set updated applicationsApplied list in student profile
                                        transaction.set(studentRef, {'applicationsApplied': applicationsApplied}, SetOptions(merge: true));

                                        // Update job listing document
                                        transaction.set(applicationsRef.doc(LoginData().getUserId()), applicationData, SetOptions(merge: true));
                                        transaction.update(jobRef, {
                                          'applicationCount': FieldValue.increment(1),
                                          'clicked': false,
                                          'applicationsIDS': FieldValue.arrayUnion([LoginData().getUserId()]),
                                        });
                                      });


                                      print('Application successfully created');
                                      setState(() {
                                        isSubmitLoading = false;
                                      });
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      print('Error creating application: $e');
                                      setState(() {
                                        isSubmitLoading = false;
                                      });
                                      // Handle the error appropriately
                                    }
                                  } else {
                                    // Handle the case where the user has already applied
                                  }
                                },


                                child: Container(
                                  height: 58.h,
                                  width: 160.w,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8.0.r),
                                  ),
                                  child: Center(
                                      child:isSubmitLoading?
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                      ) :  Text(
                                        "Submit",
                                        style: TextStyle(
                                          // fontFamily: "Poppins",
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
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
                        ),
                        SizedBox(height: 26.h,),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isLoading=false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

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
            // fontFamily: "Poppins",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff0f1015),
            height: 20/16,
          ),
          textAlign: TextAlign.left,
        ),
        actions: [
          InkWell(
            child:SvgPicture.asset("assets/Vector.svg", height: 24, width: 24,),
            onTap: () {
              LaunchingFunction().launchPhoneDialer(widget.newJobModel.phoneNumber);
            },
          ),
          SizedBox(width: 18.w,),

      const Icon(IconlyLight.send, color: Colors.black, size: 24,),
          SizedBox(width: 18.w,),
          const Icon(IconlyLight.bookmark, color: Colors.black, size: 24,),
          SizedBox(width: 18.w,),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 23.h),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 19.w,
                    right: 23.w,
                    bottom: 50.h,
                    top: 21.h
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.h,
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
                    SizedBox(height: 21.h,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BrandProfilePicClass(imgUrl: widget.newJobModel.brandPfp,),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(width: 13.w,),
                        Text(widget.newJobModel.createdBy, style: const TextStyle(
                          // fontFamily: "Poppins",
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
                      // fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 23/16,
                    ),),
                    SizedBox(height: 7.h,),
                    Text(widget.newJobModel.responsibilities, style: const TextStyle(
                      // fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff666666),
                      height: 41/26,
                    ),),

                    SizedBox(height: 30.h,),

                    const Text("Job Perks",style: TextStyle(
                      // fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 23/16,
                    ),),
                    SizedBox(height: 7.h,),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.newJobModel.perks.length,
                        itemBuilder: (BuildContext context, int index){
                          return Text("• ${widget.newJobModel.perks[index]}",style: const TextStyle(
                            // fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff666666),
                            height: 41/26,
                          ),);
                        }),

                    SizedBox(height: 30.h,),
                    const Text("Tentative Start Date",style: TextStyle(
                      // fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 19/16,
                    ),),
                    SizedBox(height: 7.h,),
                    Text(widget.newJobModel.tentativeStartDate, style: TextStyle(
                      color: const Color(0xff141414),
                      fontSize: 16.sp,
                    ),),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    SizedBox(height: 30.h,),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    const Text("Number of openings",style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 19/16,
                    ),),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    SizedBox(height: 7.h,),
                    if(widget.newJobModel.numberOfOpenings.isNotEmpty)
                    Text(widget.newJobModel.numberOfOpenings, style: TextStyle(
                      color: const Color(0xff141414),
                      fontSize: 16.sp,
                    ),),
                    SizedBox(height: 30.h,),
                    const Text("Profile preferences",style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2e2e2e),
                      height: 19/16,
                    ),),
                    Container(
                      height: 50.h,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: widget.newJobModel.interests.map((option){
                                return OptionChipDisplay(
                                  title: option,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),),
                  ],
                ),
              ),
              if(LoginData().getUserType()=="Person")
              GestureDetector(
                onTap: () async{
                  if(!widget.hasApplied){
                    setState(() {
                      isLoading=true;
                    });

                    String workString="";
                    String education="";

                    ProfileServices().fetchWorkExperienceCompanies().then((value){
                      if(value.isNotEmpty){
                        workString=value;
                      }
                      else{
                        workString="No Work experience yet!";
                      }
                      ProfileServices().fetchLatestEducation().then((educationVal) {
                        if(educationVal.isNotEmpty){
                          education=educationVal;
                        }
                        else{
                          education="No education added yet!";
                        }
                        String formattedJobType = LoginData().getUserJobProfile().join(" • ");

                        List<String> jobTypeValues = formattedJobType.split(" • ");

                        if (jobTypeValues.length > 2) {
                          formattedJobType = jobTypeValues.take(2).join(" • ");
                          int remainingCount = jobTypeValues.length - 2;
                          formattedJobType += " ...+$remainingCount more";
                        }

                        _showDialog(context, workString,education ,"${LoginData().getUserFirstName()} ${LoginData().getUserLastName()}",formattedJobType, LoginData().getUserProfilePicture(), LoginData().getUserJobProfile().join(" • "));
                      });
                    });
                  }
                  else{

                  }

                },
                child: Container(
                  height: 56.h,
                  width: 396.w,
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: widget.hasApplied? ColorsManager.greyishColor : Colors.orange,
                    borderRadius: BorderRadius.circular(5.0.r),
                  ),
                  child:  Center(
                      child: isLoading ? const CircularProgressIndicator( color:  Colors.white,) :  Text(
                       widget.hasApplied? "Already Applied!": "Send your application",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color:widget.hasApplied? Colors.black: Colors.white,
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
              // fontFamily: "Poppins",
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
              // fontFamily: "Poppins",
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

