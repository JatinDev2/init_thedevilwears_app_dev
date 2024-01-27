import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Preferences/LoginData.dart';

class SkillsSelectionScreen extends StatefulWidget {

  final String label;
  final Map<String, bool> selectedoptions;

  SkillsSelectionScreen({
    required this.label,
    required this.selectedoptions,
});

  @override
  _SkillsSelectionScreenState createState() => _SkillsSelectionScreenState();
}

class _SkillsSelectionScreenState extends State<SkillsSelectionScreen> {
  bool isLoading = false;
  Map<String, bool> selectedSkills = {};
  late  Future<List<String>?> skillsFuture;
  void initState() {
    super.initState();
    print("label is ${widget.label}");
    if(widget.label=="Soft Skills"){
      skillsFuture=fetchSoftSkills();
    }
     if(widget.label=="Hard Skills"){
      skillsFuture=fetchHardSkills();
    }
    if(widget.selectedoptions.isNotEmpty){
      selectedSkills.addAll(widget.selectedoptions);
    }
  }
  Future<bool> addSoftSkillsToUserProfile(List<String> selectedSkillsList) async {
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('userId');

    final userId = LoginData().getUserId();

    if (userId!.isEmpty) {
      print('User ID is null or empty');
      return false;
    }
    setState(() {
      isLoading=true;
    });

    DocumentReference userDoc =
    FirebaseFirestore.instance.collection('studentProfiles').doc(userId);
    try {
      await userDoc.set({
        'Soft Skills': selectedSkillsList
        }, SetOptions(merge: true));
      print('Work added successfully');
      return true;
    } catch (error) {
      print('Error adding Work: $error');
      return false;
    }
  }

  Future<bool> addSkillsToUserProfile(List<String> selectedSkillsList) async {
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('userId');
    final userId = LoginData().getUserId();

    if (userId!.isEmpty) {
      print('User ID is null or empty');
      return false;
    }
    setState(() {
      isLoading=true;
    });

    DocumentReference userDoc =
    FirebaseFirestore.instance.collection('studentProfiles').doc(userId);
    try {
      await userDoc.set({
        'Hard Skills': selectedSkillsList
      }, SetOptions(merge: true));
      print('Work added successfully');
      return true;
    } catch (error) {
      print('Error adding Work: $error');
      return false;
    }
  }


  Future<List<String>> fetchSoftSkills() async {
    final DocumentReference softSkillsDoc = FirebaseFirestore.instance.collection('jobSkills').doc('Soft Skills');

    List<String> softSkillsList = [];

    try {
      DocumentSnapshot snapshot = await softSkillsDoc.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        softSkillsList = List<String>.from(data['Soft Skills']);
        print('Document successfully read!');
      } else {
        print('No such document!');
      }
    } catch (error) {
      print('Error reading document: $error');
    }

    return softSkillsList;
  }

  Future<List<String>> fetchHardSkills() async {
    final DocumentReference hardSkillsDoc = FirebaseFirestore.instance.collection('jobSkills').doc('Hard Skills');

    List<String> hardSkillsList = [];

    try {
      DocumentSnapshot snapshot = await hardSkillsDoc.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        hardSkillsList = List<String>.from(data['Hard Skills']);
        print('Document successfully read!');
      } else {
        print('No such document!');
      }
    } catch (error) {
      print('Error reading document: $error');
    }

    return hardSkillsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black,), onPressed: (){
          Navigator.of(context).pop();
        },),
        backgroundColor: Colors.white,
        title: const Text(
          "Skillset",
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
      body: FutureBuilder<List<String>?>(
        future: skillsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No skills found'));
          } else {
            List<String> skills = snapshot.data!;
            for (var skill in skills) {
              if (!selectedSkills.containsKey(skill)) {
                selectedSkills[skill] = false;
              }
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Which of these best describe your skills?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Hard Skills",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Wrap(
                        spacing: 3.0,
                        runSpacing: 1.0,
                        children: skills.map((skill) => ChoiceChip(
                          label: Text(skill),
                          selected: selectedSkills[skill]!,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedSkills[skill] = selected;
                            });
                          },
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: selectedSkills[skill]! ? Colors.white : Colors.black,
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          backgroundColor: Colors.grey[200],
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        )).toList(),
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        List <String> selectedSkillsList=[];
                        selectedSkills.forEach((key, value) {
                          if(value==true && !selectedSkillsList.contains(key)){
                            selectedSkillsList.add(key);
                          }
                        });
                        if(selectedSkillsList.isNotEmpty){
                          if(widget.label=="Soft Skills"){
                            addSoftSkillsToUserProfile(selectedSkillsList).then((value) {
                              if(value==true){
                                setState(() {
                                  isLoading=false;
                                  Navigator.of(context).pop();
                                });
                              }
                            });
                          }
                          else{
                            addSkillsToUserProfile(selectedSkillsList).then((value) {
                              if(value==true){
                                setState(() {
                                  isLoading=false;
                                  Navigator.of(context).pop();
                                });
                              }
                            });
                          }

                        }
                      },
                      child: Container(
                        height: 50.h,
                        width: 114.w,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : Text(
                            "Save",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff010100),
                              height: (24 / 16).h,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
