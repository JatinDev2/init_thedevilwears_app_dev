import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/jobs/Applications/applicationModel.dart';
import '../screens/jobs/job_model.dart';
import '../screens/profile/profileModels/educationModel.dart';
import '../screens/profile/profileModels/projectModel.dart';
import '../screens/profile/profileModels/workModel.dart';

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
  Future<String?> fetchLatestEducation() async {
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
  Future<void> updateApplicationStatus(String jobListingId,
      String applicationId, String status) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference applicationDoc = firestore
        .collection('jobListing')
        .doc(jobListingId)
        .collection('Applications')
        .doc(applicationId);

    await applicationDoc.update({'statusOfApplication': status})
        .catchError((error) => print('Error updating status: $error'));
  }


  Stream<List<jobModel>> streamJobListingsForStudent(String studentId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Stream of the student profile document
    Stream<DocumentSnapshot> studentProfileStream = firestore
        .collection('studentProfiles')
        .doc(studentId)
        .snapshots();

    return studentProfileStream.asyncMap((studentProfileSnapshot) async {
      // Check if the document exists and has data
      if (!studentProfileSnapshot.exists ||
          studentProfileSnapshot.data() == null) {
        return [
        ]; // Return an empty list if the document doesn't exist or has no data
      }

      var studentData = studentProfileSnapshot.data() as Map<String, dynamic>;

      // Check if the 'applicationsApplied' field exists
      if (!studentData.containsKey('applicationsApplied')) {
        return [
        ]; // Return an empty list if the 'applicationsApplied' field is not found
      }

      // Extract the 'applicationsApplied' map
      Map<String, dynamic> applicationsAppliedDynamic = studentData['applicationsApplied'];

      // Map<String, String> applicationsApplied = applicationsAppliedDynamic.map((key, value) => MapEntry(key, value.toString()));


      // Fetch job listings based on application IDs
      List<jobModel> jobListings = [];
      for (String jobId in applicationsAppliedDynamic.keys) {
        print("Hello check");
        print(jobId);
        DocumentSnapshot data = await firestore
            .collection('jobListing')
            .doc(jobId)
            .get();
        if (data.exists) {
          print("Hello check");
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
          );
          jobListings.add(job);
        }
      }

      return jobListings;
    });
  }
}