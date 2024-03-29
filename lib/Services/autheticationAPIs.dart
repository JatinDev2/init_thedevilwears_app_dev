import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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



  //--------------------------------Add Student to Database ---------------------------------------------------------
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
        'bookmarkedStudentProfiles':[],
        'Work Experience':[],
        'Projects':[],
        'Education':[],
        'Soft Skills':[],
        'Hard Skills':[]
      });
      return true;
    }catch(e,s){
      print("Error in addStudentToDatabase : $e");
      FirebaseCrashlytics.instance.setCustomKey('userType', LoginData().getUserType());
      FirebaseCrashlytics.instance.setCustomKey('userId', LoginData().getUserId());
      FirebaseCrashlytics.instance.setCustomKey('details', "Error in addStudentToDatabase : $e");
      FirebaseCrashlytics.instance.recordError(e, s);

      return false;
    }
  }

  //--------------------------------Check if User is already logged in ---------------------------------------------------------

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

        List<dynamic> bookMarkedStudent = userData["bookmarkedStudentProfiles"] ?? [];
        if(bookMarkedStudent.isNotEmpty){
          List<String> bookMarkedStudentProfiles = bookMarkedStudent.map((item) => item.toString()).toList();
          LoginData().writeBookmarkedStudentProfiles(bookMarkedStudentProfiles);
        }

        List<dynamic> bookMarkedBrands = userData["bookmarkedBrandProfiles"] ?? [];
        if(bookMarkedStudent.isNotEmpty){
          List<String> bookMarkedBrandProfiles = bookMarkedBrands.map((item) => item.toString()).toList();
          LoginData().writeBookmarkedBrandProfiles(bookMarkedBrandProfiles);
        }

        List<dynamic> bookMarkedListing = userData["bookmarkedJobListings"] ?? [];
        if(bookMarkedListing.isNotEmpty){
          List<String> bookMarkedListings = bookMarkedListing.map((item) => item.toString()).toList();
          LoginData().writeBookmarkedJobListings(bookMarkedListings);
        }

        // LoginData().writeCitiesList(countryCitisStringList);
        // print(LoginData().getListOfAllCities());

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
        LoginData().writeInstaUserId(userData["instaUserID"]);
        List<dynamic> bookMarkedStudent = userData["bookmarkedStudentProfiles"] ?? [];
        if(bookMarkedStudent.isNotEmpty){
          List<String> bookMarkedStudentProfiles = bookMarkedStudent.map((item) => item.toString()).toList();
          LoginData().writeBookmarkedStudentProfiles(bookMarkedStudentProfiles);
        }

        List<dynamic> bookMarkedBrands = userData["bookmarkedBrandProfiles"] ?? [];
        if(bookMarkedStudent.isNotEmpty){
          List<String> bookMarkedBrandProfiles = bookMarkedBrands.map((item) => item.toString()).toList();
          LoginData().writeBookmarkedBrandProfiles(bookMarkedBrandProfiles);
        }

        List<dynamic> bookMarkedListing = userData["bookmarkedJobListings"] ?? [];
        if(bookMarkedListing.isNotEmpty){
          List<String> bookMarkedListings = bookMarkedListing.map((item) => item.toString()).toList();
          LoginData().writeBookmarkedJobListings(bookMarkedListings);
        }
        return true;
      }
      else {
        return false;
      }
    } catch (e,s) {
      print("Error checking userEmail in Firestore: $e");
      FirebaseCrashlytics.instance.setCustomKey('userType', LoginData().getUserType());
      FirebaseCrashlytics.instance.setCustomKey('userId', LoginData().getUserId());
      FirebaseCrashlytics.instance.setCustomKey('details',"Error checking userEmail in Firestore: $e");
      FirebaseCrashlytics.instance.recordError(e, s);

      return false; // Return false in case of any error
    }
  }

  //--------------------------------Add Brand to Database ---------------------------------------------------------
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
        'additionalInfo':'',
        'companyLocation':'',
        'numberOfApplications':0,
        'userId':userId,
        'location':'',
        'brandFacebook':'',
        'instaUserID':'',
        'openings':'',
        'bookmarkedBrandProfiles':[],
        'bookmarkedJobListings':[],
        'bookmarkedStudentProfiles':[]
      });
      return true;
    }catch(e,s){
      print("Error in addBrandToDatabase : $e");
      FirebaseCrashlytics.instance.setCustomKey('userType', LoginData().getUserType());
      FirebaseCrashlytics.instance.setCustomKey('userId', LoginData().getUserId());
      FirebaseCrashlytics.instance.setCustomKey('details',"Error in addBrandToDatabase : $e");
      FirebaseCrashlytics.instance.recordError(e, s);

      return false;
    }
  }


  //--------------------------------Updating Instagram accessToken ---------------------------------------------------------
  Future<void> updateOrCreateAccessToken(String userId, String newAccessToken) async {
    var studentProfilesRef = FirebaseFirestore.instance.collection('brandProfiles').doc(userId);

    return studentProfilesRef.get().then((doc) {
      if (doc.exists) {
        return studentProfilesRef.update({'accessToken': newAccessToken});
      } else {
        return studentProfilesRef.set({'accessToken': newAccessToken});
      }
    }).catchError((error,s) {
      print('Error updating accessToken: $error');
      FirebaseCrashlytics.instance.setCustomKey('userType', LoginData().getUserType());
      FirebaseCrashlytics.instance.setCustomKey('userId', LoginData().getUserId());
      FirebaseCrashlytics.instance.setCustomKey('details','Error updating accessToken: $error');
      FirebaseCrashlytics.instance.recordError(error, s);

      throw error;
    });
  }

  //--------------------------------Updating Instagram User id  ---------------------------------------------------------
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
    }).catchError((error,s) {
      print('Error updating instaUserId: $error');
      FirebaseCrashlytics.instance.setCustomKey('userType', LoginData().getUserType());
      FirebaseCrashlytics.instance.setCustomKey('userId', LoginData().getUserId());
      FirebaseCrashlytics.instance.setCustomKey('details','Error updating instaUserId: $error');
      FirebaseCrashlytics.instance.recordError(error, s);

      throw error;
    });
  }

}