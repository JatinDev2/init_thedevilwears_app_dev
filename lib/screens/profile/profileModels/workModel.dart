class WorkModel {
  final String roleInCompany;
  final String workType;
  final String companyName;
  final String timePeriod;
  final String description;
  final String projectLink;
  final String location;
  final String status;

  const WorkModel({
    required this.roleInCompany,
    required this.workType,
    required this.companyName,
    required this.timePeriod,
    required this.description,
    required this.projectLink,
    required this.location,
    required this.status,
  });

  // Convert a WorkModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'roleInCompany': roleInCompany,
      'workType': workType,
      'companyName': companyName,
      'timePeriod': timePeriod,
      'description': description,
      'projectLink': projectLink,
      'location': location,
      'status':status,
    };
  }

  // Create a WorkModel instance from a map
  factory WorkModel.fromMap(Map<String, dynamic> map) {
    return WorkModel(
      roleInCompany: map['roleInCompany'] ?? '',
      workType: map['workType'] ?? '',
      companyName: map['companyName'] ?? '',
      timePeriod: map['timePeriod'] ?? '',
      description: map['description'] ?? '',
      projectLink: map['projectLink'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}
