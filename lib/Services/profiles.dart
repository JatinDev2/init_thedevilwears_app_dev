import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lookbook/Models/ProfileModels/studentModel.dart';
import '../Models/ProfileModels/brandModel.dart';
import '../Models/formModels/educationModel.dart';
import '../Models/formModels/projectModel.dart';
import '../Models/formModels/workModel.dart';
import '../Preferences/LoginData.dart';
import '../screens/jobs/Applications/applicationModel.dart';
import '../screens/jobs/job_model.dart';

class ApplicationJobPair {
  final Map<String, dynamic> application;
  final jobModel job;

  ApplicationJobPair({required this.application, required this.job});
}

class ProfileServices {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //-----------------------------------------------Fetch Projects---------------------------------------------------------
  Future<List<ProjectModel>> fetchProjects() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    var profileDocument = await _firestore.collection('Profiles').doc(
        currentUser.uid).get();
    if (profileDocument.exists) {
      var data = profileDocument.data() as Map<String, dynamic>;
      var projectsList = List<Map<String, dynamic>>.from(
          data['projects'] ?? []);
      return projectsList.map((projectData) =>
          ProjectModel.fromMap(projectData)).toList();
    } else {
      print('Profile document does not exist');
      return [];
    }
  }

  //-----------------------------------------------Fetch Work Experience---------------------------------------------------------
  Future<List<WorkModel>> fetchWorkExperiences() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    var profileDocument = await _firestore.collection('Profiles').doc(
        currentUser.uid).get();
    if (profileDocument.exists) {
      var data = profileDocument.data() as Map<String, dynamic>;
      var workList = List<Map<String, dynamic>>.from(
          data['Work Experience'] ?? []);
      return workList.map((workData) => WorkModel.fromMap(workData)).toList();
    } else {
      print('Profile document does not exist');
      return [];
    }
  }

  //-----------------------------------------------Fetch Education---------------------------------------------------------
  Future<List<EducationModel>> fetchEducationEntries() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    var profileDocument = await _firestore.collection('Profiles').doc(
        currentUser.uid).get();
    if (profileDocument.exists) {
      var data = profileDocument.data() as Map<String, dynamic>;
      var educationList = List<Map<String, dynamic>>.from(
          data['Education'] ?? []);
      return educationList.map((educationData) =>
          EducationModel.fromMap(educationData)).toList();
    } else {
      print('Profile document does not exist');
      return [];
    }
  }

  //-----------------------------------------------Fetch Work Experience---------------------------------------------------------
  Future<String> fetchWorkExperienceCompanies() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    var profileDocument = await _firestore.collection('studentProfiles').doc(
        currentUser.uid).get();
    if (profileDocument.exists) {
      var data = profileDocument.data() as Map<String, dynamic>;
      var workList = List<Map<String, dynamic>>.from(
          data['Work Experience'] ?? []);
      List<WorkModel> workExperiences = workList.map((workData) =>
          WorkModel.fromMap(workData)).toList();

      String companies = workExperiences.map((work) => work.companyName).join(
          ', ');
      return companies;
    } else {
      print('Profile document does not exist');
      return "";
    }
  }

  //-----------------------------------------------Fetch Most Recent Education---------------------------------------------------------
  Future<String> fetchLatestEducation() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    var profileDocument = await _firestore.collection('studentProfiles').doc(
        currentUser.uid).get();
    if (profileDocument.exists) {
      var data = profileDocument.data() as Map<String, dynamic>;
      var educationList = List<Map<String, dynamic>>.from(
          data['Education'] ?? []);
      List<EducationModel> educationEntries = educationList.map((
          educationData) => EducationModel.fromMap(educationData)).toList();
      educationEntries.sort((a, b) =>
          b.timePeriod.compareTo(a.timePeriod));
      return educationEntries.isNotEmpty
          ? educationEntries.first.instituteName
          : "";
    } else {
      print('Profile document does not exist');
      return "";
    }
  }

  //-----------------------------------------------Future Fetch Application---------------------------------------------------------
  Future<List<applicationModel>> fetchApplications(String jobId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      QuerySnapshot applicationsSnapshot = await _firestore
          .collection('jobListing')
          .doc(jobId)
          .collection('Applications')
          .get();
      List<applicationModel> applications = applicationsSnapshot.docs
          .map((doc) =>
          applicationModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return applications;
    } catch (e) {
      print(e);
      throw Exception('Error fetching applications: $e');
    }
  }

  //-----------------------------------------------Stream Fetch Application---------------------------------------------------------
  Stream<List<applicationModel>> fetchApplicationsStream(String jobId) {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }
    return _firestore
        .collection('jobListing')
        .doc(jobId)
        .collection('Applications')
        .snapshots()
        .map((QuerySnapshot applicationsSnapshot) {
      return applicationsSnapshot.docs
          .map((doc) =>
          applicationModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  //-----------------------------------------------Stream Fetch Application---------------------------------------------------------
  Future<void> updateApplicationStatus(
      String jobListingId, String applicationId, String status, String studentId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference applicationDoc = firestore
        .collection('jobListing')
        .doc(jobListingId)
        .collection('Applications')
        .doc(applicationId);

    await applicationDoc.update({'statusOfApplication': status})
        .catchError((error) => print('Error updating status: $error'));
    DocumentReference studentProfileDoc = firestore
        .collection('studentProfiles')
        .doc(studentId);

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot studentProfileSnapshot = await transaction.get(studentProfileDoc);

      if (!studentProfileSnapshot.exists) {
        throw Exception("Student profile does not exist");
      }

      List<dynamic> applicationsApplied = studentProfileSnapshot.get('applicationsApplied');
      int indexToUpdate = applicationsApplied.indexWhere((application) =>
      application['jobId'] == jobListingId);

      if (indexToUpdate != -1) {
        // Update the status in the specific application
        applicationsApplied[indexToUpdate]['status'] = status;

        // Update the student profile document
        transaction.update(studentProfileDoc, {'applicationsApplied': applicationsApplied});
      } else {
        print("No matching application found in student profile");
      }
    }).catchError((error) => print('Error updating student profile: $error'));
  }

  //---------------------------------Stream Fetch Application for particular student---------------------------------------------------------
  Stream<List<ApplicationJobPair>> streamJobListingsForStudent(String studentId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection('studentProfiles').doc(studentId).snapshots().asyncMap((studentProfileSnapshot) async {
      List<ApplicationJobPair> pairs = [];
      try {
        if (!studentProfileSnapshot.exists || studentProfileSnapshot.data() == null) {
          print("Student profile snapshot does not exist or has no data.");
          return pairs;
        }
        var studentData = studentProfileSnapshot.data() as Map<String, dynamic>;
        if (!studentData.containsKey('applicationsApplied')) {
          print("'applicationsApplied' field is missing.");
          return pairs;
        }
        List<Map<String, dynamic>> applicationsApplied = studentData['applicationsApplied'] is List
            ? List<Map<String, dynamic>>.from(studentData['applicationsApplied'])
            : [];
        for (Map<String, dynamic> application in applicationsApplied) {
          String jobId = application['jobId'];
          DocumentSnapshot data = await firestore.collection('jobListing').doc(jobId).get();
          if (data.exists && data.data() != null) {
            var jobData = data.data() as Map<String, dynamic>;
            jobModel job = jobModel.fromMap(jobData);
            pairs.add(ApplicationJobPair(application: application, job: job));
          } else {
            print("Job listing document (ID: $jobId) does not exist or has no data.");
          }
        }
      } catch (e) {
        print("An error occurred: $e");
      }
      return pairs;
    });
  }


  //-----------------------------------------------Update Student Profile---------------------------------------------------------

  Future<void> updateUserProfile(
      {required List<String> userDescription,
        required String userBio,
        required String userInsta,
        required String userLinkedin,
        required String userTwitter,
        required File imageFile,
        required bool isUpdated,
        required String imgUrl,
        required String firstName,
        required String lastName,
      }) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently logged in.');
    }
    String userId = currentUser.uid;
    if(isUpdated){
      String imagePath = 'userImages/$userId';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(imagePath);
      await ref.putFile(imageFile);
       imgUrl = await ref.getDownloadURL();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference profileRef = firestore.collection('studentProfiles').doc(userId);
    // List<String> userDescriptionList = userDescription.split(',');
    // userDescriptionList = userDescriptionList.map((item) => item.trim()).toList();

    return profileRef.update({
      'userDescription': userDescription,
      'userBio': userBio,
      'userInsta': userInsta,
      'userLinkedin': userLinkedin,
      'userTwitter': userTwitter,
      'userProfilePicture': imgUrl,
      'firstName':firstName,
      'lastName':lastName,
    });
  }


  //-----------------------------------------------Update Brand Profile---------------------------------------------------------

  Future<void> updateBrandProfile(
      {required String userDescription,
        required String userBio,
        required String userInsta,
        required String userLinkedin,
        required String userTwitter,
        required File imageFile,
        required bool isUpdated,
        required String imgUrl,
        required String firstName,
        required String lastName,
      }) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently logged in.');
    }
    String userId = currentUser.uid;
    if(isUpdated){
      String imagePath = 'brandImages/$userId';

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(imagePath);
      await ref.putFile(imageFile);

      imgUrl = await ref.getDownloadURL();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference profileRef = firestore.collection('brandProfiles').doc(userId);
    List<String> userDescriptionList = userDescription.split(',');
    userDescriptionList = userDescriptionList.map((item) => item.trim()).toList();
    return profileRef.update({
      'brandDescription': userDescriptionList,
      'brandBio': userBio,
      'brandInsta': userInsta,
      'brandLinkedin': userLinkedin,
      'brandTwitter': userTwitter,
      'brandProfilePicture': imgUrl,
      'brandtName':firstName,
    });
  }

  //--------------------------------Update Brand Profile Details(Company size,etc)---------------------------------------------------------
  Future<void> updateBrandProfileDetails(
      {required String month,
        required String year,
        required String companySize,
        required String industry,
        required String location,
        required String additionalInfo,
      }) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently logged in.');
    }
    String userId = currentUser.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference profileRef = firestore.collection('brandProfiles').doc(userId);
    return profileRef.update({
      'foundedIn': "${month}, ${year}",
      'companySize': companySize.toString(),
      'industry': industry,
      'companyLocation': location,
      'additionalInfo': additionalInfo,
    });
  }

  //--------------------------------Delete Application---------------------------------------------------------
  Future<void> deleteApplicationStatus(String docId) async {
    String currentUserId = LoginData().getUserId();
    if (currentUserId.isEmpty) {
      print('User ID is not available. Make sure the user is logged in.');
      return;
    }
    final jobListingRef = FirebaseFirestore.instance.collection('jobListing').doc(docId);
    final studentProfileRef = FirebaseFirestore.instance.collection('studentProfiles').doc(currentUserId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot jobListingSnapshot = await transaction.get(jobListingRef);
      DocumentSnapshot studentProfileSnapshot = await transaction.get(studentProfileRef);
      if (jobListingSnapshot.exists && jobListingSnapshot.data() is Map<String, dynamic>) {
        final jobListingData = jobListingSnapshot.data() as Map<String, dynamic>;
        if (jobListingData.containsKey('applicationCount')) {
          final applicationCount = jobListingData['applicationCount'] as int;
          transaction.update(jobListingRef, {'applicationCount': applicationCount - 1});
        }

        if (jobListingData.containsKey('applicationsIDS')) {
          final applicationIds = List.from(jobListingData['applicationsIDS']);
          applicationIds.remove(currentUserId);
          transaction.update(jobListingRef, {'applicationsIDS': applicationIds});
        }
      }

      DocumentReference applicationRef = jobListingRef.collection('Applications').doc(currentUserId);
      transaction.delete(applicationRef);

      if (studentProfileSnapshot.exists && studentProfileSnapshot.data() is Map<String, dynamic>) {
        final studentProfileData = studentProfileSnapshot.data() as Map<String, dynamic>;
        if (studentProfileData.containsKey('applicationsApplied')) {
          final applicationsApplied = List<Map<String, dynamic>>.from(studentProfileData['applicationsApplied']);
          applicationsApplied.removeWhere((application) => application['jobId'] == docId);
          transaction.update(studentProfileRef, {'applicationsApplied': applicationsApplied});
        }
      }
    });
  }
