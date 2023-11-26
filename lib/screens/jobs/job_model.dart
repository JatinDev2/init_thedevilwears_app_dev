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
});

}