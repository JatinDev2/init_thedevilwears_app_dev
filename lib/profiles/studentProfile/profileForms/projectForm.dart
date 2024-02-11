import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import '../../../Models/formModels/projectModel.dart';

class AddNewProjectForm extends StatefulWidget {
  const AddNewProjectForm({super.key});

  @override
  State<AddNewProjectForm> createState() => _AddNewProjectFormState();
}

class _AddNewProjectFormState extends State<AddNewProjectForm> {
  final _formKey = GlobalKey<FormState>();
  bool isOpen = false;
  bool isLoading = false;
  TextEditingController projectHeading = TextEditingController();
  TextEditingController projectType = TextEditingController();
  TextEditingController projectLink = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          isOpen = myFocusNode.hasFocus;
        });
      }
    });
  }

  Future<bool> addProjectToUserProfile(
      String userId, ProjectModel project) async {
    if (userId.isEmpty) {
      print('User ID is null or empty');
      return false;
    }

    Map<String, dynamic> projectData = project.toJson();
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Profiles').doc(userId);

    try {
      await userDoc.set({
        'projects': FieldValue.arrayUnion([projectData])
      }, SetOptions(merge: true));
      print('Project added successfully');
      return true;
    } catch (error) {
      print('Error adding project: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Add a project",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff0f1015),
            height: 20 / 16,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            left: 22,
            right: 22,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 25.h,
                ),
                const Text(
                  "Project heading",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: projectHeading,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "eg: Fashion Stylist|",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffb2b2b2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Project Heading.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffE7E7E7),
                ),
                const SizedBox(
                  height: 13,
                ),
                const Text(
                  "Project type",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: projectType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "eg: Fashion Styling",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffb2b2b2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the project type.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffE7E7E7),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  "Project Link",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                  ),
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: projectLink,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Paste your project link here|",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffb2b2b2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the project link.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffE7E7E7),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2d2d2d),
                    height: (24 / 16),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  height: 238.h,
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F7F7),
                      borderRadius: BorderRadius.circular(14.0.r)),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    controller: descriptionText,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          "Mention your key achievements, responsibilities or learnings",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    onChanged: (value) {},
                    maxLines: 8,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // final prefs = await SharedPreferences.getInstance();
                          // final userId = prefs.getString('userId');
                          final userId = LoginData().getUserId();

                          final projectData = ProjectModel(
                              projectHeading: projectHeading.text,
                              projectType: projectType.text,
                              projectLink: projectLink.text,
                              description: descriptionText.text);
                          if (_formKey.currentState!.validate()) {
                            await addProjectToUserProfile(userId!, projectData)
                                .then((value) {
                              if (value == true) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pop();
                              }
                            });
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
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Publish",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff010100),
                                        height: (24 / 16).h,
                                      ),
                                      textAlign: TextAlign.left,
                                    )),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height:
                      isOpen ? 238.0 : 0, // Adjust height based on the focus
                  // You can also add curve for the animation
                  curve: Curves.easeOut,
                  child: Container(
                      // Content of the container, if any
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
