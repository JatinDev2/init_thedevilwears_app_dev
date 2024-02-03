import 'package:cloud_firestore/cloud_firestore.dart';

class BrandProfile {
  final String brandName;
  final List<String> brandDescription;
  final String companyName;
  final List<String> interestedProfiles;
  final String location;
  final int numberOfApplications;
  final String phoneNumber;
  final String userEmail;
  final String userType;
  final String userId;
  final String brandBio;
  final String companySize;
  final String foundedIn;
  final String industry;
  final String brandProfilePicture;
  final String brandInsta;
  final String brandTwitter;
  final String brandFacebook;
  final String brandLinkedIn;
  final String instaUserId;
  final String accessToken;
  final String openings;

  BrandProfile({
    required this.brandName,
    required this.brandDescription,
    required this.companyName,
    required this.interestedProfiles,
    required this.location,
    required this.numberOfApplications,
    required this.phoneNumber,
    required this.userEmail,
    required this.userType,
    required this.userId,
    required this.brandBio,
    required this.brandProfilePicture,
    required this.companySize,
    required this.foundedIn,
    required this.industry,
    required this.brandFacebook,
    required this.brandInsta,
    required this.brandTwitter,
    required this.brandLinkedIn,
    required this.accessToken,
    required this.instaUserId,
    required this.openings,
  });
  // locations,

  factory BrandProfile.fromDocument(DocumentSnapshot doc) {
    print("ID is : ${doc['userId']}");
    return BrandProfile(
      brandName: doc['brandName'] ?? '',
      brandDescription: List<String>.from(doc['brandDescription'] ?? []),
      companyName: doc['companyName'] ?? '',
      interestedProfiles: List<String>.from(doc['interestedProfiles'] ?? []),
      location: doc['location'] ?? '',
      numberOfApplications: doc['numberOfApplications'] ?? 0,
      phoneNumber: doc['phoneNumber'] ?? '',
      userEmail: doc['userEmail'] ?? '',
      userType: doc['userType'] ?? '',
      userId: doc['userId'] ?? '',
      brandBio: doc['brandBio'] ?? '',
      brandProfilePicture: doc['brandProfilePicture'] ?? '',
      companySize: doc['companySize'] ?? '',
      foundedIn: doc['foundedIn'] ?? '',
      industry: doc['industry'] ?? '',
      brandFacebook: doc['brandFacebook'] ?? '',
      brandInsta: doc['brandInsta'] ?? '',
      brandTwitter: doc['brandTwitter'] ?? '',
      brandLinkedIn: doc['brandLinkedIn'] ?? '',
      accessToken: doc['accessToken'] ?? '',
      instaUserId: doc['instaUserId'] ?? '',
      openings: doc['openings'] ?? '',

    );
  }

  factory BrandProfile.fromMap(Map<String, dynamic> doc) {
    return BrandProfile(
      brandName: doc['brandName'] ?? '',
      brandDescription: List<String>.from(doc['brandDescription'] ?? []),
      companyName: doc['companyName'] ?? '',
      interestedProfiles: List<String>.from(doc['interestedProfiles'] ?? []),
      location: doc['location'] ?? '',
      numberOfApplications: doc['numberOfApplications'] ?? 0,
      phoneNumber: doc['phoneNumber'] ?? '',
      userEmail: doc['userEmail'] ?? '',
      userType: doc['userType'] ?? '',
      userId: doc['userId'] ?? '',
      brandBio: doc['brandBio'] ?? '',
      brandProfilePicture: doc['brandProfilePicture'] ?? '',
      companySize: doc['companySize'] ?? '',
      foundedIn: doc['foundedIn'] ?? '',
      industry: doc['industry'] ?? '',
      brandFacebook: doc['brandFacebook'] ?? '',
      brandInsta: doc['brandInsta'] ?? '',
      brandTwitter: doc['brandTwitter'] ?? '',
      brandLinkedIn: doc['brandLinkedIn'] ?? '',
      accessToken: doc['accessToken'] ?? '',
      instaUserId: doc['instaUserId'] ?? '',
      openings: doc['openings'] ?? '',
    );
  }

}

Future<List<BrandProfile>> fetchBrandProfiles() async {
  // Assuming 'brandProfiles' is the collection where profiles are stored
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('brandProfiles').get();

  return querySnapshot.docs.map((doc) => BrandProfile.fromDocument(doc)).toList();
}
