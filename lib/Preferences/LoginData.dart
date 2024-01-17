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

  List<String> getUserInterests(){
    List<dynamic> dynamicList = loginData.read("userInterests");
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  List<String>getUserJobProfile(){
    List<dynamic> dynamicList = loginData.read("userJobProfile");
    List<String> stringList = dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

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

  void writeOptionSelectedVal(bool value){
    loginData.write("optionSelected", value);
  }

  void writePhoneVerifiedStatus(bool value){
    loginData.write("isPhoneVerified", value);
  }

  void writeUserInterests(List<String> interests){
     loginData.write("userInterests", interests);
  }

  void writeUserJobProfile(List<String>jobProfile){
     loginData.write("userJobProfile",jobProfile);
  }

}