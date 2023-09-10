import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({Key? key}) : super(key: key);

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
               Text("Woo hoo!", style: TextStyle(
                 color: Color(0xff2E2E2E),
                 fontSize: 36,
                 fontWeight: FontWeight.bold,
               ),),
               SizedBox(height: 5,),
               Text("Your application was submitted!", style: TextStyle(
                 color: Color(0xff737373),
                 fontSize: 16,
               ),),
              Text("Bask in the glory.", style: TextStyle(
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
                Navigator.pushReplacementNamed(context, '/listingResponseScreen');
              },
              child: Container(
                height: 56,
                width: 365,
                margin: EdgeInsets.only(
                  bottom: 54,
                  left: 24,
                  right: 25,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text("View similar listings", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
