import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/Login/interestScreen.dart';
import 'package:lookbook/Login/options_screen.dart';
import 'package:lookbook/Preferences/LoginData.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  const PinCodeVerificationScreen({
    Key? key,

    this.phoneNumber,
    this.verificationId,
    this.dialCode,
    this.smsCode,
    required this.lastName,
    required this.firstName,
  }) : super(key: key);

  final String? phoneNumber;
  final String? verificationId;
  final String? dialCode;
  final String firstName;
  final String lastName;
  final String? smsCode;

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
      await FirebaseAuth.instance.currentUser!.linkWithCredential(phoneAuthCredential).then((value){
        // final prefs = await SharedPreferences.getInstance(); // Obtain SharedPreferences instance
        // final userEmail= prefs.getString('userEmail');
        // await prefs.setBool('phoneVerified', true);
        // await prefs.setString('firstName', widget.firstName);
        // await prefs.setString('lastName', widget.lastName);
        // await prefs.setString('phoneNumber', "${widget.dialCode}${widget.phoneNumber}");
        // await prefs.setString('email', userEmail!);
        LoginData().writePhoneVerifiedStatus(true);
        LoginData().writeUserFirstName(widget.firstName);
        LoginData().writeUserLastName(widget.lastName);
        LoginData().writeUserPhoneNumber("${widget.dialCode}${widget.phoneNumber}");
        setState(() {
          _isLoading=false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return InterestScreen();
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

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override

  Widget build(BuildContext context) {
    // Use flutter_screenutil for responsive design
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: [
          Container(
            height: 49.h,
            width: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff12121D0D),
            ),
            child: IconButton(
              onPressed: () {
                textEditingController.clear();
              },
              icon: Icon(Icons.close, color: Colors.black, size: 24.sp),
            ),
          ),
          SizedBox(width: 20.w),
        ],
      ),
      body: GestureDetector(
        onTap: () {},
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  margin: EdgeInsets.only(left: 25.w),
                  child: Text(
                    "Phone Number Verification",
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0f1015),
                      height: 32 / 22,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 18.h,
                    left: 28.w,
                  ),
                  child: Text(
                    "Please enter the 6-digit code sent to you at",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      height: 16 / 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  margin: EdgeInsets.only(
                    left: 27.w,
                  ),
                  child: Text(
                    "${widget.dialCode} ${widget.phoneNumber}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202030),
                      height: 16 / 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 28.w, top: 25.h),
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary,
                      height: 16 / 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 30.w,
                    ),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        fieldHeight: 50.h,
                        fieldWidth: 40.w,
                        activeFillColor: Colors.white,
                        activeColor: Theme.of(context).colorScheme.primary,
                        selectedColor: Colors.black,
                        selectedFillColor: Colors.white,
                        disabledColor: Colors.black,
                        inactiveColor: Colors.transparent,
                        inactiveFillColor: Color(0xfff3f3f4),
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      onChanged: (value) {
                        if (textEditingController.text.isNotEmpty &&
                            textEditingController.text.length == 6) {
                          setState(() {
                            isFilled = true;
                            currentText = value;
                          });
                        } else {
                          setState(() {
                            isFilled = false;
                            currentText = value;
                          });
                        }
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        return true;
                      },
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (textEditingController.text.length == 6 && !_isLoading) {
                        AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: textEditingController.text);
                        signInWithPhoneAuthCred(phoneAuthCredential);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 100.h,
                      ),
                      height: 50.h,
                      width: 142.w,
                      decoration: BoxDecoration(
                        color: isFilled ? Color(0xffFF9431) : Color(0xffF3F3F4),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white,)
                            : Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: isFilled ? Colors.white : Color(0xff8B8B8B),
                            height: 20 / 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}