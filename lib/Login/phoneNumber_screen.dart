import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lookbook/Login/otp_screen.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneNumber_Screen extends StatefulWidget {
  const PhoneNumber_Screen({Key? key}) : super(key: key);

  @override
  State<PhoneNumber_Screen> createState() => _PhoneNumber_ScreenState();
}

class _PhoneNumber_ScreenState extends State<PhoneNumber_Screen> {
  bool isLoading=false;
  final TextEditingController _controller = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'IN');
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId="";
  final form=GlobalKey<FormState>();
  String smsOTP="";


  Future<void> signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
    try {
      // Link the phone number credential with the existing Google user
      await FirebaseAuth.instance.currentUser!.linkWithCredential(phoneAuthCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // Handle errors during linking if needed
    }
  }

  // Future<void> signInWithPhoneAuthCred(AuthCredential phoneAuthCredential) async {
  //   try {
  //     // Link the phone number credential with the existing Google user
  //     await FirebaseAuth.instance.currentUser!.linkWithCredential(phoneAuthCredential);
  //
  //     // After linking, update the user's custom claims to indicate phone number authentication
  //     await FirebaseAuth.instance.currentUser!.getIdTokenResult(true).then((idTokenResult) {
  //       if (idTokenResult.claims!.containsKey('phoneAuth') && idTokenResult.claims['phoneAuth']) {
  //         print('User already authenticated with phone number.');
  //       } else {
  //         // Add custom claim to user's ID token indicating phone number authentication
  //         FirebaseAuth.instance.currentUser!.getIdTokenResult(true).then((idTokenResult) {
  //           Map<String, dynamic>? claims = idTokenResult.claims;
  //           claims['phoneAuth'] = true;
  //
  //           FirebaseAuth.instance.currentUser!.getIdToken(refresh: true).then((newIdToken) {
  //             FirebaseAuth.instance.currentUser!.setCustomClaims(claims).then((_) {
  //               print('User custom claims updated.');
  //             });
  //           });
  //         });
  //       }
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message);
  //     // Handle errors during linking if needed
  //   }
  // }


  Future<void> verifyPhoneNumber() async {
    setState(() {
      isLoading=true;
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: "+${_phoneNumber.dialCode}"+"${_controller.text}",
      verificationCompleted: (phoneAuthCredential) async {
        // Verification completed automatically (e.g., SMS code detected)
        await signInWithPhoneAuthCred(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) {
        print(verificationFailed);
        // Handle verification failure (e.g., invalid phone number)
      },
      codeSent: (verificationID, resendingToken) async {
        setState(() {
          this.verificationId = verificationID;
          isLoading=false;
             Navigator.of(context).push(MaterialPageRoute(builder: (_){
               return PinCodeVerificationScreen(phoneNumber: _controller.text, verificationId: verificationId,dialCode: _phoneNumber.dialCode,);
             }));
        });
      },
      codeAutoRetrievalTimeout: (verificationID) async {
        // Auto-retrieval timeout for the SMS code (not needed in this case)
      },
    );
  }

  void submitform(){
    if(form.currentState!.validate()){
      form.currentState!.save();
      // veifyPhoneNumber();
      verifyPhoneNumber();
    }
    else{
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_rounded, color: Colors.black,)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: form,
          child: Container(
            height: MediaQuery.of(context).size.height-AppBar().preferredSize.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 25,
                  ),
                  child: const Text(
                    "Help us get to know you better",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0f1015),
                      height: 32/22,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 51,
                    left: 26,
                    bottom: 15
                    // bottom: 10
                  ),
                  child: const Text(
                    "First name",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(
                      left: 26,
                      right: 26
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Enter your First name",
                      hintStyle:TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffb2b2b2),
                        height: 21/14,
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please enter your First name";
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 29,
                    left: 27,
                    bottom: 15
                  ),
                  child: const Text(
                    "Last name",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(
                      left: 26,
                      right: 26
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Enter your Last name",
                      hintStyle:TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffb2b2b2),
                        height: 21/14,
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please enter your Last name";
                      }
                    },
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(
                    left: 26,
                    top: 29,
                  ),
                  child: const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2d2d2d),
                      height: 24/16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: InternationalPhoneNumberInput(
                      //         onInputChanged: (PhoneNumber number){
                      //           setState(() {
                      //             _phoneNumber = number;
                      //           });
                      //         },
                      //         selectorConfig: const SelectorConfig(
                      //           selectorType: PhoneInputSelectorType.DIALOG,
                      //         ),
                      //         ignoreBlank: false,
                      //         autoValidateMode: AutovalidateMode.onUserInteraction,
                      //         selectorTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      //         textFieldController: _controller,
                      //         initialValue: _phoneNumber,
                      //         inputDecoration: const InputDecoration(
                      //           labelText: 'Phone Number',
                      //           border: OutlineInputBorder(),
                      //         ),
                      //         validator: (value){
                      //           if(value!.isEmpty){
                      //             return "Please Enter your Phone number";
                      //           }
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      Row(
                        children: [
                          Expanded(
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                setState(() {
                                  _phoneNumber = number;
                                });
                              },
                              selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.onUserInteraction,
                              selectorTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textFieldController: _controller, // Use a TextEditingController
                             initialValue: _phoneNumber,
                              inputDecoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter your Phone number";
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: (){
                      if(!isLoading){
                        submitform();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 100,
                      ),
                      height: 50,
                      width: 142,
                      decoration: BoxDecoration(
                        color: const Color(0xffFF9431),
                       borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: isLoading? CircularProgressIndicator(
                          color: Colors.white,
                        ): Text(
                          "Get OTP",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 20/16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 58,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "2",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
