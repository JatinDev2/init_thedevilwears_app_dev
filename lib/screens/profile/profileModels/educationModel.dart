class EducationModel {
  final String timePeriod;
  final String description;
  final String location;
  final String instituteName;
  final String degreeName;

  const EducationModel({
    required this.timePeriod,
    required this.description,
    required this.location,
    required this.instituteName,
    required this.degreeName,
  });

  // Convert a EducationModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'timePeriod': timePeriod,
      'description': description,
      'location': location,
      'instituteName': instituteName,
      'degreeName': degreeName,
    };
  }

  // Create a EducationModel instance from a map
  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      timePeriod: map['timePeriod'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      instituteName: map['instituteName'] ?? '',
      degreeName: map['degreeName'] ?? '',
    );
  }
}
