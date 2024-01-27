import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/colorManager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profileForms/educationForm.dart';
import '../profileForms/projectForm.dart';
import '../profileForms/skillsForm.dart';
import '../profileForms/workExperienceForm.dart';
import '../profileModels/educationModel.dart';
import '../profileModels/projectModel.dart';
import '../profileModels/workModel.dart';

class Tab1St extends StatefulWidget {
  const Tab1St({super.key});

  @override
  State<Tab1St> createState() => _Tab1StState();
}

class _Tab1StState extends State<Tab1St> {
  String uid = LoginData().getUserId();

  DateTime _getStartDate(String dateRange) {
    try {
      final dateFormat = DateFormat("MM/dd/yyyy");
      return dateFormat.parse(dateRange.split(" - ").first);
    } catch (e) {
      // Handle the exception by returning a default date,
      // such as the current date or DateTime(1970, 1, 1) for an invalid date.
      return DateTime.now();
    }
  }

  Future<void> storeSkills() async {
    final List<String> skills = [
      "Attention to detail",
      "Analytical thinking",
      "Adaptability",
      "Collaboration",
      "Curiosity",
      "Customer service skills",
      "Community management",
      "Communication",
      "Empathy",
      "Leadership skills",
      "Networking skills",
      "Open mindedness",
      "Problem solving",
      "Patience",
      "Positive attitude",
      "Time management",
    ];

    final CollectionReference jobSkills = FirebaseFirestore.instance.collection('jobSkills');

    await jobSkills.doc('Soft Skills').set({
      'Soft Skills': skills,
    }).then((_) {
      print('Document successfully written!');
    }).catchError((error) {
      print('Error writing document: $error');
    });
  }

