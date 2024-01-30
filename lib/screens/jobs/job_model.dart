class jobModel{
  final String jobType;
  final String jobProfile;
  final String responsibilities;
  final String jobDuration;
  final String jobDurExact;
  final String workMode;
  final String officeLoc;
  final String tentativeStartDate;
  final String stipend;
  final String stipendAmount;
  final String numberOfOpenings;
  final List perks;
  final String createdBy;
  final String createdAt;
  final String userId;
  final String jobDurVal;
  final String stipendVal;
  final List tags;
  final int applicationCount;
  final bool clicked;
  final String docId;
  final List applicationsIDS;
  final List interests;
  final String brandPfp;
  final String phoneNumber;

  jobModel({
    required this.jobType,
    required this.jobProfile,
    required this.responsibilities,
    required this.jobDuration,
    required this.jobDurExact,
    required this.workMode,
    required this.officeLoc,
    required this.tentativeStartDate,
    required this.stipend,
    required this.stipendAmount,
    required this.numberOfOpenings,
    required this.perks,
    required this.createdAt,
    required this.createdBy,
    required this.userId,
    required this.jobDurVal,
    required this.stipendVal,
    required this.tags,
    required this.applicationCount,
    required this.clicked,
    required this.docId,
    required this.applicationsIDS,
    required this.interests,
    required this.brandPfp,
    required this.phoneNumber,
});

  factory jobModel.fromMap(Map<String, dynamic> data) {
    return jobModel(
      jobType: data['jobType'] ?? '',
      jobProfile: data['jobProfile'] ?? '',
      responsibilities: data['responsibilities'] ?? '',
      jobDuration: data['jobDuration'] ?? '',
      jobDurExact: data['jobDurExact'] ?? '',
      workMode: data['workMode'] ?? '',
      officeLoc: data['officeLoc'] ?? '',
      tentativeStartDate: data['tentativeStartDate'] ?? '',
      stipend: data['stipend'] ?? '',
      stipendAmount: data['stipendAmount'] ?? '',
      numberOfOpenings: data['numberOfOpenings'] ?? '',
      perks: data['perks'] != null ? List.from(data['perks']) : [],
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? '',
      userId: data['userId'] ?? '',
      jobDurVal: data['jobDurVal'] ?? '',
      stipendVal: data['stipendVal'] ?? '',
      tags: data['tags'] != null ? List.from(data['tags']) : [],
      applicationCount: data['applicationCount'] ?? 0,
      clicked: data['clicked'] ?? false,
      docId: data['docId'] ?? '',
      applicationsIDS: data['applicationsIDS'] != null ? List.from(data['applicationsIDS']) : [],
      interests: data['interests'] != null ? List.from(data['interests']) : [],
      brandPfp: data['brandPfp'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }


}