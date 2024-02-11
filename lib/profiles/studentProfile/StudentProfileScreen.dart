import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/App%20Constants/colorManager.dart';
import '../../Models/ProfileModels/studentModel.dart';
import '../../App Constants/launchingFunctions.dart';
import 'StudentTabs/tab1_st.dart';
import 'StudentTabs/tab2_st.dart';
import 'StudentTabs/tab3_st.dart';
import 'editProfile/edit_profile.dart';

class StudentProfileScreen extends StatefulWidget{
  const StudentProfileScreen({Key? key}) : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen>
    with SingleTickerProviderStateMixin {
  List gridItems = [];
  String uid=LoginData().getUserId();
  bool isDataLoading=true;
  late TabController _tabController;
  List<bool> _tabSelectedState = [true, false, false];// Initially, the first tab is selected
  late Stream<DocumentSnapshot> profileInfoStream;
  late StudentProfile studentProfile;


  @override
  void initState() {
    // fetchId().then((value) {
    //   setState(() {
    //     isDataLoading = false;
    //     uid = value;
    //   });
    // });
    // gridItems = GridItemData.generateItems();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    profileInfoStream=getStudentProfileStream(uid);
    super.initState();
  }

  void _handleTabChange() {
    setState(() {
      // Reset all tab selected states to false
      _tabSelectedState = [false, false, false];
      // Set the selected tab's state to true
      _tabSelectedState[_tabController.index] = true;
    });
  }

  // Future<String> fetchId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('userId');
  //   return userId!;
  // }
  Stream<DocumentSnapshot> getStudentProfileStream(String uid) {
    return FirebaseFirestore.instance
        .collection('studentProfiles')
        .doc(uid)
        .snapshots();
  }

  double calculateProfileCompletion(Map<String, dynamic> data) {
    int totalCriteria = 12;
    int completedCriteria = 0;

    // Increment completedCriteria for every non-null and non-empty field.
    if (data['firstName'] != null && (data['firstName'] as String).isNotEmpty) completedCriteria++;
    if (data['lastName'] != null && (data['lastName'] as String).isNotEmpty) completedCriteria++;
    if (data['phoneNumber'] != null && (data['phoneNumber'] as String).isNotEmpty) completedCriteria++;
    if (data['userBio'] != null && (data['userBio'] as String).isNotEmpty) completedCriteria++;
    if (data['userEmail'] != null && (data['userEmail'] as String).isNotEmpty) completedCriteria++;
    if (data['userDescription'] != null && (data['userDescription'] as List).isNotEmpty) completedCriteria++;
    if (data['userInsta'] != null && (data['userInsta'] as String).isNotEmpty) completedCriteria++;
    if (data['userTwitter'] != null && (data['userTwitter'] as String).isNotEmpty) completedCriteria++;
    if (data['userLinkedIn'] != null && (data['userLinkedIn'] as String).isNotEmpty) completedCriteria++;
    if (data['userFacebook'] != null && (data['userFacebook'] as String).isNotEmpty) completedCriteria++;
    if (data['projects'] != null && (data['projects'] as List).isNotEmpty) completedCriteria++;
    if (data['Work Experience'] != null && (data['Work Experience'] as List).isNotEmpty) completedCriteria++;
   // if (data['userGmail'] != null && (data['userGmail'] as String).isNotEmpty) completedCriteria++;

    return completedCriteria / totalCriteria;
  }


  Widget buildProfileCompletionView(Map<String, dynamic> data) {
    double completionPercentage = calculateProfileCompletion(data);
    List<String> incompleteItems = [];

    // Check which items are incomplete and add them to the list
    if (data['firstName'] == null || (data['firstName'] as String).isEmpty) incompleteItems.add('Name');
    if (data['phoneNumber'] == null || (data['phoneNumber'] as String).isNotEmpty) incompleteItems.add('Phone Number');
    if (data['userBio'] == null || (data['userBio'] as String).isNotEmpty) incompleteItems.add('Bio');
    if (data['userEmail'] == null || (data['userEmail'] as String).isNotEmpty) incompleteItems.add('Email');
    if (data['userDescription'] == null || (data['userDescription'] as List).isNotEmpty) incompleteItems.add('Description');
    if (data['userInsta'] == null || (data['userInsta'] as String).isNotEmpty) incompleteItems.add('Instagram Handle');
    if (data['userTwitter'] == null || (data['userTwitter'] as String).isNotEmpty) incompleteItems.add('Twitter Handle');
    if (data['userLinkedIn'] == null || (data['userLinkedIn'] as String).isNotEmpty) incompleteItems.add('LinkedIn Handle ');
    if (data['userFacebook'] == null || (data['userFacebook'] as String).isNotEmpty) incompleteItems.add('Facebook Handle');
    if (data['projects'] == null || (data['projects'] as List).isNotEmpty) incompleteItems.add('Projects');
    if (data['Work Experience'] == null || (data['Work Experience'] as List).isNotEmpty) incompleteItems.add('Work Experience');
   // if (data['userGmail'] == null || (data['userGmail'] as String).isEmpty) incompleteItems.add('Gmail');


    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: completionPercentage,
                minHeight: 10, // Set the height of the progress bar
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 8), // Spacing between progress bar and text
              Text(
                'Profile Completion: ${completionPercentage * 100}%',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        if (incompleteItems.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            'Incomplete Items:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...incompleteItems.map((item) => Text(item)).toList(),
        ],
      ],
    );
  }

  Widget buildCustomProgressBar(double completionPercentage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Curved borders
      child: LinearProgressIndicator(
        value: completionPercentage,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange), // Specified color
        minHeight: 10,
      ),
    );
  }

  Widget buildProgressBarWithPercentage(double completionPercentage) {
    return Row(
      children: [
        Expanded(
          child: buildCustomProgressBar(completionPercentage),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text('${(completionPercentage * 100).toStringAsFixed(0)}%'), // Rounded percentage
        ),
      ],
    );
  }

  GestureDetector buildProfileCompletionIndicator(Map<String, dynamic> data, BuildContext context) {
    double completionPercentage = calculateProfileCompletion(data);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => buildCompletionDialog(data,context),
        );
      },
      child: buildProgressBarWithPercentage(completionPercentage),
    );
  }

  Widget buildCompletionDialog(Map<String, dynamic> data, BuildContext context) {
    List<Widget> buildListItems() {
      List<Widget> listItems = [];

      Widget createListItem(String fieldName, String title, dynamic value) {
        return ListTile(
          title: Text(title),
          leading: Icon(
            value?.isNotEmpty ?? false ? Icons.check_circle : Icons.radio_button_unchecked,
            color: value?.isNotEmpty ?? false ? Colors.green : Colors.grey,
          ),
        );
      }

      // Add list items for each field
      listItems.add(createListItem('userProfilePicture', 'Add a Profile Picture', data['userProfilePicture']));
      listItems.add(createListItem('firstName', 'Add First Name', data['firstName']));
      listItems.add(createListItem('lastName', 'Add Last Name', data['lastName']));
      listItems.add(createListItem('phoneNumber', 'Add Phone Number', data['phoneNumber']));
      listItems.add(createListItem('userBio', 'Add a Bio', data['userBio']));
      listItems.add(createListItem('userDescription', 'Add User Description', data['userDescription']));
      listItems.add(createListItem('userEmail', 'Add Email', data['userEmail']));
      listItems.add(createListItem('userInsta', 'Add Instagram', data['userInsta']));
      listItems.add(createListItem('userTwitter', 'Add Twitter', data['userTwitter']));
      listItems.add(createListItem('userLinkedIn', 'Add LinkedIn', data['userLinkedIn']));
      listItems.add(createListItem('userFacebook', 'Add Facebook', data['userFacebook']));
      listItems.add(createListItem('projects', 'Add Projects', data['projects']));
      listItems.add(createListItem('Work Experience', 'Add Work Experience', data['Work Experience']));
     // listItems.add(createListItem('userGmail', 'Add Gmail', data['userGmail']));

      return listItems;
    }

    return AlertDialog(
      title: Text('Complete your profile'),
      content: SingleChildScrollView(
        child: ListBody(children: buildListItems()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Complete later'),
        ),
      ],
    );
  }






  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: profileInfoStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        // if (!snapshot.hasData || !snapshot.data!.exists) {
        //   return Center(child: Text("No data found"));
        // }
