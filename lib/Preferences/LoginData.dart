import 'package:get_storage/get_storage.dart';

class LoginData{
  final loginData = GetStorage('LoginData');

   String getUserName(){
    return loginData.read("userName") ?? "Unknown";
  }

  String getUserEmail(){
    return loginData.read("userEmail") ?? "Unknown";
  }

  String getUserId(){
    return loginData.read("userId") ?? "Unknown";
  }

  String getUserFirstName(){
    return loginData.read("userFirstName") ?? "Unknown";
  }

  String getUserLastName(){
    return loginData.read("userLastName") ?? "Unknown";
  }

  String getUserPhoneNumber(){
    return loginData.read("userPhoneNumber") ?? "Unknown";
  }

  String getUserType(){
    return loginData.read("userType") ?? "Unknown";
  }

  String getUserProfilePicture(){
    return loginData.read("userProfilePicture") ?? "";
  }

  List<String> getUserInterests(){
    List<dynamic> dynamicList = loginData.read("userInterests") ?? [];
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  List<String>getUserJobProfile(){
    List<dynamic> dynamicList = loginData.read("userJobProfile");
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  List<String>getBookmarkedBrandProfiles(){
    List<dynamic> dynamicList = loginData.read("bookmarkedBrandProfiles") ?? [];
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  List<String>getBookmarkedJobListings(){
    List<dynamic> dynamicList = loginData.read("bookmarkedJobListings") ?? [];
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  List<String>getBookmarkedStudentProfiles(){
    List<dynamic> dynamicList = loginData.read("bookmarkedStudentProfiles") ?? [];
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  String getUserAccessToken(){
     return loginData.read("userAccessToken") ?? "No token";
  }

  String getUserInstaId(){
     return loginData.read("instaUserId") ?? "No insta id";
  }

  List<String>getListOfAllCities(){
    List<dynamic> dynamicList = loginData.read("allCities") ?? [];
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }


  // String getIsHomePage(){
  //   return loginData.read("isHomePage") ?? "false";
  // }
  //
  // bool isOptionSelected(){
  //    return loginData.read<bool>("optionSelected") ?? false;
  // }
  //
  // bool isHomePage(){
  //   return loginData.read<bool>("isHomePage") ?? false;
  // }
  //
  // bool isPhoneVerified(){
  //   return loginData.read<bool>("isPhoneVerified") ?? false;
  // }
  //
  // bool isLoggedIn(){
  //   return loginData.read<bool>("isLoggedIn") ?? false;
  // }

  //---------------------------------------------Login Prefs--------------------------------------------------------

//-------------------/---------------------------------------------Red-------------------------------------------------------------

  bool getIsLoginOptionDone(){
   return loginData.read<bool>("isLoginOptionDone") ?? false;
  }

  bool getIsUserTypeSelected(){
    return loginData.read<bool>("isUserTypeSelected") ?? false;
  }

  bool getIsPhoneNumberVerified(){
    return loginData.read<bool>("isPhoneNumberVerified") ?? false;
  }

  bool getIsJobProfileSelected(){
    return loginData.read<bool>("isJobProfileSelected") ?? false;
  }

  bool getIsInterestsSelected(){
    return loginData.read<bool>("isInterestsSelected") ?? false;
  }

  bool getIsLoggedIn(){
    return loginData.read<bool>("isLoggedIn") ?? false;
  }



//-------------------/---------------------------------------------Write-------------------------------------------------------------

  void writeIsLoginOptionDone(bool value){
    loginData.write("isLoginOptionDone",value);
  }

  void writeIsUserTypeSelected(bool value){
    loginData.write("isUserTypeSelected",value);
  }

  void writeIsPhoneNumberVerified(bool value){
     loginData.write("isPhoneNumberVerified", value);
   }

   void writeIsJobProfileSelected(bool value){
     loginData.write("isJobProfileSelected", value);
   }

   void writeIsInterestsSelected(bool value){
     loginData.write("isInterestsSelected", value);
   }

   void writeIsLoggedIn(bool value){
     loginData.write("isLoggedIn", value);
   }

  //---------------------------------------------Write-------------------------------------------------------------

  void writeUserName(String userName){
     loginData.write("userName",userName);
  }

  void writeUserEmail(String userEmail){
     loginData.write("userEmail",userEmail);
  }

  void writeUserId(String userId){
     loginData.write("userId",userId);
  }

  void writeUserFirstName(String userFirstName){
     loginData.write("userFirstName",userFirstName);
  }

  void writeUserLastName(String userLastName){
     loginData.write("userLastName",userLastName);
  }

  void writeUserType(String userType){
    loginData.write("userType",userType);
  }

  void writeUserPhoneNumber(String userPhoneNumber){
    loginData.write("userPhoneNumber",userPhoneNumber);
  }


  void writeUserInterests(List<String> interests){
     loginData.write("userInterests", interests);
  }

  void writeUserJobProfile(List<String>jobProfile){
     loginData.write("userJobProfile",jobProfile);
  }

  void writeUserAccessToken(String token){
     print("I was called : ${token}");
    loginData.write("userAccessToken",token);
  }

  void writeInstaUserId(String instaUserId){
     loginData.write("instaUserId",instaUserId);
  }

  void writeUserProfilePicture(String imgUrl){
     loginData.write("userProfilePicture",imgUrl);
  }

  void writeBookmarkedBrandProfiles(List<String> profiles){
    loginData.write("bookmarkedBrandProfiles", profiles);
  }

  void writeBookmarkedJobListings(List<String> profiles){
    loginData.write("bookmarkedJobListings", profiles);
  }

  void writeBookmarkedStudentProfiles(List<String> profiles){
    loginData.write("bookmarkedStudentProfiles", profiles);
  }

  void writeCitiesList(List<String> allCities){
    loginData.write("allCities", allCities);
  }



//---------------------------------------------Write For Jobs-------------------------------------------------------------

  void writeJobType(String jobType){
     loginData.write("jobType", jobType);
  }

  void writeJobProfile(String jobProfile){
    loginData.write("jobProfile", jobProfile);
  }

  void writeResponsibilities(String responsibilities){
    loginData.write("responsibilities", responsibilities);
  }

  void writeJobDurationType(String jobDurationType){
    loginData.write("jobDurationType", jobDurationType);
  }

  void writeJobDurationValue(String jobDurValue){
    loginData.write("jobDurationValue", jobDurValue);
  }

  void writeJobDurationValueTime(String jobDurationValueTime){
    loginData.write("jobDurationValueTime", jobDurationValueTime);
  }

  void writeType(String type){
    loginData.write("type", type);
  }

  void writeJobLocationState(String state){
    loginData.write("jobState", state);
  }

  void writeJobLocationCity(String city){
    loginData.write("jobCity", city);
  }

  void writeTentativeStartDate(String tentativeStartDate){
    loginData.write("tentativeStartDate", tentativeStartDate);
  }

  void writeExactDate(String exactDate){
    loginData.write("exactDate", exactDate);
  }

  void writeStipendOptionValue(String optionValue){
    loginData.write("stipendOptionValue", optionValue);
  }

  void writeStipendAmount(String stipendAmount){
    loginData.write("stipendAmount", stipendAmount);
  }

  void writeStipendAmountTime(String optionValue){
    loginData.write("stipendAmountTime", optionValue);
  }

  void writeNumberOfOpenings(String numberOfOpenings){
    loginData.write("numberOfOpenings", numberOfOpenings);
  }

  void writeSelectedPerks(List<String> selectedPerks){
    loginData.write("selectedPerks", selectedPerks);
  }

  void writeEmployeePreference(List<String> selectedPreferences){
    loginData.write("selectedPreferences", selectedPreferences);
  }

  //---------------------------------------------Get For Jobs-------------------------------------------------------------

  String getJobType(){
    return loginData.read("jobType") ?? "";
  }

  String getJobProfile(){
    return loginData.read("jobProfile") ?? "";
  }

  String getResponsibilities(){
    return loginData.read("responsibilities") ?? "";
  }

  String getJobDurationType(){
    return loginData.read("jobDurationType") ?? "";
  }

  String getJobDurationValue(){
    return loginData.read("jobDurationValue") ?? "";
  }

  String getJobDurationValueTime(){
    return loginData.read("jobDurationValueTime") ?? "";
  }

  String getType(){
    return loginData.read("type") ?? "";
  }

  String getTentativeStartDate(){
    return loginData.read("tentativeStartDate") ?? "";
  }

  String getExactDate(){
    return loginData.read("exactDate") ?? "";
  }

  String getStipendOptionValue(){
    return loginData.read("stipendOptionValue") ?? "";
  }

  String getStipendAmount(){
    return loginData.read("stipendAmount") ?? "";
  }

  String getStipendAmountTime(){
    return loginData.read("stipendAmountTime") ?? "";
  }

  String getNumberOfOpenings(){
    return loginData.read("numberOfOpenings") ?? "";
  }

  List<String>getSelectedPerks(){
    List<dynamic> dynamicList = loginData.read("selectedPerks") ?? [];
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  List<String>getEmployeePreference(){
    List<dynamic> dynamicList = loginData.read("selectedPreferences") ?? [];
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

}