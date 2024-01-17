import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Login/phoneNumber_screen.dart';
import 'package:lookbook/Services/autheticationAPIs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/google_auth_provider.dart';
import '../screens/home/home_screen.dart';
import 'options_screen.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {

  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Welcome,",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff12121d),
                  height: 32/32,
                ),
                textAlign: TextAlign.left,
              ),
              const Text(
                "Get started with...",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff12121d),
                  height: 16/14,
                ),
                textAlign: TextAlign.center,
              ),
              if(Platform.isIOS)
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_){
                    return PhoneNumber_Screen();
                  }));
                },
                child: Container(
                  height: 71,
                  width: 345,
                  margin: EdgeInsets.only(
                    top: 66,
                    left: 33,
                    right: 34,
                    bottom: 9,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff868686),),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/appleIcon.svg',
                          semanticsLabel: 'My SVG Image',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 9,),
                        const Text(
                          "Use your Apple ID",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff12121d),
                            height: 16/16,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if(Platform.isAndroid)
              SizedBox(height: 66,),
              GestureDetector(
                onTap: (){
                  final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogIn().then((value){
                    if(value==true){
                      setState(() {
                        isLoading=true;
                      });
                     FirebaseAuthAPIs().checkStudentEmailInFireStore().then((value) {
                        print("TTTTHHHHHHHEEEEEEEEEEE    VVVVVVVVVVVAAAALLLLLUEEEEEEEEEEEEEE ::: ${value}");
                        if(value){
                          setState(() {
                            isLoading=false;
                          });
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_){
                                return HomeScreen();
                              }));
                        }
                        else{
                          setState(() {
                            isLoading=false;
                          });
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return OptionsInScreen();
                          }));
                        }
                      });
                    }
                    else{
                      print("**************************************************************************");
                    }
                  });
                },

                child: Container(
                  height: 71,
                  width: 345,
                  margin: EdgeInsets.only(
                    left: 33,
                    right: 34,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff868686),),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/googleIcon.svg',
                          semanticsLabel: 'My SVG Image',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 9,),
                        const Text(
                          "Use your Gmail",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff12121d),
                            height: 16/16,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text(
                      "Have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: ,
                        height: 16/14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 14,
                        // fontWeight: ,
                        height: 16/14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                SizedBox(height: 45,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "1",
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
                SizedBox(height: 49,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
