import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'interest_screen.dart';

class OptionsInScreen extends StatefulWidget {

  @override
  State<OptionsInScreen> createState() => _OptionsInScreenState();
}

class _OptionsInScreenState extends State<OptionsInScreen> {
  bool isBrand=false;
  bool isStylist=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Are you a... ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff12121d),
                    height: 32/32,
                  ),
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: 79,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isBrand=true;
                          isStylist=false;
                        });
                        // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        //   return InterestSccreen();
                        // }));
                      },
                      child: Container(
                        height: 70,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color:isBrand? Theme.of(context).colorScheme.primary : Color(0xffF8F7F7),
                        ),
                        child: Center(
                          child: Text(
                            "Brand",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: isBrand? Colors.white : Color(0xff000000),
                              height: 30/20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12,),
                    GestureDetector(
                      onTap: (){
                        setState((){
                          isBrand=false;
                          isStylist=true;
                        });
                        // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        //   return InterestSccreen();
                        // }));
                      },
                      child: Container(
                        height: 70,
                        width: 160,
                        decoration: BoxDecoration(
                          color: isStylist? Theme.of(context).colorScheme.primary : Color(0xffF8F7F7),
                         borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            "Stylist",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: isStylist? Colors.white : Color(0xff000000),
                              height: 30/20,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async{
                    final prefs = await SharedPreferences.getInstance(); // Obtain SharedPreferences instance
                    await prefs.setBool('optionSelected', true);
                    await prefs.setString('userType', isBrand?"Brand" : "Stylist")
                        .then((value) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        return InterestSccreen();
                      }));
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
                        "3",
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
