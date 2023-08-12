import 'package:flutter/material.dart';

import 'final_screen.dart';

class InstaVerification extends StatelessWidget {
  const InstaVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Let’s get you verified!",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff12121d),
                    height: 32/32,
                  ),
                ),
                SizedBox(height: 14,),
                const Text(
                  "Click on the icon to verify your Instagram ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    height: 16/14,
                  ),
                ),
                SizedBox(height: 50,),
                GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_){
                        return ConfirmedLoginScreen();
                      }));
                    },
                    child: Image.asset("assets/insta.png")),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "5",
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
        ],
      ),
    );
  }
}
