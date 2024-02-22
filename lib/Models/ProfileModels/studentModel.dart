import 'package:cloud_firestore/cloud_firestore.dart';
import '../formModels/educationModel.dart';
import '../formModels/projectModel.dart';
import '../formModels/workModel.dart';

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
  final List<String>? hardSkills;
  final List<String>? softSkills;

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
    this.hardSkills,
    this.softSkills,
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
      softSkills: List<String>.from(data['Soft Skills'] as List<dynamic>? ?? []),
      hardSkills: List<String>.from(data['Hard Skills'] as List<dynamic>? ?? [])
    );
  }

  factory StudentProfile.fromDocument(DocumentSnapshot data) {
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
        softSkills: List<String>.from(data['Soft Skills'] as List<dynamic>? ?? []),
        hardSkills: List<String>.from(data['Hard Skills'] as List<dynamic>? ?? [])

    );
  }
}

Future<List<StudentProfile>> fetchStudentProfiles() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore.collection('studentProfiles').get();

  return querySnapshot.docs
      .where((doc) {
    var data = doc.data();
    return data is Map<String, dynamic> && data['userId'] != "NuX2GWhsHrdwL5u9aPVfxnNJns12";
  })
      .map((doc) => StudentProfile.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
}
