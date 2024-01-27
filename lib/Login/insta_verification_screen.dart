import 'package:flutter/material.dart';
import '../instaLogin/instagram_view.dart';

class InstaVerification extends StatefulWidget {
  final Map<String, List<String>> map;
  const InstaVerification({
    super.key,
    required this.map,
});

  @override
  State<InstaVerification> createState() => _InstaVerificationState();
}


class _InstaVerificationState extends State<InstaVerification> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
                    height: 32 / 32,
                  ),
                ),
               const SizedBox(
                  height: 14,
                ),
                const Text(
                  "Click on the icon to verify your Instagram ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    height: 16 / 14,
                  ),
                ),
               const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return  InstagramView(map: widget.map, label: "Insta Verify",);
                      }));
                    },
                    child: Image.asset("assets/insta.png")),
              ],
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "5",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "/5",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                          color: Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
