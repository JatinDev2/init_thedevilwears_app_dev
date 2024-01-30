class RequestModel {
  final String userId;
  final String status;
  final String requesterName;
  final String jobProfile;

  RequestModel({
    required this.userId,
    required this.status,
    required this.requesterName,
    required this.jobProfile,
  });

  // Convert a RequestModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'status': status,
      'requesterName': requesterName,
      'jobProfile':jobProfile,
    };
  }

  // Create a RequestModel instance from a map
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      userId: map['userId'] ?? '',
      status: map['status'] ?? '',
      requesterName: map['requesterName'] ?? '',
        jobProfile:map['jobProfile'] ?? ''
    );
  }
}
