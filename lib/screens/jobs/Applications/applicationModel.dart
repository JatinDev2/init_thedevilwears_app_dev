class applicationModel{
  final String additionalInfo;
  final String appliedBy;
  final String createdBy;
  final String education;
  final String jobProfile;
  final String statusOfApplication;
  final String userId;
  final String workedAt;

  applicationModel({
   required this.education,
   required this.additionalInfo,
   required this.userId,
   required this.jobProfile,
   required this.createdBy,
   required this.appliedBy,
   required this.statusOfApplication,
   required this.workedAt,
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
    );
  }
}