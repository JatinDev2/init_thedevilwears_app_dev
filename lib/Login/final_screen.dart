import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../screens/home/home_screen.dart';
import 'options_screen.dart';

class ConfirmedLoginScreen extends StatelessWidget {
  const ConfirmedLoginScreen({Key? key}) : super(key: key);

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
                SvgPicture.asset(
                  'assets/confirm_img.svg',
                  semanticsLabel: 'My SVG Image',
                  height: 100,
                  width: 70,
                ),
                Text(
                  "Woo hoo!",
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff2d2d2d),
                    height: 54/36,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5,),
                Text("Somebody will get back to you", style: TextStyle(
                  color: Color(0xff737373),
                  fontSize: 16,
                ),),
                Text("from our team", style: TextStyle(
                  color: Color(0xff737373),
                  fontSize: 16,
                ),),
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Text(
                          "View similar listings",
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
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
