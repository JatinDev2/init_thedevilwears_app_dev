import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import '../HomeScreen/brandModel.dart';
import '../Preferences/LoginData.dart';
import '../screens/jobs/Applications/applicationModel.dart';
import '../screens/jobs/job_model.dart';
import '../screens/profile/profileModels/educationModel.dart';
import '../screens/profile/profileModels/projectModel.dart';
import '../screens/profile/profileModels/workModel.dart';

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

      // Assuming that EducationModel has a getter `timePeriod` which is a DateTime object
      // If it's not a DateTime, you will need to convert it before you can sort
      educationEntries.sort((a, b) =>
          b.timePeriod.compareTo(a.timePeriod)); // Sort in descending order

      // Return the first item in the sorted list, which is the most recent
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
      // Fetch the "Applications" subcollection
      QuerySnapshot applicationsSnapshot = await _firestore
          .collection('jobListing')
          .doc(jobId)
          .collection('Applications')
          .get();

      // Convert each document to ApplicationModel
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

    // Return a stream of application model lists
    return _firestore
        .collection('jobListing')
        .doc(jobId)
        .collection('Applications')
        .snapshots()
        .map((QuerySnapshot applicationsSnapshot) {
      // Convert each document to ApplicationModel
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

    // Update the application status in the jobListing collection
    DocumentReference applicationDoc = firestore
        .collection('jobListing')
        .doc(jobListingId)
        .collection('Applications')
        .doc(applicationId);

    await applicationDoc.update({'statusOfApplication': status})
        .catchError((error) => print('Error updating status: $error'));

    // Update the application status in the studentProfiles collection
    DocumentReference studentProfileDoc = firestore
        .collection('studentProfiles')
        .doc(studentId);

    await firestore.runTransaction((transaction) async {
      // Get the student profile document
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



  // Stream<List<jobModel>> streamJobListingsForStudent(String studentId) {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //   // Stream of the student profile document
  //   Stream<DocumentSnapshot> studentProfileStream = firestore
  //       .collection('studentProfiles')
  //       .doc(studentId)
  //       .snapshots();
  //
  //   return studentProfileStream.asyncMap((studentProfileSnapshot) async {
  //     // Check if the document exists and has data
  //     if (!studentProfileSnapshot.exists ||
  //         studentProfileSnapshot.data() == null) {
  //       return [
  //       ]; // Return an empty list if the document doesn't exist or has no data
  //     }
  //
  //     var studentData = studentProfileSnapshot.data() as Map<String, dynamic>;
  //
  //     // Check if the 'applicationsApplied' field exists
  //     if (!studentData.containsKey('applicationsApplied')) {
  //       return [
  //       ]; // Return an empty list if the 'applicationsApplied' field is not found
  //     }
  //
  //     // Extract the 'applicationsApplied' map
  //     Map<String, dynamic> applicationsAppliedDynamic = studentData['applicationsApplied'];
  //
  //     // Map<String, String> applicationsApplied = applicationsAppliedDynamic.map((key, value) => MapEntry(key, value.toString()));
  //
  //
  //     // Fetch job listings based on application IDs
  //     List<jobModel> jobListings = [];
  //     for (String jobId in applicationsAppliedDynamic.keys) {
  //       print("Hello check");
  //       print(jobId);
  //       DocumentSnapshot data = await firestore
  //           .collection('jobListing')
  //           .doc(jobId)
  //           .get();
  //       if (data.exists) {
  //         print("Hello check");
  //         jobModel job = jobModel(
  //             jobType : data["jobType"] ?? "",
  //             jobProfile : data["jobProfile"] ?? "",
  //             responsibilities : data["responsibilities"] ?? "",
  //             jobDuration : data["jobDuration"] ?? "",
  //             jobDurExact : data["jobDurationExact"] ?? "",
  //             workMode : data["workMode"] ?? "",
  //             officeLoc : data["officeLoc"] ?? "",
  //             tentativeStartDate : data["tentativeStartDate"] ?? "",
  //             stipend : data["stipend"] ?? "",
  //             stipendAmount : data["stipendAmount"] ?? "",
  //             numberOfOpenings : data["numberOfOpenings"] ?? "",
  //             perks : data["perks"] ?? [],
  //             createdBy : data["createdBy"] ?? "",
  //             createdAt : data["createdAt"] ?? "",
  //             userId : data["userId"] ?? "",
  //             jobDurVal : data["jobDurVal"] ?? "",
  //             stipendVal : data["stipendVal"] ?? "",
  //             tags : data["tags"] ?? [],
  //             applicationCount: data["applicationCount"] ?? 0,
  //             clicked: data["clicked"] ?? false,
  //             docId: data["docId"] ?? "",
  //             applicationsIDS: data["applicationsIDS"] ?? [],
  //           interests: data["interests"] ?? [],
  //           brandPfp: data["brandPfp"] ?? ""
  //         );
  //         jobListings.add(job);
  //       }
  //     }
  //
  //     return jobListings;
  //   });
  // }

  // Stream<List<ApplicationJobPair>> streamJobListingsForStudent(String studentId) {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //
  //   return firestore.collection('studentProfiles').doc(studentId).snapshots().asyncMap((studentProfileSnapshot) async {
  //     List<ApplicationJobPair> pairs = [];
  //
  //     if (!studentProfileSnapshot.exists || studentProfileSnapshot.data() == null) {
  //       return pairs;
  //     }
  //
  //     var studentData = studentProfileSnapshot.data() as Map<String, dynamic>;
  //     if (!studentData.containsKey('applicationsApplied')) {
  //       return pairs;
  //     }
  //
  //     List<Map<String, dynamic>> applicationsApplied = studentData['applicationsApplied'] is List
  //         ? List<Map<String, dynamic>>.from(studentData['applicationsApplied'])
  //         : [];
  //
  //     for (Map<String, dynamic> application in applicationsApplied) {
  //       String jobId = application['jobId'];
  //       DocumentSnapshot data = await firestore.collection('jobListing').doc(jobId).get();
  //
  //       if (data.exists) {
  //         jobModel job = jobModel(
  //             jobType : data["jobType"] ?? "",
  //             jobProfile : data["jobProfile"] ?? "",
  //             responsibilities : data["responsibilities"] ?? "",
  //             jobDuration : data["jobDuration"] ?? "",
  //             jobDurExact : data["jobDurationExact"] ?? "",
  //             workMode : data["workMode"] ?? "",
  //             officeLoc : data["officeLoc"] ?? "",
  //             tentativeStartDate : data["tentativeStartDate"] ?? "",
  //             stipend : data["stipend"] ?? "",
  //             stipendAmount : data["stipendAmount"] ?? "",
  //             numberOfOpenings : data["numberOfOpenings"] ?? "",
  //             perks : data["perks"] ?? [],
  //             createdBy : data["createdBy"] ?? "",
  //             createdAt : data["createdAt"] ?? "",
  //             userId : data["userId"] ?? "",
  //             jobDurVal : data["jobDurVal"] ?? "",
  //             stipendVal : data["stipendVal"] ?? "",
  //             tags : data["tags"] ?? [],
  //             applicationCount: data["applicationCount"] ?? 0,
  //             clicked: data["clicked"] ?? false,
  //             docId: data["docId"] ?? "",
  //             applicationsIDS: data["applicationsIDS"] ?? [],
  //             interests: data["interests"] ?? [],
  //             brandPfp: data["brandPfp"] ?? ""
  //         );
  //         pairs.add(ApplicationJobPair(application: application, job: job));
  //       }
  //     }
  //
  //     return pairs;
  //   });
  // }

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
            jobModel job = jobModel(
                jobType : data["jobType"] ?? "",
                jobProfile : data["jobProfile"] ?? "",
                responsibilities : data["responsibilities"] ?? "",
                jobDuration : data["jobDuration"] ?? "",
                jobDurExact : data["jobDurationExact"] ?? "",
                workMode : data["workMode"] ?? "",
                officeLoc : data["officeLoc"] ?? "",
                tentativeStartDate : data["tentativeStartDate"] ?? "",
                stipend : data["stipend"] ?? "",
                stipendAmount : data["stipendAmount"] ?? "",
                numberOfOpenings : data["numberOfOpenings"] ?? "",
                perks : data["perks"] ?? [],
                createdBy : data["createdBy"] ?? "",
                createdAt : data["createdAt"] ?? "",
                userId : data["userId"] ?? "",
                jobDurVal : data["jobDurVal"] ?? "",
                stipendVal : data["stipendVal"] ?? "",
                tags : data["tags"] ?? [],
                applicationCount: data["applicationCount"] ?? 0,
                clicked: data["clicked"] ?? false,
                docId: data["docId"] ?? "",
                applicationsIDS: data["applicationsIDS"] ?? [],
                interests: data["interests"] ?? [],
                brandPfp: data["brandPfp"] ?? "",
                phoneNumber: LoginData().getUserPhoneNumber()

            );
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
    // Ensure Firebase is initialized
    await Firebase.initializeApp();

    // Get the current user
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

    // Convert userDescription from a comma-separated string to a list
    List<String> userDescriptionList = userDescription.split(',');

    // Trim whitespace from each element in the list
    userDescriptionList = userDescriptionList.map((item) => item.trim()).toList();


    return profileRef.update({
      'userDescription': userDescriptionList,
      'userBio': userBio,
      'userInsta': userInsta,
      'userLinkedin': userLinkedin,
      'userTwitter': userTwitter,
      'userProfilePicture': imgUrl,
      'firstName':firstName,
      'lastName':lastName,
    });
  }



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
    // Ensure Firebase is initialized
    await Firebase.initializeApp();

    // Get the current user
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

    // Convert userDescription from a comma-separated string to a list
    List<String> userDescriptionList = userDescription.split(',');

    // Trim whitespace from each element in the list
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


  Future<void> updateBrandProfileDetails(
      {required String month,
        required String year,
        required String companySize,
        required String industry,
        required String location,
        required String additionalInfo,
      }) async {
    // Ensure Firebase is initialized
    await Firebase.initializeApp();

    // Get the current user
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


  Future<void> deleteApplicationStatus(String docId) async {
    String currentUserId = LoginData().getUserId();
    if (currentUserId.isEmpty) {
      print('User ID is not available. Make sure the user is logged in.');
      return;
    }

    final jobListingRef = FirebaseFirestore.instance.collection('jobListing').doc(docId);
    final studentProfileRef = FirebaseFirestore.instance.collection('studentProfiles').doc(currentUserId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      // First, perform all the read operations.
      DocumentSnapshot jobListingSnapshot = await transaction.get(jobListingRef);
      DocumentSnapshot studentProfileSnapshot = await transaction.get(studentProfileRef);

      // Then, after all the reads are done, perform the write operations.
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

      // Delete the application document from the Applications subcollection
      DocumentReference applicationRef = jobListingRef.collection('Applications').doc(currentUserId);
      transaction.delete(applicationRef);

      // Remove the application entry from applicationsApplied in studentProfiles
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

  Future<void> bookmarkBrandProfile(String userId, String brandProfileId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('studentProfiles');
    final DocumentReference userDoc = users.doc(userId);

    // Add to Firebase
    await userDoc.update({
      'bookmarkedBrandProfiles': FieldValue.arrayUnion([brandProfileId])
    });

    // Add to local storage
    List<String> currentBookmarks = LoginData().getBookmarkedBrandProfiles();
    currentBookmarks.add(brandProfileId);
     LoginData().writeBookmarkedBrandProfiles(currentBookmarks);
  }

  Future<void> removeBookmarkedBrandProfile(String userId, String brandProfileId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('studentProfiles');
    final DocumentReference userDoc = users.doc(userId);

    // Remove from Firebase
    await userDoc.update({
      'bookmarkedBrandProfiles': FieldValue.arrayRemove([brandProfileId])
    }).catchError((error) {
      throw Exception("Failed to remove bookmark in Firestore: $error");
    });

    // Remove from local storage
    List<String> currentBookmarks = LoginData().getBookmarkedBrandProfiles();
    if (currentBookmarks != null && currentBookmarks.contains(brandProfileId)) {
      currentBookmarks.remove(brandProfileId);
      LoginData().writeBookmarkedBrandProfiles(currentBookmarks);
    }
  }


  Stream<List<BrandProfile>> fetchBookmarkedBrandProfilesStream() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<DocumentSnapshot> userBookmarksStream = firestore
        .collection('studentProfiles')
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

  Future<void> bookmarkJobListing(String userId, String jobListingId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('studentProfiles');
    final DocumentReference userDoc = users.doc(userId);

    // Add to Firebase
    await userDoc.update({
      'bookmarkedJobListings': FieldValue.arrayUnion([jobListingId])
    });

    // Add to local storage
    List<String> currentBookmarks = LoginData().getBookmarkedJobListings();
    currentBookmarks.add(jobListingId);
    LoginData().writeBookmarkedJobListings(currentBookmarks);
  }

  Future<void> removeBookmarkedJobListing(String userId, String jobListingId) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('studentProfiles');
    final DocumentReference userDoc = users.doc(userId);

    // Remove from Firebase
    await userDoc.update({
      'bookmarkedJobListings': FieldValue.arrayRemove([jobListingId])
    }).catchError((error) {
      throw Exception("Failed to remove bookmark in Firestore: $error");
    });

    // Remove from local storage
    List<String> currentBookmarks = LoginData().getBookmarkedJobListings();
    if (currentBookmarks != null && currentBookmarks.contains(jobListingId)) {
      currentBookmarks.remove(jobListingId);
      LoginData().writeBookmarkedJobListings(currentBookmarks);
    }
  }


  Stream<List<jobModel>> streamBookMarkedJobListings() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore.collection('studentProfiles').doc(LoginData().getUserId()).snapshots().asyncMap((studentProfileSnapshot) async {
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
            jobModel job = jobModel(
                jobType : jobData["jobType"] ?? "",
                jobProfile : jobData["jobProfile"] ?? "",
                responsibilities : jobData["responsibilities"] ?? "",
                jobDuration : jobData["jobDuration"] ?? "",
                jobDurExact : jobData["jobDurationExact"] ?? "",
                workMode : jobData["workMode"] ?? "",
                officeLoc : jobData["officeLoc"] ?? "",
                tentativeStartDate : jobData["tentativeStartDate"] ?? "",
                stipend : jobData["stipend"] ?? "",
                stipendAmount : jobData["stipendAmount"] ?? "",
                numberOfOpenings : jobData["numberOfOpenings"] ?? "",
                perks : jobData["perks"] ?? [],
                createdBy : jobData["createdBy"] ?? "",
                createdAt : jobData["createdAt"] ?? "",
                userId : jobData["userId"] ?? "",
                jobDurVal : jobData["jobDurVal"] ?? "",
                stipendVal : jobData["stipendVal"] ?? "",
                tags : jobData["tags"] ?? [],
                applicationCount: jobData["applicationCount"] ?? 0,
                clicked: jobData["clicked"] ?? false,
                docId: jobData["docId"] ?? "",
                applicationsIDS: jobData["applicationsIDS"] ?? [],
                interests: jobData["interests"] ?? [],
                brandPfp: jobData["brandPfp"] ?? "",
                phoneNumber:jobData["phoneNumber"] ?? ""

            );
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



}