  Future<void> storehardSkills() async {
    final List<String> hardSkills = [
      "After effects",
      "Ads creating and management",
      "Budgeting & financial analysis",
      "Brand strategy development",
      "CAD",
      "Content creation & management",
      "Competitive analysis",
      "Content creation & management",
      "Copywriting",
      "Draping",
      "Dyeing",
      "Digital marketing",
      "Data analytics",
      "Grading",
      "Graphic design",
      "Illustration",
      "Adobe Creative Suite",
      "Khakha making",
      "Market research & analysis",
      "Merchandising",
      "Project management",
      "Public relations",
      "Print making",
      "Premier pro",
      "Pattern making",
      "Photoshop",
      "Quality Control",
      "Sketching",
      "Sewing & garment construction",
      "Styling",
      "Social media",
      "SEO",
      "Trend forecasting",
      "Technical drawing",
      "Textile designing",
      "Textile knowledge",
      "Video editing",
      "Whatsapp marketing",
      "3D modelling softwares"
    ];


    final CollectionReference jobSkills = FirebaseFirestore.instance.collection('jobSkills');

    await jobSkills.doc('Hard Skills').set({
      'Hard Skills': hardSkills,
    }).then((_) {
      print('Document successfully written!');
    }).catchError((error) {
      print('Error writing document: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('studentProfiles')
                  .doc(uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                }
                // if (!snapshot.hasData || !snapshot.data!.exists) {
                //   return const Text("Document does not exist");
                // }
                // Extracting data from the snapshot
                var projectsList = <dynamic>[];
                var workList = <dynamic>[];
                var educationList=<dynamic>[];
                var hardSkills=<dynamic>[];
                var softSkills=<dynamic>[];
                List<String> hardSkillsStringList = [];
                List<String> softSkillsStringList = [];
                List<ProjectModel> projects=[];
                List<WorkModel> workExperiences=[];
                List<EducationModel> educationEntries=[];

                // Check if the snapshot has data and is not null.
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                   projectsList = (data['projects'] is List<dynamic>) ? List<dynamic>.from(data['projects']) : [];
                   workList = (data['Work Experience'] is List<dynamic>) ? List<dynamic>.from(data['Work Experience']) : [];
                   educationList = (data['Education'] is List<dynamic>) ? List<dynamic>.from(data['Education']) : [];
                   hardSkills = (data['Hard Skills'] is List<dynamic>) ? List<dynamic>.from(data['Hard Skills']) : [];
                   hardSkillsStringList = hardSkills.map((skill) => skill.toString()).toList();

                   softSkills = (data['Soft Skills'] is List<dynamic>) ? List<dynamic>.from(data['Soft Skills']) : [];
                   softSkillsStringList = softSkills.map((skill) => skill.toString()).toList();
                  projects = projectsList
                      .map((projectData) => ProjectModel.fromMap(projectData))
                      .toList();
                  workExperiences = workList.map((workData) => WorkModel.fromMap(workData)).toList();
                  workExperiences.sort((a, b) {
                    return _getStartDate(b.timePeriod).compareTo(_getStartDate(a.timePeriod));
                  });

                educationEntries = educationList.map((educationData) => EducationModel.fromMap(educationData)).toList();
                  educationEntries.sort((a, b) {
                    return _getStartDate(b.timePeriod).compareTo(_getStartDate(a.timePeriod));
                  });
                }

                // var data = snapshot.data?.data() as Map<String, dynamic>;
                // var projectsList = data['projects'] as List<dynamic> ?? [];
                // var workList = data['Work Experience'] as List<dynamic> ?? [];
                // var educationList = data['Education'] as List<dynamic> ?? [];

                // educationList.sort((a, b) {
                //   return _getStartDate(b.timePeriod).compareTo(_getStartDate(a.timePeriod));
                // });

                // Converting data into model instances


                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Projects
                      Header(
                        label: "My Projects",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (projects.isEmpty)
                         GestureDetector(
                           onTap: (){
                               Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                 return AddNewProjectForm();
                               }));
                           },
                           child: Center(child: Row(
                            children: [
                              Container(
                                padding:const EdgeInsets.all(14),
                                decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManager.lightPink,
                                ),
                                child: SvgPicture.asset("assets/project.svg"),
                              ),
                             const SizedBox(width: 8,),
                             const Text(
                                "Add your projects",
                                style:  TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000),
                                  height: 19/14,
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                                                   )),
                         ),
                     ...projects.map((project) => ProjectCard(
                            title: project.projectHeading,
                            subtitle: project.projectType,
                            description: project.description,
                        link: project.projectLink,
                          )),
                      // Work Experience
                      SizedBox(
                        height: 30.h,
                      ),
                      Header(
                        label: "My Work Experience",
                      ),
                      const  SizedBox(
                        height: 20,
                      ),
                      if (workExperiences.isEmpty)
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                              return AddNewWorkExperience();
                            }));
                          },
                          child: Center(child: Row(

                            children: [
                              Container(
                                padding:const EdgeInsets.all(14),
                                decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManager.lightPink,
                                ),
                                child: SvgPicture.asset("assets/work.svg"),
                              ),
                              const SizedBox(width: 8,),
                              const Text(
                                "Add your work experiences",
                                style:  TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000),
                                  height: 19/14,
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          )),
                        ),

                      ...workExperiences.map((work) => WorkCard(
                            // Map WorkModel properties to WorkCard widget
                            description: work.description,
                            companyName: work.companyName,
                            projectLink: work.projectLink,
                            roleInCompany: work.roleInCompany,
                            timePeriod: work.timePeriod,
                            workType: work.workType,
                            location: work.location,
                        link: work.projectLink,
                        status: work.status,
                          )),
                      // Education
                      SizedBox(
                        height: 30.h,
                      ),
                      Header(
                        label: "My Education",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (educationEntries.isEmpty)
                        GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return AddNewEducationForm();
                              }));
                            },

                          child: Center(child: Row(

                            children: [
                              Container(
                                padding:const EdgeInsets.all(14),
                                decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorsManager.lightPink,
                                ),
                                child: SvgPicture.asset("assets/education.svg"),
                              ),
                              const SizedBox(width: 8,),
                              const Text(
                                "Add your education",
                                style:  TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000),
                                  height: 19/14,
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          )),
                        ),
                      ...educationEntries.map((education) => EducationCard(
                            // Map EducationModel properties to EducationCard widget
                            description: education.description,
                            timePeriod: education.timePeriod,
                            location: education.location,
                            degreeName: education.degreeName,
                            instituteName: education.instituteName,
                          )),
                      // Rest of your widgets...
                      SizedBox(
                        height: 30.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4),
                        child: const Text(
                          "My Skillset",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1a1a1a),
                            height: 19 / 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Header(
                        label: "Hard skills",
                      ),
                      TagChips(
                        label: "Hard skills",
                        tags: hardSkillsStringList,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Header(
                        label: "Soft skills",
                      ),
                      TagChips(
                        label: "Soft skills",
                        tags: softSkillsStringList,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class Header extends StatelessWidget {
  final String label;

  Header({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize:
                  (label == "Hard skills" || label == "Soft skills") ? 14 : 24,
              fontWeight: (label == "Hard skills" || label == "Soft skills")
                  ? FontWeight.w500
                  : FontWeight.bold,
              color: const Color(0xff1a1a1a),
              height: 19 / 16,
            ),
            textAlign: TextAlign.left,
          ),
          // IconButton(
          //   icon:
          if (label != "Hard skills" && label != "Soft skills")
            GestureDetector(
                onTap: () {
                  if (label == "My Work Experience") {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return AddNewWorkExperience();
                    }));
                  } else if (label == "My Projects") {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return AddNewProjectForm();
                    }));
                  } else if (label == "My Education") {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return AddNewEducationForm();
                    }));
                  }
                },
                child: const Icon(Icons.add, size: 20.0)),

          if (label == "Hard skills")
            const Text(
              "Delete all",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff000000),
                height: 18 / 12,
              ),
              textAlign: TextAlign.left,
            ),
          if (label == "Soft skills")
            const Text(
              "Delete all",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff000000),
                height: 18 / 12,
              ),
              textAlign: TextAlign.left,
            ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String link;

  const ProjectCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.pink.shade100,
          ),
          SizedBox(width: 13.0.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                    height: 19 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    height: 19 / 12,
                  ),
                  textAlign: TextAlign.left,
                ),
                InkWell(
                  onTap: () async{
                    String url=link;
                    if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                    } else {
                    print('Could not launch $url');
                    }
                  },
                  child: const Text(
                    "Check out my work",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xfff54e44),
                      height: 19 / 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (description.isNotEmpty)
                  ExpandableText(
                    description, // Your text goes here
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
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
                    prefixText: "Description",
                    prefixStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    animation: true,
                    animationDuration: Duration(milliseconds: 500), // Custom animation duration
                    animationCurve: Curves.easeInOut, // Custom animation curve
                    collapseOnTextTap: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkCard extends StatelessWidget {
  final String roleInCompany;
  final String workType;
  final String companyName;
  final String timePeriod;
  final String description;
  final String projectLink;
  final String location;
  final String link;
  final String status;

  const WorkCard({
    Key? key,
    required this.description,
    required this.companyName,
    required this.projectLink,
    required this.roleInCompany,
    required this.timePeriod,
    required this.workType,
    required this.location,
    required this.link,
    required this.status,
  }) : super(key: key);

  String formatTimePeriod(String timePeriod) {
    final dates = timePeriod.split(" - ");
    if (dates.length != 2) {
      return timePeriod; // Return the original string if it's not in the expected format
    }

    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputDayMonthFormat = DateFormat("dd MMM");
    DateFormat outputMonthYearFormat = DateFormat("MMMM yyyy");

    try {
      final DateTime startDate = inputFormat.parse(dates[0].trim());
      final DateTime endDate = inputFormat.parse(dates[1].trim());

      if (startDate.month == endDate.month && startDate.year == endDate.year) {
        // If start and end dates are in the same month and year, format as "05 Jan - 25 Jan 2024"
        final String startDayMonth = outputDayMonthFormat.format(startDate);
        final String endDayMonth = outputDayMonthFormat.format(endDate);
        return "$startDayMonth - $endDayMonth ${startDate.year}";
      } else {
        // If start and end dates are not in the same month and year, format as "January 2024 - February 2024"
        final String startMonthYear = outputMonthYearFormat.format(startDate);
        final String endMonthYear = outputMonthYearFormat.format(endDate);
        return "$startMonthYear - $endMonthYear";
      }
    } catch (e) {
      return timePeriod; // Return the original string if parsing fails
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.pink.shade100,
            // child: Text(
            //   iconLetter,
            //   style: TextStyle(
            //     fontSize: 24.sp,
            //     color: Colors.red,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
          SizedBox(width: 13.0.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "$roleInCompany • $workType",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                    height: 19 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "$companyName, $location",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    height: 19 / 12,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  formatTimePeriod(timePeriod),
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    height: 19 / 12,
                  ),
                  textAlign: TextAlign.left,
                ),
                if(link.isNotEmpty)
                InkWell(
                  onTap: () async{
                    String url=link;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      print('Could not launch $url');
                    }
                  },
                  child: const Text(
                    "Check out my work",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xfff54e44),
                      height: 19 / 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (description.isNotEmpty)
                  ExpandableText(
                    description, // Your text goes here
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
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
                    prefixText: "Role",
                    linkEllipsis: true,
                    prefixStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    animation: true,
                    animationDuration: Duration(milliseconds: 500), // Custom animation duration
                    animationCurve: Curves.easeInOut, // Custom animation curve
                    collapseOnTextTap: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String timePeriod;
  final String description;
  final String location;
  final String instituteName;
  final String degreeName;

  const EducationCard({
    Key? key,
    required this.description,
    required this.timePeriod,
    required this.location,
    required this.degreeName,
    required this.instituteName,
  }) : super(key: key);

  String formatTimePeriod(String timePeriod) {
    final dates = timePeriod.split(" - ");
    if (dates.length != 2) {
      return timePeriod; // Return the original string if it's not in the expected format
    }

    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputYearFormat = DateFormat("yyyy");
    DateFormat outputMonthYearFormat = DateFormat("MMMM yyyy");

    try {
      final DateTime startDate = inputFormat.parse(dates[0].trim());
      final DateTime endDate = inputFormat.parse(dates[1].trim());

      // If years are the same, format as "January 2024 - February 2024"
      if (startDate.year == endDate.year) {
        final String startMonthYear = outputMonthYearFormat.format(startDate);
        final String endMonthYear = endDate.month == startDate.month
            ? outputYearFormat.format(endDate)
            : outputMonthYearFormat.format(endDate);
        return "$startMonthYear - $endMonthYear";
      } else {
        // If years are not the same, format as "2024 - 2028"
        final String startYear = outputYearFormat.format(startDate);
        final String endYear = outputYearFormat.format(endDate);
        return "$startYear - $endYear";
      }
    } catch (e) {
      return timePeriod; // Return the original string if parsing fails
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.pink.shade100,
            // child: Text(
            //   iconLetter,
            //   style: TextStyle(
            //     fontSize: 24.sp,
            //     color: Colors.red,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
          SizedBox(width: 13.0.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  instituteName,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                    height: 19 / 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  degreeName,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    height: 19 / 12,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "$location, India • ${formatTimePeriod(timePeriod)}",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    height: 19 / 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              if (description.isNotEmpty)
      ExpandableText(
      description, // Your text goes here
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
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
      prefixText: "Description",
      prefixStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.black,
      ),
      animation: true,
        linkEllipsis: true,
      animationDuration: Duration(milliseconds: 500), // Custom animation duration
      animationCurve: Curves.easeInOut, // Custom animation curve
      collapseOnTextTap: true,
    ),
            ]),
          ),
        ],
      ),
    );
  }
}

