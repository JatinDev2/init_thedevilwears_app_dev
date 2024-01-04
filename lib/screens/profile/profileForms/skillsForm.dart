import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkillsSelectionScreen extends StatefulWidget {
  @override
  _SkillsSelectionScreenState createState() => _SkillsSelectionScreenState();
}

class _SkillsSelectionScreenState extends State<SkillsSelectionScreen> {
  bool isLoading = false;
  Map<String, bool> selectedSkills = {};
  late Future<List<String>?> skillsFuture;
  void initState() {
    super.initState();
    skillsFuture = fetchSkills(); // Fetch the skills once here
  }

  Future<bool> addSkillsToUserProfile(List<String> selectedSkillsList) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId!.isEmpty) {
      print('User ID is null or empty');
      return false;
    }
    setState(() {
      isLoading=true;
    });

    DocumentReference userDoc =
    FirebaseFirestore.instance.collection('Profiles').doc(userId);
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

  Future<List<String>?> fetchSkills() async {
    CollectionReference skillsCollection = FirebaseFirestore.instance.collection('jobSkills');

    try {
      QuerySnapshot querySnapshot = await skillsCollection.limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('Skills')) {
          List<String> skillsList = List<String>.from(data['Skills']);
          print('Skills fetched successfully');
          return skillsList;
        } else {
          print('"Skills" field is not found');
          return null;
        }
      } else {
        print('No documents found in the jobSkills collection');
        return null;
      }
    } catch (error) {
      print('Error fetching skills: $error');
      return null;
    }
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
                          addSkillsToUserProfile(selectedSkillsList).then((value) {
                            if(value==true){
                              setState(() {
                                isLoading=false;
                                Navigator.of(context).pop();
                              });
                            }
                          });
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
