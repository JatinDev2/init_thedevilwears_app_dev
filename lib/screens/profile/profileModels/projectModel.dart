class ProjectModel {
  String projectHeading;
  String projectType;
  String projectLink;
  String description;

  ProjectModel({
    required this.projectHeading,
    required this.projectType,
    required this.projectLink,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'projectHeading': projectHeading,
      'projectType': projectType,
      'projectLink': projectLink,
      'description': description,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      projectHeading: map['projectHeading'] ?? '',
      projectType: map['projectType'] ?? '',
      projectLink: map['projectLink'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