class TagChips extends StatefulWidget {
  final String label;
  final List<String> tags;

   TagChips({
    Key? key,
    required this.label,
    required this.tags,
  }) : super(key: key);

  @override
  State<TagChips> createState() => _TagChipsState();
}

class _TagChipsState extends State<TagChips> {

  Future<bool> updateSkills(String tag) async {
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('userId');
    final userId = LoginData().getUserId();

    if (userId!.isEmpty) {
      print('User ID is null or empty');
      return false;
    }

    DocumentReference userDoc =
    FirebaseFirestore.instance.collection('studentProfiles').doc(userId);

    try {
      if(widget.label=="Hard skills"){
        await userDoc.set({
          'Hard Skills': FieldValue.arrayRemove([tag])
        },SetOptions(merge: true));
        print('Skill removed successfully');
      }
      else{
        await userDoc.set({
          'Soft Skills': FieldValue.arrayRemove([tag])
        },SetOptions(merge: true));
        print('Skill removed successfully');
      }

      return true;
    } catch (error) {
      print('Error removing skill: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chipList = [
      _buildAddChip(context), // Add the static "Add" chip at the beginning
      ...widget.tags
          .map((tag) => _buildChip(context, tag))
          .toList(), // Add the rest of the tag chips
    ];

    return Wrap(
      spacing: 1.0, // Gap between adjacent chips
      runSpacing: 0.0, // Gap between lines
      children: chipList,
    );
  }

  Widget _buildAddChip(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(top: 2.0, right: 7.0, bottom: 7.0),
      child: GestureDetector(
        onTap: () {
          print("ADD CHIP CLICKED WITH LABEL ${widget.label}");

          Map<String,bool> selectedOptions={};
          for(int i=0; i< widget.tags.length ; i++){
            selectedOptions[widget.tags[i]]=true;
          }
          if(widget.label=="Hard skills"){
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return SkillsSelectionScreen(label: "Hard Skills", selectedoptions: selectedOptions,);
            }));
          }
          else{
            Navigator.of(context).push(MaterialPageRoute(builder: (_){
              return SkillsSelectionScreen(label: "Soft Skills", selectedoptions: selectedOptions,);
            }));
          }

        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20.0), // Stadium shape
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add,
                size: 18.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String tag) {
    return Container(
      margin: const EdgeInsets.only(
          top: 2.0,
          right: 7.0,
          bottom: 7.0), // Adjust the margin for tighter packing
      child: GestureDetector(
        onTap: () {
          // Define the action when the chip is tapped if necessary
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Color(0xffF7F7F7),
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20.0), // Stadium shape
          ),
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Use the minimum space that's needed by the child widgets
            children: [
              Text(
                tag,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff303030),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              GestureDetector(
                onTap: () {
                  // setState((){
                  //   // widget.tags.remove(tag);
                  // });
                  updateSkills(tag);

                },
                child: Icon(
                  Icons.close,
                  size: 13.0,
                  color: Color(0xff303030),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
