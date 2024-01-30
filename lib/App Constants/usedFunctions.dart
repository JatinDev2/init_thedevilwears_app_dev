import '../Models/ProfileModels/studentModel.dart';
import '../Models/formModels/educationModel.dart';
import '../Models/formModels/workModel.dart';

class DisplayFunctions{

  //---------------------------Function to concatenate Job Profiles and return a string------------------------------
  String concatToDisplay(List<String>items, int numberToShow){
    String formattedJobType = items.join(" • ");

    List<String> jobTypeValues = formattedJobType.split(" • ");

    if (jobTypeValues.length > numberToShow) {
      formattedJobType = jobTypeValues.take(numberToShow).join(" • ");
      int remainingCount = jobTypeValues.length - numberToShow;
      formattedJobType += " ...+$remainingCount more";
    }
    return formattedJobType;
  }

  //---------------------------Function to concatenate Companies and return a string------------------------------
  String formatCompanyNames(List<WorkModel>? workExperience, {int maxDisplay = 1}) {
    if (workExperience == null || workExperience.isEmpty) {
      return 'No Companies';
    }
    String allCompanies = workExperience.map((e) => e.companyName).join(', ');
    List<String> companyList = allCompanies.split(', ');
    if (companyList.length <= maxDisplay) {
      return allCompanies;
    } else {
      String displayedCompanies = companyList.take(maxDisplay).join(', ');
      int remainingCount = companyList.length - maxDisplay;
      return '$displayedCompanies, ...+${remainingCount}';
    }
  }

  //---------------------------Function to concatenate get Latest Education String---------------------------------
  String getLatestInstituteName(List<EducationModel>? educationList) {
    if (educationList == null || educationList.isEmpty) {
      return 'No Education Info';
    }
    educationList.sort((a, b) => b.timePeriod.compareTo(a.timePeriod));
    return educationList.first.instituteName;
  }

  List<StudentProfile> sortStudentProfiles(
      List<StudentProfile> profiles,
      List<String> currentUserJobProfiles,
      List<String> currentUserInterests
      ) {
    profiles.sort((a, b) {
      int scoreA = calculateProfileMatchScore(a, currentUserJobProfiles, currentUserInterests);
      int scoreB = calculateProfileMatchScore(b, currentUserJobProfiles, currentUserInterests);
      return scoreB.compareTo(scoreA);
    });
    return profiles;
  }

  //---------------------------Ranking Functions-----------------------------------------------------------
  int calculateProfileMatchScore(StudentProfile profile, List<String> jobProfiles, List<String> interests) {
    bool matchesJobProfile = jobProfiles.any((jobProfile) => profile.userDescription?.contains(jobProfile) ?? false);
    int matchingInterestsCount = profile.interestedOpportunities?.where((interest) => interests.contains(interest)).length ?? 0;
    if (matchesJobProfile && matchingInterestsCount > 0) {
      return 1000 + matchingInterestsCount;
    } else if (matchesJobProfile) {
      return 500;
    } else if (matchingInterestsCount > 0) {
      return 100 + matchingInterestsCount;
    } else {
      return 0;
    }
  }


}