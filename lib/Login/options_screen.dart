import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Login/phoneNumber_screen.dart';
import 'package:lookbook/Preferences/LoginData.dart';

class OptionsInScreen extends StatefulWidget {

  @override
  State<OptionsInScreen> createState() => _OptionsInScreenState();
}

class _OptionsInScreenState extends State<OptionsInScreen> {
  bool isCompany=false;
  bool isPerson=false;
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
                  "I am a... ",
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isCompany=true;
                          isPerson=false;
                        });
                        // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        //   return InterestSccreen();
                        // }));
                      },
                      child: Container(
                        height: 70.h,
                        width: 370.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color:isCompany? Theme.of(context).colorScheme.primary : Color(0xffF8F7F7),
                        ),
                        child: Center(
                          child: Text(
                            "Company",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: isCompany? FontWeight.w600 : FontWeight.w400 ,
                              color: isCompany? Colors.white : Color(0xff000000),
                              height: 30/20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 9,),
                    GestureDetector(
                      onTap: (){
                        setState((){
                          isCompany=false;
                          isPerson=true;
                        });
                        // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        //   return InterestSccreen();
                        // }));
                      },
                      child: Container(
                        height: 70.h,
                        width: 370.w,
                        decoration: BoxDecoration(
                          color: isPerson? Theme.of(context).colorScheme.primary : Color(0xffF8F7F7),
                         borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            "Person",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight:isPerson? FontWeight.w600 : FontWeight.w400,
                              color: isPerson? Colors.white : Color(0xff000000),
                              height: 30/20,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         Icon(Icons.info_outline, size: 17,),
                          SizedBox(width: 6,),
                         Text(
                            "You will not be able to change this later",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff12121d),
                              height: 16/12,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h,),
                    GestureDetector(
                      onTap: () {
                        // final prefs = await SharedPreferences.getInstance(); // Obtain SharedPreferences instance
                        // await prefs.setBool('optionSelected', true);
                        // await prefs.setString('userType', isCompany?"Company" : "Person")
                        //     .then((value) {
                        //
                        // });
                        // LoginData().writeOptionSelectedVal(true);

                        if(isCompany || isPerson){
                          LoginData().writeUserType(isCompany?"Company" : "Person");
                          LoginData().writeIsUserTypeSelected(true);
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return const PhoneNumber_Screen();
                          }));
                        }
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
                     SizedBox(height: 47.h,),
                    // const Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "2",
                    //         style: TextStyle(
                    //           fontFamily: "Poppins",
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w400,
                    //           height: 24/16,
                    //         ),
                    //         textAlign: TextAlign.left,
                    //       ),
                    //       Text(
                    //         "/5",
                    //         style: TextStyle(
                    //             fontFamily: "Poppins",
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w400,
                    //             height: 24/16,
                    //             color: Colors.grey
                    //         ),
                    //         textAlign: TextAlign.left,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 40,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