else{
          var projectsList = <dynamic>[];
          var workList = <dynamic>[];
          var userDescriptionList=<dynamic>[];
          String userName="";
          String descriptionsWithBullets="";
          String userProfilePic="";
          String userBio="";
          var data;

          // Check if the snapshot has data and is not null.
          if (snapshot.hasData && snapshot.data!.data() != null) {
             data = snapshot.data!.data() as Map<String, dynamic>;
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
            body: Material(
              child: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        expandedHeight:305,
                        floating: true,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap:(){
                              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return EditProfile(studentProfile: studentProfile,);
                              }));
                              },
                                      child: Material(
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

                                            Material(
                                              elevation: 4,
                                              shape: CircleBorder(),
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                margin: EdgeInsets.only(right: 2, bottom: 3),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/edit.svg",
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                           LaunchingFunction().bottomSheet(
                                               context: context,
                                               userPhoneNumber: studentProfile.phoneNumber!,
                                               userFaceBook: studentProfile.userFacebook!,
                                               userTwitter: studentProfile.userTwitter!,
                                               userInsta: studentProfile.userInsta!,
                                               userLinkedIn: studentProfile.userLinkedin!,
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
                                        SizedBox(width: 10.w,),
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

                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                    return EditProfile(studentProfile: studentProfile,);
                                  }));
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(top: 5, left: 11),
                                    child:  Text(
                                        (userBio!=null && userBio.isNotEmpty) ? userBio : "How would you like to describe yourself?",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff5a5a5a),
                                      ),
                                      textAlign: TextAlign.left,
                                    )),
                              ),
                              SizedBox(height: 8,),
                              // Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: LinearProgressIndicator(
                              //     value: calculateProfileCompletion(data),
                              //     backgroundColor: Colors.grey[300],
                              //     valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: buildProfileCompletionIndicator(data,context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            indicatorColor: Colors.black,
                            tabs: [
                              Tab(
                                child:  SvgPicture.asset("assets/tab1_st_s.svg",color: _tabSelectedState[0] ?Colors.black : ColorsManager.unSelectedTabColor,)),
                              Tab(
                                child: SvgPicture.asset("assets/tab2_s.svg",color: _tabSelectedState[1]? Colors.black : ColorsManager.unSelectedTabColor,)),

                              Tab(
                                child: SvgPicture.asset(
                                  "assets/tab4_s.svg", color: _tabSelectedState[2]? Colors.black : ColorsManager.unSelectedTabColor,)
                              ),
                            ],
                          ),
                        ),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children:  const [
                      Tab1St(),
                      // tabThree(),
                      // tabFour(),
                      Tab2St(),
                      Tab3St(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

      }
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
