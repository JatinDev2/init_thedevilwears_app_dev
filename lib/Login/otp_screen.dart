import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lookbook/Login/options_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/google_auth_provider.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  const PinCodeVerificationScreen({
    Key? key,

    this.phoneNumber,
    this.verificationId,
    this.dialCode,
    required this.lastName,
    required this.firstName,

  }) : super(key: key);

  final String? phoneNumber;
  final String? verificationId;
  final String? dialCode;
  final String firstName;
  final String lastName;

  @override
  State<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  // final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  TextEditingController textEditingController = TextEditingController();
  bool _isLoading=false;
  // ..text = "123456";
  bool isFilled=false;

  Future<void> signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    setState(() {
      _isLoading=true;
    });
    try {
      // Link the phone number credential with the existing Google user
      await FirebaseAuth.instance.currentUser!.linkWithCredential(phoneAuthCredential).then((value) async{
        final prefs = await SharedPreferences.getInstance(); // Obtain SharedPreferences instance
        final userEmail= prefs.getString('userEmail');
        await prefs.setBool('phoneVerified', true);
        await prefs.setString('firstName', widget.firstName);
        await prefs.setString('lastName', widget.lastName);
        await prefs.setString('phoneNumber', "${widget.dialCode}${widget.phoneNumber}");
        await prefs.setString('email', userEmail!);
        setState(() {
          _isLoading=false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return OptionsInScreen();
        }));
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect OTP. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      print(e.message);
      // Handle errors during linking if needed
    }
  }


  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        actions: [
          Container(
            height: 49,
            width: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff12121D0D),
            ),
            child: IconButton(onPressed: (){
              textEditingController.clear();
            }, icon: Icon(Icons.close, color: Colors.black,size: 24,)),
          ),
          SizedBox(width: 20,),
        ],
      ),
      // backgroundColor: Constants.primaryColor,
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height-AppBar().preferredSize.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 25),
                  child:const Text(
                    "Phone Number Verification",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0f1015),
                      height: 32/22,
                    ),
                    // textAlign: TextAlign.center,
                  ),
                ),
                // Container(
                //   padding:
                //   const EdgeInsets.symmetric(),
                //   margin: const EdgeInsets.only(left: 28, top: 18),
                //   child: RichText(
                //     text: TextSpan(
                //       text: "Please enter the 6-digit code send to you at \n",
                //       children: [
                //         TextSpan(
                //           text: "\n${widget.phoneNumber}",
                //           style: const TextStyle(
                //             color: Colors.black,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 15,
                //           ),
                //         ),
                //       ],
                //       style: const TextStyle(
                //         color: Colors.black54,
                //         fontSize: 15,
                //       ),
                //     ),
                //     // textAlign: TextAlign.center,
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 18,
                    left: 28,
                  ),
                  child: const Text(
                    "Please enter the 6-digit code send to you at",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      height: 16/14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 8,),
                Container(
                  margin: EdgeInsets.only(
                    left: 27,
                  ),
                  child: Text(
                    "${widget.dialCode} ${widget.phoneNumber}",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202030),
                      height: 16/14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 28, top: 25),
                  child:Text(
                    "Resend Code",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary,
                      height: 16/14,
                    ),
                    // textAlign: TextAlign.left,
                  )
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 30,
                    ),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      // obscureText: true,
                      // obscuringCharacter: '*',
                      // obscuringWidget: const FlutterLogo(
                      //   size: 24,
                      // ),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v!.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        // borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        activeColor: Theme.of(context).colorScheme.primary,
                        selectedColor: Colors.black,
                        selectedFillColor: Colors.white,
                        disabledColor: Colors.black,
                        inactiveColor: Colors.black,
                        inactiveFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value){
                        if(value.isNotEmpty && value.length==6){
                          setState(() {
                            isFilled=true;
                            currentText = value;
                          });
                        }
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      if(textEditingController.text.length==6 && !_isLoading){
                        AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: textEditingController.text);
                        signInWithPhoneAuthCred(phoneAuthCredential);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 100,
                      ),
                      height: 50,
                      width: 142,
                      decoration: BoxDecoration(
                        color: isFilled? const Color(0xffFF9431): const Color(0xffF3F3F4),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child:  Center(
                        child: _isLoading? CircularProgressIndicator(color: Colors.white,) : Text(
                          "Submit",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color:isFilled? Colors.white: Color(0xff8B8B8B),
                            height: 20/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   margin:
                //   const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                //   child: ButtonTheme(
                //     height: 50,
                //     child: TextButton(
                //       onPressed: () {
                //         formKey.currentState!.validate();
                //         // conditions for validating
                //         if (currentText.length != 6 || currentText != "123456") {
                //           errorController!.add(ErrorAnimationType
                //               .shake); // Triggering error shake animation
                //           setState(() => hasError = true);
                //         } else {
                //           setState(
                //                 () {
                //               hasError = false;
                //               snackBar("OTP Verified!!");
                //             },
                //           );
                //         }
                //       },
                //       child: Center(
                //         child: Text(
                //           "VERIFY".toUpperCase(),
                //           style: const TextStyle(
                //             color: Colors.white,
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                //   decoration: BoxDecoration(
                //       color: Colors.green.shade300,
                //       borderRadius: BorderRadius.circular(5),
                //       boxShadow: [
                //         BoxShadow(
                //             color: Colors.green.shade200,
                //             offset: const Offset(1, -2),
                //             blurRadius: 5),
                //         BoxShadow(
                //             color: Colors.green.shade200,
                //             offset: const Offset(-1, 2),
                //             blurRadius: 5)
                //       ]),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Flexible(
                //       child: TextButton(
                //         child: const Text("Clear"),
                //         onPressed: () {
                //           textEditingController.clear();
                //         },
                //       ),
                //     ),
                //     Flexible(
                //       child: TextButton(
                //         child: const Text("Set Text"),
                //         onPressed: () {
                //           setState(() {
                //             textEditingController.text = "123456";
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}