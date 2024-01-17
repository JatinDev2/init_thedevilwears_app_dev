import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmJobListingScreen extends StatelessWidget {
  const ConfirmJobListingScreen({Key? key}) : super(key: key);

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
                  style: TextStyle(
                    color: Color(0xff2E2E2E),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Your listing is live.The Devil is",
                  style: TextStyle(
                    color: Color(0xff3C3C3C),
                    fontSize: 20,
                  ),
                ),
                Text(
                  "at work to find the best fit.",
                  style: TextStyle(
                    color: Color(0xff3C3C3C),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                //   return OptionsScreen();
                // }));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 56,
                    width: 365,
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      left: 24,
                      right: 25,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text(
                        "Create a new listing",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                    },
                    child: Container(
                      height: 56,
                      width: 365,
                      margin: const EdgeInsets.only(
                        bottom: 54,
                        left: 24,
                        right: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF7F7F7),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          "View your listings",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
