class applicationModel{
  final String additionalInfo;
  final String appliedBy;
  final String createdBy;
  final String education;
  final String jobProfile;
  final String statusOfApplication;
  final String userId;
  final String workedAt;
  final String userPfp;
  final String userPhoneNumber;
  final String userGmail;

  applicationModel({
   required this.education,
   required this.additionalInfo,
   required this.userId,
   required this.jobProfile,
   required this.createdBy,
   required this.appliedBy,
   required this.statusOfApplication,
   required this.workedAt,
    required this.userPfp,
    required this.userGmail,
    required this.userPhoneNumber,
});

  factory applicationModel.fromMap(Map<String, dynamic> map) {
    return applicationModel(
      additionalInfo: map['additionalInfo'] ?? '',
      appliedBy: map['appliedBy'] ?? '',
      createdBy: map['createdBy'] ?? '',
      education: map['education'] ?? '',
      jobProfile: map['jobProfile'] ?? '',
      statusOfApplication: map['statusOfApplication'] ?? '',
      userId: map['userId'] ?? '',
      workedAt: map['workedAt'] ?? '',
      userPfp: map['userPfp'] ?? '',
      userGmail: map['userGmail'] ?? '',
      userPhoneNumber: map['userPhoneNumber'] ?? ''
    );
  }
}