import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/App%20Constants/colorManager.dart';
import '../screens/home/old_home_screen.dart';
import 'options_screen.dart';

class ConfirmedLoginScreen extends StatelessWidget {
  const ConfirmedLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/confirm_img.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 100,
                    width: 70,
                  ),
                  SizedBox(height: 35,),
                  const Text(
                    "Woo hoo!",
                    style:  TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff2d2d2d),
                      height: 54/36,
                    ),
                    textAlign: TextAlign.center,
                  ),
                 const SizedBox(height: 16,),
                  // Text("Somebody will get back to you", style: TextStyle(
                  //   color: Color(0xff737373),
                  //   fontSize: 16,
                  // ),),
                  // Text("from our team", style: TextStyle(
                  //   color: Color(0xff737373),
                  //   fontSize: 16,
                  // ),),
                 const Text(
                    "Let’s help you build that dream\n career of yours",
                    style:  TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff737373),
                      // height: 105/16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  //   return OptionsInScreen();
                  // }));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_){
                            return HomeScreen(tabVal: 3,);
                          }));
                      },
                      child: Container(
                        height: 56,
                        width: 365,
                        margin: const EdgeInsets.only(
                          bottom: 10,
                          left: 24,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Build your profile",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 24/16,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ),
                      ),
                    ),
                    // SizedBox(height: 4,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_){
                              return HomeScreen();
                            }));
                      },
                      child: Container(
                        height: 56,
                        width: 365,
                        margin: const EdgeInsets.only(
                          bottom: 10,
                          left: 24,
                          right: 25,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.greyishColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                            child: Text(
                              "Remind me later",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                height: 24/16,
                              ),
                              textAlign: TextAlign.left,
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
