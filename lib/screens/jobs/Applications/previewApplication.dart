import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/screens/jobs/Applications/previewTab.dart';
import '../../../Models/ProfileModels/studentModel.dart';
import '../../../App Constants/launchingFunctions.dart';
import '../job_model.dart';

class PreviewJobApplocation extends StatefulWidget{
  final String additionalinfo;
  final jobModel listing;
  final String workString;
  final String education;
  final String name;
  final String jobType;
  final String pageLabel;

  PreviewJobApplocation({
   required this.additionalinfo,
    required this.listing,
    required this.jobType,
    required this.education,
    required this.name,
    required this.workString,
   required this.pageLabel,
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

  @override
  void initState() {
    super.initState();
  }

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
            var projectsList = <dynamic>[];
            var workList = <dynamic>[];
            String userName="";
            String descriptionsWithBullets="";
            String userProfilePic="";
            String userBio="";
            late StudentProfile studentProfile;

            // Check if the snapshot has data and is not null.
            if (snapshot.hasData && snapshot.data!.data() != null) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              studentProfile = StudentProfile.fromMap(data);
              projectsList = (data['projects'] is List<dynamic>) ? List<dynamic>.from(data['projects']) : [];
              workList = (data['Work Experience'] is List<dynamic>) ? List<dynamic>.from(data['Work Experience']) : [];
              // userDescriptionList=(data['userDescription'] is List<dynamic>) ? List<dynamic>.from(data['userDescription']) : [];
              List<String> userDescriptionList = (data['userDescription'] is List<dynamic>)
                  ? List<String>.from(data['userDescription'].map((item) => item.toString()))
                  : [];
              userProfilePic= data["userProfilePicture"];

              descriptionsWithBullets = userDescriptionList.join('  •  ');

              userName="${data["firstName"]} ${data["lastName"]}";
              userBio=data["userBio"];

            }

            return Scaffold(
              backgroundColor: Colors.white,
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
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Material(
                                  elevation: 4,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.none,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.transparent,
                                        child: (userProfilePic != null && userProfilePic.isNotEmpty)
                                            ? ClipOval(
                                          child: Image.network(
                                            userProfilePic,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          ),
                                        )
                                            : SvgPicture.asset(
                                          "assets/devil.svg",
                                          width: 80,
                                          height: 80,
                                        ),
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
                                    InkWell(
                                      onTap: (){
                                        LaunchingFunction().bottomSheet(
                                            context: context,
                                            userPhoneNumber: studentProfile.phoneNumber!,
                                            userFaceBook: studentProfile.userFacebook ?? "",
                                            userTwitter: studentProfile.userTwitter ?? "",
                                            userInsta: studentProfile.userInsta ?? "",
                                            userLinkedIn:studentProfile.userLinkedin ?? "",
                                            userGmail: studentProfile.userEmail!
                                        );
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
                              margin: EdgeInsets.only(top: 5, left: 11),
                              child:  Row(
                                children: [
                                  Text(
                                    "Hey,\nI’m $userName",
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0f1015),
                                      // height: 48/24,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )
                          ),
                          SizedBox(height: 8,),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Description'),
                                    content: SingleChildScrollView(
                                      child: Text(
                                        descriptionsWithBullets,
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
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
                              margin: const EdgeInsets.only(top: 5, left: 11),
                              child: Text(
                                descriptionsWithBullets,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Container(
                              margin: const EdgeInsets.only(top: 5, left: 11),
                              child:  Text(
                                (userBio!=null && userBio.isNotEmpty) ? userBio : "No Description yet!",
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff5a5a5a),
                                ),
                                textAlign: TextAlign.left,
                              )),
                          previewApplicationTabBody(additionalInfo: widget.additionalinfo,),
                          SizedBox(height: 70.h,),
                        ],
                      ),
                    ),
                  ),
                  if(widget.pageLabel=="Listing Details")
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
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('userId');
    // final firstName = prefs.getString('firstName');
    // final lastName = prefs.getString('lastName');

                                    final userId = LoginData().getUserId();
                                    final firstName = LoginData().getUserFirstName();
                                    final lastName = LoginData().getUserLastName();

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
                                    final firestore = FirebaseFirestore.instance;

                                    try {
                                      // Reference to the specific job listing document
                                      DocumentReference jobRef = firestore.collection('jobListing').doc(widget.listing.docId);

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

                                        // Initialize applicationsApplied as an empty map
                                        Map<String, String> applicationsApplied = {};
                                        print("here");

                                        // Get the data from the studentSnapshot
                                        var studentData = studentSnapshot.data() as Map<String, dynamic>?;

                                        // Check if studentData is not null and contains 'applicationsApplied'
                                        if (studentData != null && studentData.containsKey('applicationsApplied')) {
                                          print("applicationsApplied contained");
                                          applicationsApplied = Map<String, String>.from(studentData['applicationsApplied']);
                                        }

                                        // Add or update the application status
                                        applicationsApplied[widget.listing.docId] = "Pending";
                                        print("applicationsApplied filled");

                                        // Set updated applicationsApplied map in student profile
                                        transaction.set(studentRef, {'applicationsApplied': applicationsApplied}, SetOptions(merge: true));
                                        print("applicationsApplied done");
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
                                        isLoading = false;
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

