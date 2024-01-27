import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class LaunchingFunction{

  void launchPhoneDialer(String defaultPhoneNumber) async {
    String phoneNumber = 'tel:$defaultPhoneNumber';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      print("Error while launching Phone");
      throw 'Could not launch $phoneNumber';
    }
  }

  void launchWhatsApp(String phoneNumber) async{
   if(await canLaunchUrl(Uri.parse('https://wa.me/$phoneNumber'),)){
     await  launchUrl(
         Uri.parse('https://wa.me/$phoneNumber'),
         mode: LaunchMode.externalApplication);
   }
   else{
     print("Error while launching Whatsapp");
     throw 'Could not launch $phoneNumber';
   }
  }

  void launchFacebook(String profileId) async {
    if (await canLaunchUrl(Uri.parse('https://www.facebook.com/$profileId'))) {
      await launchUrl(
        Uri.parse('https://www.facebook.com/$profileId'),
        mode: LaunchMode.externalApplication,
      );
    } else {
      print("Error while launching Facebook");
      throw 'Could not launch Facebook';
    }
  }

  void launchTwitter(String username) async {
    if (await canLaunchUrl(Uri.parse('https://twitter.com/$username'))) {
      await launchUrl(
        Uri.parse('https://twitter.com/$username'),
        mode: LaunchMode.externalApplication,
      );
    } else {
      print("Error while launching Twitter");
      throw 'Could not launch Twitter';
    }
  }

  void launchInstagram(String username) async {
    if (await canLaunchUrl(Uri.parse('https://www.instagram.com/$username'))) {
      await launchUrl(
        Uri.parse('https://www.instagram.com/$username'),
        mode: LaunchMode.externalApplication,
      );
    } else {
      print("Error while launching Instagram");
      throw 'Could not launch Instagram';
    }
  }

  void launchLinkedIn(String profileId) async {
    if (await canLaunchUrl(Uri.parse('https://www.linkedin.com/in/$profileId'))) {
      await launchUrl(
        Uri.parse('https://www.linkedin.com/in/$profileId'),
        mode: LaunchMode.externalApplication,
      );
    } else {
      print("Error while launching LinkedIn");
      throw 'Could not launch LinkedIn';
    }
  }

  void launchGmail(String recipientEmail, String subject, String body) async {
    final url='mailto:${recipientEmail}?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
            Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        print("No email clients available.");
      }
    } catch (e) {
      print("Error while launching Gmail: $e");
      // Optionally, inform the user or offer an alternative action.
    }
  }



  void bottomSheet({
    required BuildContext context,
   required String userPhoneNumber,
    required String userFaceBook,
    required String userTwitter,
    required String userInsta,
    required String userLinkedIn,
    required String userGmail
}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 26),
            InkWell(
              onTap: (){
                LaunchingFunction().launchPhoneDialer(userPhoneNumber);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Call",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0f1015),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 13),
                  SvgPicture.asset("assets/phone.svg"),
                ],
              ),
            ),
            SizedBox(height: 25),
            InkWell(
              onTap:()=>LaunchingFunction().launchWhatsApp(userPhoneNumber),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Message",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff0f1015),
                      height: 24 / 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 13),
                  SvgPicture.asset("assets/whatsapp.svg"),
                ],
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: ()=> LaunchingFunction().launchFacebook(userFaceBook),
                    child: SvgPicture.asset("assets/facebook.svg")
                ),
                SizedBox(width: 24),
                InkWell(
                    onTap: ()=> LaunchingFunction().launchTwitter(userTwitter),
                    child: SvgPicture.asset("assets/twitter.svg")
                ),
                SizedBox(width: 24),
                InkWell(
                    onTap: ()=> LaunchingFunction().launchInstagram(userInsta),
                    child: SvgPicture.asset("assets/instagram.svg")
                ),
                SizedBox(width: 24),
                InkWell(
                    onTap: ()=> LaunchingFunction().launchLinkedIn(userLinkedIn),
                    child: SvgPicture.asset("assets/linkedin.svg")),
                SizedBox(width: 24),
                InkWell(
                    onTap: ()=>LaunchingFunction().launchGmail(userGmail, 'Interview Scheduling', 'We Would like to schedule your interview...'),
                    child: SvgPicture.asset("assets/google.svg")),
              ],
            ),
            SizedBox(height: 26),
          ],
        ),
      ),
    );
  }


}