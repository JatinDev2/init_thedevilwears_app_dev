import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../colorManager.dart';
import '../../profile/profileForms/skillsForm.dart';
import '../../profile/profileModels/educationModel.dart';
import '../../profile/profileModels/projectModel.dart';
import '../../profile/profileModels/workModel.dart';

class previewApplicationTabBody extends StatefulWidget {
  final String additionalInfo;

  // const previewApplicationTabBody({super.key});
  previewApplicationTabBody({
    required this.additionalInfo,
  });

  @override
  State<previewApplicationTabBody> createState() =>
      _previewApplicationTabBodyState();
}

class _previewApplicationTabBodyState extends State<previewApplicationTabBody> {
  String uid = LoginData().getUserId();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('studentProfiles')
            .doc(uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          var educationList = <dynamic>[];
          var hardSkills = <dynamic>[];
          var softSkills = <dynamic>[];
          List<String> hardSkillsStringList = [];
          List<String> softSkillsStringList = [];
          List<ProjectModel> projects = [];
          List<WorkModel> workExperiences = [];
          List<EducationModel> educationEntries = [];

          // Check if the snapshot has data and is not null.
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            projectsList = (data['projects'] is List<dynamic>)
                ? List<dynamic>.from(data['projects'])
                : [];
            workList = (data['Work Experience'] is List<dynamic>)
                ? List<dynamic>.from(data['Work Experience'])
                : [];
            educationList = (data['Education'] is List<dynamic>)
                ? List<dynamic>.from(data['Education'])
                : [];
            hardSkills = (data['Hard Skills'] is List<dynamic>)
                ? List<dynamic>.from(data['Hard Skills'])
                : [];
            hardSkillsStringList =
                hardSkills.map((skill) => skill.toString()).toList();

            softSkills = (data['Soft Skills'] is List<dynamic>)
                ? List<dynamic>.from(data['Soft Skills'])
                : [];
            softSkillsStringList =
                softSkills.map((skill) => skill.toString()).toList();
            projects = projectsList
                .map((projectData) => ProjectModel.fromMap(projectData))
                .toList();
            workExperiences = workList
                .map((workData) => WorkModel.fromMap(workData))
                .toList();
            workExperiences.sort((a, b) {
              return _getStartDate(b.timePeriod)
                  .compareTo(_getStartDate(a.timePeriod));
            });

            educationEntries = educationList
                .map((educationData) => EducationModel.fromMap(educationData))
                .toList();
            educationEntries.sort((a, b) {
              return _getStartDate(b.timePeriod)
                  .compareTo(_getStartDate(a.timePeriod));
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      decoration: BoxDecoration(
                          color: Color(0xffF9F9F9),
                          borderRadius: BorderRadius.circular(12.0.r)),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.only(top: 0, bottom: 6, left: 8),
                              child: Text(
                                "Additional Info",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1a1a1a),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.additionalInfo,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff000000),
                                  height: 16 / 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),

              // Projects
              Header(
                label: "Projects",
              ),
              SizedBox(
                height: 20,
              ),
              if (projects.isEmpty)
                Center(
                    child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsManager.lightPink,
                      ),
                      child: SvgPicture.asset("assets/project.svg"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "No projects added yet",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                        height: 19 / 14,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                )),
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
                label: "Work Experience",
              ),
              SizedBox(
                height: 20,
              ),
              if (workExperiences.isEmpty)
                Center(
                    child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsManager.lightPink,
                      ),
                      child: SvgPicture.asset("assets/work.svg"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "No work experiences yet",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                        height: 19 / 14,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                )),

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
                  )),
              // Education
              SizedBox(
                height: 30.h,
              ),
              Header(
                label: "Education",
              ),
              SizedBox(
                height: 20,
              ),
              if (educationEntries.isEmpty)
                Center(
                    child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsManager.lightPink,
                      ),
                      child: SvgPicture.asset("assets/education.svg"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "No education yet",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff000000),
                        height: 19 / 14,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                )),
              ...educationEntries.map((education) => EducationCard(
                    // Map EducationModel properties to EducationCard widget
                    description: education.description,
                    timePeriod: education.timePeriod,
                    location: education.location,
                    degreeName: education.degreeName,
                    instituteName: education.instituteName,
                  )),
              // Rest of your widgets...
              // SizedBox(
              //   height: 30.h,
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 4),
              //   child: Text(
              //     "Skillset",
              //     style: const TextStyle(
              //       fontFamily: "Poppins",
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //       color: Color(0xff1a1a1a),
              //       height: 19 / 16,
              //     ),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Header(
              //   label: "Hard skills",
              // ),
              // TagChips(
              //   label: "Hard skills",
              //   tags: hardSkillsStringList,
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Header(
              //   label: "Soft skills",
              // ),
              // TagChips(
              //   label: "Soft skills",
              //   tags: softSkillsStringList,
              // ),
            ],
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
                  (label == "Hard skills" || label == "Soft skills") ? 14 : 16,
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
                  onTap: () async {
                    String url = link;
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
                    animationDuration: Duration(
                        milliseconds: 500), // Custom animation duration
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
                if (link.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      String url = link;
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
                    animationDuration: Duration(
                        milliseconds: 500), // Custom animation duration
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
                      animationDuration: Duration(
                          milliseconds: 500), // Custom animation duration
                      animationCurve:
                          Curves.easeInOut, // Custom animation curve
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
        FirebaseFirestore.instance.collection('Profiles').doc(userId);

    try {
      await userDoc.set({
        'Hard Skills': FieldValue.arrayRemove([tag])
      }, SetOptions(merge: true));
      print('Skill removed successfully');
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

  Widget _buildAddChip(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2.0, right: 7.0, bottom: 7.0),
      child: GestureDetector(
        onTap: () {
          print("ADD CHIP CLICKED WITH LABEL ${widget.label}");

          Map<String, bool> selectedOptions = {};
          for (int i = 0; i < widget.tags.length; i++) {
            selectedOptions[widget.tags[i]] = true;
          }
          if (widget.label == "Hard skills") {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return SkillsSelectionScreen(
                label: "Hard Skills",
                selectedoptions: selectedOptions,
              );
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return SkillsSelectionScreen(
                label: "Soft Skills",
                selectedoptions: selectedOptions,
              );
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