//------------------------------------------------------------------------------------------------------------------------
  //--------------------------------BookMark Brand Profiles ---------------------------------------------------------
  Future<void> bookmarkBrandProfile(String userId, String brandProfileId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles');
    final DocumentReference userDoc = users.doc(userId);
    await userDoc.update({
      'bookmarkedBrandProfiles': FieldValue.arrayUnion([brandProfileId])
    });

    List<String> currentBookmarks = LoginData().getBookmarkedBrandProfiles();
    currentBookmarks.add(brandProfileId);
     LoginData().writeBookmarkedBrandProfiles(currentBookmarks);
  }

  //--------------------------------Remove BookMarked Brand Profiles ---------------------------------------------------------
  Future<void> removeBookmarkedBrandProfile(String userId, String brandProfileId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles');
    final DocumentReference userDoc = users.doc(userId);
    await userDoc.update({
      'bookmarkedBrandProfiles': FieldValue.arrayRemove([brandProfileId])
    }).catchError((error) {
      throw Exception("Failed to remove bookmark in Firestore: $error");
    });

    List<String> currentBookmarks = LoginData().getBookmarkedBrandProfiles();
    if (currentBookmarks != null && currentBookmarks.contains(brandProfileId)) {
      currentBookmarks.remove(brandProfileId);
      LoginData().writeBookmarkedBrandProfiles(currentBookmarks);
    }
  }

  //--------------------------------Fetch BookMarked Brand Profiles ---------------------------------------------------------
  Stream<List<BrandProfile>> fetchBookmarkedBrandProfilesStream() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<DocumentSnapshot> userBookmarksStream = firestore
        .collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles')
        .doc(LoginData().getUserId())
        .snapshots();

    return userBookmarksStream.asyncMap((userSnapshot) async {
      final List<dynamic> bookmarkedIds = (userSnapshot.data() as Map<String, dynamic>?)?['bookmarkedBrandProfiles']?.cast<String>() ?? [];

      List<Future<BrandProfile>> futureProfiles = bookmarkedIds.map((brandId) async {
        DocumentSnapshot brandSnapshot = await firestore.collection('brandProfiles').doc(brandId).get();
        return BrandProfile.fromDocument(brandSnapshot);
      }).toList();

      List<BrandProfile> profiles = await Future.wait(futureProfiles);
      return profiles;
    });
  }

  //--------------------------------BookMark Job Listings ---------------------------------------------------------
  Future<void> bookmarkJobListing(String userId, String jobListingId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles');
    final DocumentReference userDoc = users.doc(userId);
    await userDoc.update({
      'bookmarkedJobListings': FieldValue.arrayUnion([jobListingId])
    });

    List<String> currentBookmarks = LoginData().getBookmarkedJobListings();
    currentBookmarks.add(jobListingId);
    LoginData().writeBookmarkedJobListings(currentBookmarks);
  }

  //--------------------------------Remove BookMarked Job Listings ---------------------------------------------------------
  Future<void> removeBookmarkedJobListing(String userId, String jobListingId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles');
    final DocumentReference userDoc = users.doc(userId);
    await userDoc.update({
      'bookmarkedJobListings': FieldValue.arrayRemove([jobListingId])
    }).catchError((error) {
      throw Exception("Failed to remove bookmark in Firestore: $error");
    });
    List<String> currentBookmarks = LoginData().getBookmarkedJobListings();
    if (currentBookmarks != null && currentBookmarks.contains(jobListingId)) {
      currentBookmarks.remove(jobListingId);
      LoginData().writeBookmarkedJobListings(currentBookmarks);
    }
  }

  //--------------------------------Fetch BookMarked Job Listings ---------------------------------------------------------
  Stream<List<jobModel>> streamBookMarkedJobListings() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore.collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles').doc(LoginData().getUserId()).snapshots().asyncMap((studentProfileSnapshot) async {
      List<jobModel> pairs = [];

      try {
        if (!studentProfileSnapshot.exists || studentProfileSnapshot.data() == null) {
          print("Student profile snapshot does not exist or has no data.");
          return pairs;
        }
        final List<dynamic> bookmarkedIds = (studentProfileSnapshot.data())?['bookmarkedJobListings']?.cast<String>() ?? [];
        print("The list is  : ${bookmarkedIds}");
        for (String value in bookmarkedIds) {
          String jobId = value;
          DocumentSnapshot data = await firestore.collection('jobListing').doc(jobId).get();

          if (data.exists && data.data() != null) {
            var jobData = data.data() as Map<String, dynamic>;
            jobModel job = jobModel.fromMap(jobData);
            pairs.add(job);
          } else {
            print("Job listing document (ID: $jobId) does not exist or has no data.");
          }
        }
      } catch (e) {
        print("An error occurred: $e");
      }
      return pairs;
    });
  }

  //--------------------------------BookMark Student Profiles ---------------------------------------------------------
  Future<void> bookmarkStudentProfile(String userId, String studentProfileId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles');
    final DocumentReference userDoc = users.doc(userId);
    await userDoc.update({
      'bookmarkedStudentProfiles': FieldValue.arrayUnion([studentProfileId])
    });

    List<String> currentBookmarks = LoginData().getBookmarkedStudentProfiles();
    currentBookmarks.add(studentProfileId);
    LoginData().writeBookmarkedStudentProfiles(currentBookmarks);
  }

  //--------------------------------Remove BookMarked Student Profiles ---------------------------------------------------------
  Future<void> removeBookmarkedStudentProfile(String userId, String studentProfileId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles');
    final DocumentReference userDoc = users.doc(userId);
    await userDoc.update({
      'bookmarkedStudentProfiles': FieldValue.arrayRemove([studentProfileId])
    }).catchError((error) {
      throw Exception("Failed to remove bookmark in Firestore: $error");
    });

    List<String> currentBookmarks = LoginData().getBookmarkedStudentProfiles();
    if (currentBookmarks != null && currentBookmarks.contains(studentProfileId)) {
      currentBookmarks.remove(studentProfileId);
      LoginData().writeBookmarkedStudentProfiles(currentBookmarks);
    }
  }

  //--------------------------------Fetch BookMarked Student Profiles ---------------------------------------------------------
  Stream<List<StudentProfile>> fetchBookmarkedStudentProfilesStream(){
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<DocumentSnapshot> userBookmarksStream = firestore
        .collection(LoginData().getUserType()=="Person" ? 'studentProfiles' : 'brandProfiles')
        .doc(LoginData().getUserId())
        .snapshots();
    print("THE ID FOR CURRENT USER IS : ${LoginData().getUserId()}");

    return userBookmarksStream.asyncMap((userSnapshot) async {
      final List<dynamic> bookmarkedIds = (userSnapshot.data() as Map<String, dynamic>?)?['bookmarkedStudentProfiles']?.cast<String>() ?? [];
      List<Future<StudentProfile>> futureProfiles = bookmarkedIds.map((studentId) async {

        DocumentSnapshot brandSnapshot = await firestore.collection('studentProfiles').doc(studentId).get();
        return StudentProfile.fromDocument(brandSnapshot);
      }).toList();


      List<StudentProfile> profiles = await Future.wait(futureProfiles);
      // print(profiles[0].firstName);
      return profiles;
    });
  }



  Future<void> sendRequestForVerification(String brandName, String jobProfile,) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final firstName = LoginData().getUserFirstName() ?? 'Unknown';
    final lastName = LoginData().getUserLastName() ?? 'Unknown';

    final requesterName="${firstName} ${lastName}";

    try {
      CollectionReference brands = firestore.collection('brandProfiles');

      // Query for the document with the specific brandName
      QuerySnapshot querySnapshot = await brands.where('brandName', isEqualTo: brandName).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming brandName is unique and there's only one such document
        DocumentSnapshot brandDocument = querySnapshot.docs.first;

        // Check if data exists and if 'Requests' field is present
        Map<String, dynamic> documentData = brandDocument.data() as Map<String, dynamic>? ?? {};
        List<dynamic> requests = documentData['Requests'] as List<dynamic>? ?? [];

        // Create a new request map
        Map<String, String> newRequest = {
          'userId': LoginData().getUserId(),
          'status': 'pending',
          'requesterName': requesterName,
          'jobProfile':jobProfile
        };

        // Add the new request map to the 'Requests' list
        requests.add(newRequest);

        // Update the document
        brandDocument.reference.update({'Requests': requests});
      } else {
        print('Brand not found');
        // Handle the case where the brandName does not exist
      }
    } catch (e) {
      print(e.toString());
      // Handle any errors here
    }
  }


  Future<void> updateWorkExperienceStatus(String companyName, String roleInCompany, String newStatus,String userId) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;


    if (userId != null) {
      DocumentReference profileRef = firestore.collection('studentProfiles').doc(userId);

      DocumentSnapshot profileSnapshot = await profileRef.get();

      if (profileSnapshot.exists) {
        Map<String, dynamic> profileData = profileSnapshot.data() as Map<String, dynamic>;
        List<dynamic> workExperiences = profileData['Work Experience'] ?? [];

        List<dynamic> updatedWorkExperiences = workExperiences.map((workExperience) {
          if (workExperience['companyName'] == companyName && workExperience['roleInCompany'] == roleInCompany) {
            return {...workExperience, 'status': newStatus};
          }
          return workExperience;
        }).toList();

        await profileRef.update({'Work Experience': updatedWorkExperiences});
      } else {
        print('Profile not found');
      }
    } else {
      print('No user logged in');
    }
  }



  Future<void> updateRequestStatus(String brandProfileDocId, String studentId, String jobProfile, String newStatus) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentReference brandProfileRef = firestore.collection('brandProfiles').doc(brandProfileDocId);

    return firestore.runTransaction<void>((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(brandProfileRef);

      if (!snapshot.exists) {
        throw Exception('Brand Profile Document does not exist.');
      }

      final data = snapshot.data();
      if (data is Map<String, dynamic>) {
        final List<dynamic> requests = data['Requests'] as List<dynamic>? ?? [];
        bool isUpdated = false;

        // Iterate over the requests to find the matching one and update its status
        final List<Map<String, dynamic>> updatedRequests = requests.map((request) {
          if (request is Map<String, dynamic>) {
            if (request['userId'] == studentId && request['jobProfile'] == jobProfile) {
              isUpdated = true;
              return {...request, 'status': newStatus};
            }
          }
          return request as Map<String, dynamic>;
        }).toList();

        // If an update is made, write back to the Firestore document
        if (isUpdated) {
          transaction.update(brandProfileRef, {'Requests': updatedRequests});
        }
      } else {
        throw Exception('Invalid data format');
      }
    });
  }


}