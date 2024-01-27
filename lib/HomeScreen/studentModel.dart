import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/profile/profileModels/educationModel.dart';
import '../screens/profile/profileModels/projectModel.dart';
import '../screens/profile/profileModels/workModel.dart';

class StudentProfile {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? userEmail;
  final String? userId;
  final String? userType;
  final String? userBio;
  final String? userFacebook;
  final String? userInsta;
  final String? userLinkedin;
  final String? userProfilePicture;
  final String? userTwitter;
  final List<String>? userDescription;
  final List<String>? interestedOpportunities;
  final List<WorkModel>? workExperience;
  final List<EducationModel>? education;
  final List<ProjectModel>? projects;

  StudentProfile({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.userEmail,
    this.userId,
    this.userType,
    this.userDescription,
    this.interestedOpportunities,
    this.workExperience,
    this.education,
    this.projects,
    this.userBio,
    this.userFacebook,
    this.userInsta,
    this.userLinkedin,
    this.userProfilePicture,
    this.userTwitter,
  });

  factory StudentProfile.fromMap(Map<String, dynamic> data) {
    return StudentProfile(
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      userEmail: data['userEmail'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userType: data['userType'] as String? ?? '',
      userDescription: List<String>.from(data['userDescription'] as List<dynamic>? ?? []),
      interestedOpportunities: List<String>.from(data['interestedOpportunities'] as List<dynamic>? ?? []),
      workExperience: (data['Work Experience'] as List<dynamic>?)
          ?.map((e) => WorkModel.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      education: (data['Education'] as List<dynamic>?)
          ?.map((e) => EducationModel.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
      projects: (data['Projects'] as List<dynamic>?)
          ?.map((e) => ProjectModel.fromMap(e as Map<String, dynamic>))
          .toList() ?? [],
        userBio:data['userBio'],
    userFacebook:data['userFacebook'],
   userInsta:data['userInsta'],
   userLinkedin:data['userLinkedin'],
   userProfilePicture:data['userProfilePicture'],
   userTwitter:data['userTwitter'],

    );
  }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'firstName': firstName ?? '',
  //     'lastName': lastName ?? '',
  //     'phoneNumber': phoneNumber ?? '',
  //     'userEmail': userEmail ?? '',
  //     'userId': userId ?? '',
  //     'userType': userType ?? '',
  //     'userDescription': userDescription ?? [],
  //     'interestedOpportunities': interestedOpportunities ?? [],
  //     'workExperience': workExperience?.map((e) => e.toJson()).toList() ?? [],
  //     'education': education?.map((e) => e.toJson()).toList() ?? [],
  //     'projects': projects?.map((e) => e.toJson()).toList() ?? [],
  //   };
  // }
}

// The WorkModel, EducationModel, and ProjectModel classes are defined as you have provided them.

Future<List<StudentProfile>> fetchStudentProfiles() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore.collection('studentProfiles').get();

  return querySnapshot.docs.map((doc) {
    return StudentProfile.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();
}


