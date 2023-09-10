import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'insta_verification_screen.dart';

class InterestSccreen extends StatefulWidget {
  @override
  State<InterestSccreen> createState() => _InterestSccreenState();
}

class _InterestSccreenState extends State<InterestSccreen> {
  List<String> gender = ["Men's", "Women's", "Teen","Boys", "Footwear"];
  List<String> occasion= ["Party Wear", "Wedding Wear", "Office Wear","Men's", "Women's", "Teen","Boys", "Footwear"];
  List<String> selectedOptions = [];
  Map<String, List<String>> _selectedOptions = {};

  List<String>_selectedGender=[];
  List<String>_selectedOccasion=[];

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  void addUser() async {
    for(int i=0; i<selectedOptions.length; i++){
     String cat= getCategory(selectedOptions[i]);
     if(cat=="gender"){
       _selectedGender.add(selectedOptions[i]);
     }
     else{
       _selectedOccasion.add(selectedOptions[i]);
     }
    }

    _selectedOptions.addAll({
      "gender": _selectedGender,
      "occasion": _selectedOccasion,
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final firstName = prefs.getString('firstName');
      final lastName = prefs.getString('lastName');
      final phoneNumber=prefs.getString('phoneNumber');
      final userEmail=prefs.getString('userEmail');
      final userType=prefs.getString('userType');
      final userId=prefs.getString('userId');
      await usersCollection.doc("$userId").set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber!.replaceAll(" ", ""),
        'userEmail': userEmail,
        'preferences':_selectedOptions,
        'userType': userType,
      }).then((value) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return InstaVerification();
        }));
      });
      print('User added to Firestore');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  String getCategory(String option){
    if (gender.contains(option)) {
      return "gender";
    } else if (occasion.contains(option)){
      return "occasion";
    }
    return "";
  }

  void toggleOption(String option) {
    setState((){
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  
  Widget buildOption(String option) {
    final isSelected = selectedOptions.contains(option);
    final backgroundColor = isSelected ? Theme.of(context).colorScheme.primary : Color(0xffF7F7F7);

    return GestureDetector(
      onTap: () => toggleOption(option),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              option,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isSelected? Colors.white : Color(0xff303030),
                height: 18/12,
              ),
              textAlign: TextAlign.left,
            ),
            if (isSelected)
              GestureDetector(
                onTap: () => toggleOption(option),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60,),
                const Text(
                  "Choose what describes\n your brand the best",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0f1015),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: const Text(
                    "Gender",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: gender.map((option) => buildOption(option)).toList(),
                ),
                SizedBox(height: 30,),

                Container(
                  margin: EdgeInsets.all(5.0),
                  child: Text(
                    "Occasion",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: occasion.map((option) => buildOption(option)).toList(),
                ),
                Container(
                  margin: EdgeInsets.all(5.0),
                  child: const Text(
                    "Gender",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: gender.map((option) => buildOption(option)).toList(),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: ()async{
                    final prefs = await SharedPreferences.getInstance(); // Obtain SharedPreferences instance
                    await prefs.setStringList('preferences', selectedOptions
                    ).then((value) {
                      addUser();
                    });
    },
                  child: Container(
                    height: 50,
                    width: 109,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 20/16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 58,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "4",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24/16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "/5",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24/16,
                          color: Colors.grey
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
