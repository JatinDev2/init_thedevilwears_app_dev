import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Preferences/LoginData.dart';

import '../Services/autheticationAPIs.dart';
import 'final_screen.dart';
import 'instaLogin/insta_verification_screen.dart';

class OppurtunitiesScreen extends StatefulWidget {
 final List<String> userDescription;

 OppurtunitiesScreen({
   required this.userDescription,
});

  @override
  _OppurtunitiesScreenState createState() => _OppurtunitiesScreenState();
}

class _OppurtunitiesScreenState extends State<OppurtunitiesScreen> {
  bool isLoading = false;
  List countryCitis=[];
  List<String> countryCitisStringList=[];

  Map<String, bool>  selectedSkills= {
    'Illustrating' : false,
    'Stylist': false,
    'Brand': false,
    'Visual Designer': false,
    'Fashion': false,
    'Designing': false,
    'Fashion Styling': false,
    'Video Editing': false,
    'Content Creation': false,
    'Copywriting': false,
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

  List<String> businessSkills = [
  'Illustrating',
  'Stylist',
  'Brand',
  'Visual Designer',
  'Fashion',
  'Designing',
    'Fashion Styling',
    'Video Editing',
    'Content Creation',
    'Copywriting',
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


  List<String> fashion=[
    'Test Fashion'
  ];

  Future<void> getData()async{
    final country = await getCountryFromCode('IN');
    if (country != null) {
      countryCitis = await getCountryCities(country.isoCode);
      for(int i=0; i<countryCitis.length;i++){
        countryCitisStringList.add(countryCitis[i].name);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

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
          actions: [
            Container(
              height: 49.h,
              width: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff12121D0D),
              ),
              child: IconButton(
                onPressed: () {
                  // textEditingController.clear();
                  setState(() {
                    selectedSkills.forEach((key, value) {
                      selectedSkills[key]=false;
                    });
                  });
                },
                icon: Icon(Icons.close, color: Colors.black, size: 24.sp),
              ),
            ),
            SizedBox(width: 20.w),
          ],
        ),
        body: Container(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Text(
              LoginData().getUserType()=="Company"?  "What kind of talent profiles are you looking for" :  "What kind of opportunities are you looking for",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff0f1015),
                  // height: 58/32,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 30),
             const Text(
                "Business & Analytics",
                style:  TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff000000),
                  height: 20/12,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 5,),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 3.0,
                    runSpacing: 0.0,
                    children: businessSkills.map((skill) => ChoiceChip(
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
                      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 0.0),
                    )).toList(),
                  ),
                ),
              ),
              Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Don’t worry, you’ll get to see all opportunities anyway.This will ensure, the one’s you like are served right on top.",
                      style:  TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff12121d),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16,),
                    GestureDetector(
                      onTap: (){

                        List <String> selectedOpportunitiesList=[];
                        selectedSkills.forEach((key, value) {
                          if(value==true && !selectedOpportunitiesList.contains(key)){
                            selectedOpportunitiesList.add(key);
                          }
                        });
                        if(selectedOpportunitiesList.isNotEmpty){
                          setState(() {
                            isLoading=true;
                          });
                          if( LoginData().getUserType()=="Person"){
                            LoginData().writeUserInterests(selectedOpportunitiesList);
                            FirebaseAuthAPIs().addStudentToDatabase(widget.userDescription, selectedOpportunitiesList).then((value) {
                              setState(() {
                                isLoading=true;
                              });
                              if(value==true){
                                LoginData().writeIsInterestsSelected(true);
                                LoginData().writeIsLoggedIn(true);
                                LoginData().writeCitiesList(countryCitisStringList);
                                print(LoginData().getListOfAllCities());
                                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                  return const ConfirmedLoginScreen();
                                }));
                              }
                            });
                          }
                          else{
                            LoginData().writeUserInterests(selectedOpportunitiesList);
                            FirebaseAuthAPIs().addBrandToDatabase(widget.userDescription, selectedOpportunitiesList).then((value) {
                              setState(() {
                                isLoading=true;
                              });
                              if(value==true){
                                LoginData().writeIsInterestsSelected(true);
                                LoginData().writeIsLoggedIn(true);
                                // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                //   return const InstaVerification(map: {},);
                                // }));
                                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                  return const ConfirmedLoginScreen();
                                }));
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
                            "Next",
                            style: TextStyle(
                              fontFamily: "Poppins",
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
