import 'package:flutter/material.dart';

import 'insta_verification_screen.dart';

class InterestSccreen extends StatefulWidget {
  const InterestSccreen({Key? key}) : super(key: key);

  @override
  State<InterestSccreen> createState() => _InterestSccreenState();
}

class _InterestSccreenState extends State<InterestSccreen> {
  List<String> gender = ["Men's", "Women's", "Teen","Boys", "Footwear"];
  List<String> occasion= ["Party Wear", "Wedding Wear", "Office Wear","Men's", "Women's", "Teen","Boys", "Footwear"];
  List<String> selectedOptions = [];

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  Widget buildOption(String option) {
    final isSelected = selectedOptions.contains(option);
    final backgroundColor = isSelected ? Color(0xffFF9431) : Color(0xffF7F7F7);

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
                  onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (_){
        return InstaVerification();
      }));
    },
                  child: Container(
                    height: 50,
                    width: 109,
                    decoration: BoxDecoration(
                      color: const Color(0xffFF9431),
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
