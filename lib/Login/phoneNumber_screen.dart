import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lookbook/Login/otp_screen.dart';
import 'package:lookbook/Preferences/LoginData.dart';

class PhoneNumber_Screen extends StatefulWidget {
  const PhoneNumber_Screen({Key? key}) : super(key: key);

  @override
  State<PhoneNumber_Screen> createState() => _PhoneNumber_ScreenState();
}

class _PhoneNumber_ScreenState extends State<PhoneNumber_Screen> {
  bool isLoading=false;
  final TextEditingController _controller = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId="";
  final form=GlobalKey<FormState>();
  final TextEditingController _firstNameController=TextEditingController();
  final TextEditingController _lastNameController=TextEditingController();

  String smsOTP="";
  final bool isBrand=LoginData().getUserType()=="Company";


  Future<void> signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      await FirebaseAuth.instance.currentUser!.linkWithCredential(phoneAuthCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }


  Future<void> verifyPhoneNumber() async {
    setState(() {
      isLoading=true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: "+${_phoneNumber.dialCode}"+"${_controller.text}",
      verificationCompleted: (phoneAuthCredential) async {
        await signInWithPhoneAuthCred(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) {
        print(verificationFailed);
      },
      codeSent: (verificationID, resendingToken) async {
        setState(() {
          this.verificationId = verificationID;
          isLoading=false;
             Navigator.of(context).push(MaterialPageRoute(builder: (_){
               return PinCodeVerificationScreen(
                 phoneNumber: _controller.text,
                 verificationId: verificationId,
                 dialCode: _phoneNumber.dialCode,
                 firstName: _firstNameController.text,
                 lastName: _lastNameController.text,
               );
             }));
        });
      },
      codeAutoRetrievalTimeout: (verificationID) async {
      },
    );
  }

  void submitform(){
    if(form.currentState!.validate()){
      form.currentState!.save();
      verifyPhoneNumber();
    }
    else{
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w, vertical: 50.h),
                  child: Text(
                    "Help us get to know you better",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0f1015),
                      height: 32 / 22,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                // SizedBox(height: 50.h),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: Text(
                    isBrand? "Brand name" :"First name" ,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      hintText:  isBrand? "Enter your brand" : "Enter your First name",
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffb2b2b2),
                        height: 21 / 14,
                      ),
                      border: InputBorder.none
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return  isBrand?"Please enter your brand": "Please enter your First name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: Divider(height: 1, thickness: 1,color: Color(0xffE7E7E7),),
                ),
                SizedBox(height: 32),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: Text(
                    isBrand? "Company Name" :"Last name",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      hintText:  isBrand? "Enter your Company name": "Enter your Last name",
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffb2b2b2),
                        height: 21 / 14,
                      ),
                      border: InputBorder.none
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return isBrand? "Please enter your company name" : "Please enter your Last name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: Divider(height: 1, thickness: 1,color: Color(0xffE7E7E7),),
                ),
                SizedBox(height: 32),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        _phoneNumber = number;
                      });
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    ignoreBlank: false,
                    selectorTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textFieldController: _controller,
                    initialValue: _phoneNumber,
                    inputDecoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter your Phone number";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 12),

                Padding(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: Divider(height: 1, thickness: 1,color: Color(0xffE7E7E7),),
                ),
                SizedBox(height: 24),

                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: Text(
                    "Email ID",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 7,),
                Container(
                  padding:EdgeInsets.symmetric(horizontal: 26.w,),
                  child: Text(LoginData().getUserEmail(), style: const TextStyle(
                    // fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff000000),
                    height: 21/14,
                  ),),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      if (!isLoading) {
                        submitform();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 100.h),
                      height: 50.h,
                      width: 142.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          "Get OTP",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 20 / 16,
                          ),
                          textAlign: TextAlign.left,
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
