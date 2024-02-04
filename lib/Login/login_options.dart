import 'dart:io';
import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/Login/phoneNumber_screen.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/Services/autheticationAPIs.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Provider/google_auth_provider.dart';
import '../screens/home/old_home_screen.dart';
import 'options_screen.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {

  bool isLoading=false;
  List countryCitis=[];
  List<String> countryCitisStringList=[];



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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome,",
                    style: TextStyle(
                      // fontFamily: "Poppins",
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff12121d),
                      height: 32/32,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 11),
                    child: Text(
                      "Get started with...",
                      style: TextStyle(
                        // fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0x9912121d),
                        height: 16/14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if(Platform.isIOS)
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        return const PhoneNumber_Screen();
                      }));
                    },
                    child: Container(
                      height: 71,
                      width: 345,
                      margin: const EdgeInsets.only(
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
                                // fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0x9912121d),
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
                  const SizedBox(height: 66,),
                  GestureDetector(
                    onTap: isLoading? null : (){
                      final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
                      setState(() {
                        isLoading=true;
                      });
                      provider.googleLogIn().then((value){
                        if(value==true){
                         FirebaseAuthAPIs().checkStudentEmailInFireStore().then((value) {
                            print("TTTTHHHHHHHEEEEEEEEEEE VVVVVVVVVVVAAAALLLLLUEEEEEEEEEEEEEE ::: ${value}");
                            if(value){
                              LoginData().writeCitiesList(countryCitisStringList);
                              print(LoginData().getListOfAllCities());

                              setState(() {
                                isLoading=false;
                              });
                              LoginData().writeIsLoggedIn(true);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_){
                                    return HomeScreen();
                                  }));
                            }
                            else{
                              setState(() {
                                isLoading=false;
                              });
                              LoginData().writeIsLoginOptionDone(true);
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

                    child: googleLoginButton()
                  )
                ],
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children:  [
          //           const Text(
          //             "Have an account? ",
          //             style: TextStyle(
          //               fontSize: 14,
          //               // fontWeight: ,
          //               height: 16/14,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //           Text(
          //             "Login",
          //             style: TextStyle(
          //               fontSize: 14,
          //               // fontWeight: ,
          //               height: 16/14,
          //               color: Theme.of(context).colorScheme.primary,
          //             ),
          //             textAlign: TextAlign.center,
          //           )
          //         ],
          //       ),
          //       const SizedBox(height: 45,),
          //       const SizedBox(height: 49,),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget googleLogin(){
    return Container(
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
                // fontFamily: "Poppins",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0x9912121d),
                height: 16/16,
              ),
              textAlign: TextAlign.left,
            )
          ],
        ),
      ),
    );
  }

  Widget googleLoginButton() {
    return Stack(
      children: [
        googleLogin(),
        if (isLoading)
          Positioned.fill(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.2),
              highlightColor: Colors.grey.withOpacity(0.4),
              child: Container(
                height: 71,
                width: 345,
                margin: const EdgeInsets.only(
                  left: 33,
                  right: 34,
                ),
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}