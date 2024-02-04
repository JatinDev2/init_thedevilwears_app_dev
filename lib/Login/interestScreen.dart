import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Login/oppurtunitiesScreen.dart';
import 'package:lookbook/Preferences/LoginData.dart';

class InterestScreen extends StatefulWidget {

  @override
  _InterestScreenState createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  bool isLoading = false;
  Map<String, bool> selectedSkills = {
    'Student' : false,
    'Stylist': false,
    'Brand': false,
    'Visual Designer': false,
    'Fashion Designer': false,
    'Fashion Stylist': false,
    'Video Editor': false,
    'Content Creator': false,
    'Copywriter': false,
    'Illustrator': false,
    'Dyeing': false,
    'Digital Marketing': false,
    'Data Analytics': false,
    'Grading': false,
    'Graphic Design': false,
    'Illustration': false,
    'Adobe Creative Suite': false,
    'Khakha Maker': false,
    'Market Research & Analysis': false,
    'Merchandising': false,
    'Project Management': false,
  };
  late  Future<List<String>?> skillsFuture;

   List<String> skills = [
  'Student',
  'Stylist',
  'Brand',
  'Visual Designer',
  'Fashion Designer',
  'Fashion Stylist',
  'Video Editor',
  'Content Creator',
  'Copywriter',
  'Illustrator',
  'Dyeing',
  'Digital Marketing',
  'Data Analytics',
  'Grading',
  'Graphic Design',
  'Illustration',
  'Adobe Creative Suite',
  'Khakha Maker',
  'Market Research & Analysis',
    'Merchandising',
    'Project Management',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        ),
        // actions: [
        //   Container(
        //     height: 49.h,
        //     width: 48.w,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Color(0xff12121D0D),
        //     ),
        //     child: IconButton(
        //       onPressed: () {
        //         // textEditingController.clear();
        //         setState(() {
        //           selectedSkills.forEach((key, value) {
        //             selectedSkills[key]=false;
        //           });
        //         });
        //       },
        //       icon: Icon(Icons.close, color: Colors.black, size: 24.sp),
        //     ),
        //   ),
        //   SizedBox(width: 20.w),
        // ],
      ),
      body: Container(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Text(
                     LoginData().getUserType()=="Company"?"Choose what describes your brand the best": "Choose what describes you the best",
                      style:  TextStyle(
                        // fontFamily: "Poppins",
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0f1015),
                        // height: 58/32,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // SizedBox(height: 40),
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
                            // fontFamily: "Poppins",
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
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
                          child: const Text(
                            "Selecting the right tags will help right opportunities come your way. You can always modify these later.",
                            style:  TextStyle(
                              // fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0x9912121d),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 16,),
                        GestureDetector(
                          onTap: (){

                            List <String> selectedSkillsList=[];
                            selectedSkills.forEach((key, value) {
                              if(value==true && !selectedSkillsList.contains(key)){
                                selectedSkillsList.add(key);
                              }
                            });
                            if(selectedSkillsList.isNotEmpty){
                              LoginData().writeUserJobProfile(selectedSkillsList);
                              LoginData().writeIsJobProfileSelected(true);
                              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                return OppurtunitiesScreen(userDescription: selectedSkillsList,);
                              }));
                            }
                          },
                          child: Container(
                            height: 50.h,
                            width: 114.w,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8.0.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                "Next",
                                style: TextStyle(
                                  // fontFamily: "Poppins",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color:  Colors.white,
                                  height: (24 / 16).h,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h,),
                      ],
                    ),
                  ),
                ],
              ),
            )
    );
  }
}
