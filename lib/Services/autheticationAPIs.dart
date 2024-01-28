import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lookbook/Preferences/LoginData.dart';

class FirebaseAuthAPIs{
  final userId=LoginData().getUserId();
  final userFirstName=LoginData().getUserFirstName();
  final userLastName=LoginData().getUserLastName();
  final userPhoneNumber=LoginData().getUserPhoneNumber();
  final userType=LoginData().getUserType();
  final userEmail=LoginData().getUserEmail();
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('studentProfiles');
  final CollectionReference brandsCollection = FirebaseFirestore.instance.collection('brandProfiles');

  Future<bool> addStudentToDatabase(List<String>userDescription, List<String>interestedOpportunities) async{
    try{
      await usersCollection.doc(userId).set({
        'firstName': userFirstName,
        'lastName': userLastName,
        'phoneNumber': userPhoneNumber.replaceAll(" ", ""),
        'userEmail': userEmail,
        'userDescription':userDescription,
        'interestedOpportunities':interestedOpportunities,
        'userType': userType,
        'userBio':'',
        'userFacebook':'',
        'userGmail':'',
        'userInsta':'',
        'userLinkedin':'',
        'userTwitter':'',
        'userProfilePicture':'',
        'userId':userId,
        'bookmarkedBrandProfiles':[],
        'bookmarkedJobListings':[],
      });
      return true;
    }catch(e){
      print("Error in addStudentToDatabase : $e");
      return false;
    }
  }

  Future<bool> checkStudentEmailInFireStore() async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('studentProfiles');
      final userDocument = await userCollection.doc(userId).get();

      final brandCollection=FirebaseFirestore.instance.collection('brandProfiles');

      final brandDoc=await brandCollection.doc(userId).get();

      if (userDocument.exists){
        var userData = userDocument.data();
        LoginData().writeUserFirstName(userData!["firstName"].toString());
        LoginData().writeUserLastName(userData["lastName"].toString());
        List<dynamic> dynamicList = userData["interestedOpportunities"];
        List<String> stringList = dynamicList.map((item) => item.toString()).toList();
        LoginData().writeUserInterests(stringList);
        List<dynamic> jPList = userData["userDescription"];
        List<String> jPstringList = jPList.map((item) => item.toString()).toList();
        LoginData().writeUserJobProfile(jPstringList);
        LoginData().writeUserType(userData["userType"]);
        LoginData().writeUserPhoneNumber(userData["phoneNumber"]);
        return true;
      }
      else if(brandDoc.exists){
        var userData = brandDoc.data();
        LoginData().writeUserFirstName(userData!["brandName"].toString());
        LoginData().writeUserLastName(userData["companyName"].toString());
        List<dynamic> dynamicList = userData["interestedProfiles"];
        List<String> stringList = dynamicList.map((item) => item.toString()).toList();
        LoginData().writeUserInterests(stringList);

        List<dynamic> jPList = userData["brandDescription"];
        List<String> jPstringList = jPList.map((item) => item.toString()).toList();
        LoginData().writeUserJobProfile(jPstringList);
        LoginData().writeUserType(userData["userType"]);
        LoginData().writeUserPhoneNumber(userData["phoneNumber"]);
        LoginData().writeUserAccessToken(userData["accessToken"]);
        LoginData().writeInstaUserId(userData["instaUserId"]);
        return true;
      }
      else {
        return false;
      }
    } catch (e) {
      print("Error checking userEmail in Firestore: $e");
      return false; // Return false in case of any error
    }
  }

  Future<bool> addBrandToDatabase(List<String>userDescription, List<String>interestedOpportunities) async{
    try{
      await brandsCollection.doc(userId).set({
        'brandName': userFirstName,
        'companyName': userLastName,
        'phoneNumber': userPhoneNumber.replaceAll(" ", ""),
        'userEmail': userEmail,
        'brandDescription':userDescription,
        'interestedProfiles':interestedOpportunities,
        'userType': userType,
        'brandBio':'',
        'brandInsta':'',
        'brandLinkedIn':'',
        'brandTwitter':'',
        'brandProfilePicture':'',
        'companySize':'',
        'foundedIn':'',
        'industry':'',
        'numberOfApplications':0,
        'userId':userId,
        'location':'',
        'brandFacebook':''
      });
      return true;
    }catch(e){
      print("Error in addBrandToDatabase : $e");
      return false;
    }
  }

  Future<void> updateOrCreateAccessToken(String userId, String newAccessToken) async {
    var studentProfilesRef = FirebaseFirestore.instance.collection('brandProfiles').doc(userId);

    return studentProfilesRef.get().then((doc) {
      if (doc.exists) {
        // Document exists, update the accessToken
        return studentProfilesRef.update({'accessToken': newAccessToken});
      } else {
        // Document does not exist, create it with the accessToken
        return studentProfilesRef.set({'accessToken': newAccessToken});
      }
    }).catchError((error) {
      print('Error updating accessToken: $error');
      throw error;
    });
  }

  Future<void> updateOrCreateInstaUserId(String userId, String instaUserId) async {
    var studentProfilesRef = FirebaseFirestore.instance.collection('brandProfiles').doc(userId);

    return studentProfilesRef.get().then((doc) {
      if (doc.exists) {
        // Document exists, update the accessToken
        return studentProfilesRef.update({'instaUserId': instaUserId});
      } else {
        // Document does not exist, create it with the accessToken
        return studentProfilesRef.set({'instaUserId': instaUserId});
      }
    }).catchError((error) {
      print('Error updating instaUserId: $error');
      throw error;
    });
  }

}