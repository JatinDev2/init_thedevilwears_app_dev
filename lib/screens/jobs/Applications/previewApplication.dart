import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/screens/jobs/Applications/previewTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../job_model.dart';

class PreviewJobApplocation extends StatefulWidget{
  final String additionalinfo;
  final jobModel listing;
  final String workString;
  final String education;
  final String name;
  final  String jobType;

  PreviewJobApplocation({
   required this.additionalinfo,
    required this.listing,
    required this.jobType,
    required this.education,
    required this.name,
    required this.workString,
});

  @override
  State<PreviewJobApplocation> createState() => _PreviewJobApplocationState();
}

class _PreviewJobApplocationState extends State<PreviewJobApplocation>
    with SingleTickerProviderStateMixin {
  List gridItems = [];
  String uid=LoginData().getUserId();
  // bool isDataLoading=true;
  bool isLoading=false;

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Call",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0f1015),
                    height: 24 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 13),
                SvgPicture.asset("assets/phone.svg"),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Message",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff0f1015),
                    height: 24 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: 13),
                SvgPicture.asset("assets/whatsapp.svg"),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/facebook.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/twitter.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/instagram.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/linkedin.svg"),
                SizedBox(width: 24),
                SvgPicture.asset("assets/google.svg"),
              ],
            ),
            SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // fetchId().then((value) {
    //   setState(() {
    //     isDataLoading = false;
    //     uid = value;
    //   });
    // });
    // gridItems = GridItemData.generateItems();
    super.initState();
  }

  // Future<String> fetchId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('userId');
  //   return userId!;
  // }

  @override
  Widget build(BuildContext context) {
    return
    StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('studentProfiles')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Scaffold(body: Center(child: Text("No data found")));
          }
          else{
            var data = snapshot.data!.data() as Map<String, dynamic>;
            var projectsList = (data['projects'] is List<dynamic>) ? List<dynamic>.from(data['projects']) : [];
            var workList = (data['Work Experience'] is List<dynamic>) ? List<dynamic>.from(data['Work Experience']) : [];

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(icon: const Icon(Icons.close, color: Colors.black,), onPressed: (){
                  Navigator.of(context).pop();
                },),
                backgroundColor: Colors.white,
                title: const Text(
                  "Preview your Application",
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
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Material(
                                elevation: 4,
                                shape: CircleBorder(),
                                clipBehavior: Clip.none,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                          "https://images.squarespace-cdn.com/content/v1/5a99d01c5ffd206cdde00bec/7e125d62-e859-41ff-aa04-23e4e0040a33/image-asset.jpeg?format=500w"),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   width: 48,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        projectsList.length.toString(),
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000),
                                          height: 20 / 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      const Text(
                                        "Projects",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6b6b6b),
                                          height: 20 / 12,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        workList.length.toString(),
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff000000),
                                          height: 20 / 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      const Text(
                                        "Work X",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff6b6b6b),
                                          height: 20 / 12,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      bottomSheet(context);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SvgPicture.asset(
                                          "assets/contact.svg",
                                          height: 16,
                                          width: 13,
                                        ),
                                        const Text(
                                          "Contact",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff6b6b6b),
                                            height: 20 / 12,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child:  Row(
                              children: [
                                Text(
                                  "${widget.name} • ",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff0f1015),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "Student",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffababab),
                                  ),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            )
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: const Text(
                              "Hello, I am a Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff5a5a5a),
                              ),
                              textAlign: TextAlign.left,
                            )),
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                        //   decoration: BoxDecoration(
                        //     color: Color(0xffF9F9F9),
                        //     borderRadius: BorderRadius.circular(12.0.r)
                        //   ),
                        //   child:  Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //      const Text(
                        //         "Additional Info",
                        //         style: TextStyle(
                        //           fontFamily: "Poppins",
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.w600,
                        //           color: Color(0xff1a1a1a),
                        //           height: 19/16,
                        //         ),
                        //         textAlign: TextAlign.left,
                        //       ),
                        //       Text(widget.additionalinfo, style: const TextStyle(
                        //         fontFamily: "Poppins",
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w400,
                        //         color: Color(0xff000000),
                        //         height: 16/14,
                        //       ),)
                        //     ],
                        //   ),
                        // ),
                        previewApplicationTabBody(additionalInfo: widget.additionalinfo,),
                        SizedBox(height: 70.h,),

                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:  Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: isLoading? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
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
                                        "Cancel",
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
                                    setState(() {
                                      isLoading=true;
                                    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');
                                    Map<String,dynamic> applicationData={
                                      "additionalInfo" : widget.additionalinfo,
                                        "userId":  userId,
                                      "workedAt": widget.workString,
                                      "education":widget.education,
                                      "statusOfApplication":"Pending",
                                      "appliedBy":widget.name,
                                      "createdBy": "$firstName $lastName",
                                      "jobProfile":widget.jobType,
                                    };
                                      // Reference to Firestore
                                      final firestore = FirebaseFirestore.instance;

                                      try {
                                        // Reference to the specific job listing document
                                        DocumentReference jobRef = firestore.collection('jobListing').doc(widget.listing.docId);

                                        DocumentSnapshot jobSnapshot = await jobRef.get();
                                        if (!jobSnapshot.exists) {
                                          throw Exception('Job listing not found');
                                        }
                                        CollectionReference applicationsRef = jobRef.collection('Applications');

                                        await firestore.runTransaction((transaction) async {
                                          transaction.set(applicationsRef.doc(uid), applicationData);


    transaction.update(jobRef, {
    'applicationsCount': FieldValue.increment(1),
    'clicked': false
    });
    });
                                        print('Application successfully created');
                                        setState(() {
                                          isLoading=false;
                                        });
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();

                                      } catch (e) {
                                        print('Error creating application: $e');
                                        throw e; // Rethrow the exception
                                      }
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
                          ),
                          SizedBox(height: 10.h,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

        }
    );
  }
}

