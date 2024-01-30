import 'package:flutter/material.dart';
import 'package:lookbook/Login/interestScreen.dart';
import 'package:lookbook/Login/options_screen.dart';
import 'package:lookbook/Login/phoneNumber_screen.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:lookbook/screens/home/old_home_screen.dart';
import '../Login/login_options.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    bool isLoggedIn=LoginData().getIsLoggedIn();
    bool isLoginOptionsDone=LoginData().getIsLoginOptionDone();
    bool isUserType=LoginData().getIsUserTypeSelected();
    bool isPhoneNumberVerified=LoginData().getIsPhoneNumberVerified();
    bool isJobProfile=LoginData().getIsJobProfileSelected();

    Future.delayed(const Duration(seconds: 4)).then((value){
      if(isLoggedIn){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return HomeScreen();
        }));
      }
      else if(!isLoginOptionsDone){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return const LoginOptions();
        }));
      }
      else if(isLoginOptionsDone && !isUserType){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return OptionsInScreen();
        }));
      }
      else if(isUserType && !isPhoneNumberVerified){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return const PhoneNumber_Screen();
        }));
      }
      else if(isPhoneNumberVerified && !isJobProfile){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return InterestScreen();
        }));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
          return const LoginOptions();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset("assets/indexImg.png", height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
