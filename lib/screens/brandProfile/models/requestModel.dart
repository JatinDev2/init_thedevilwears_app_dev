class RequestModel {
  final String userId;
  final String status;
  final String requesterName;

  RequestModel({
    required this.userId,
    required this.status,
    required this.requesterName,
  });

  // Convert a RequestModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'status': status,
      'requesterName': requesterName,
    };
  }

  // Create a RequestModel instance from a map
  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      userId: map['userId'] ?? '',
      status: map['status'] ?? '',
      requesterName: map['requesterName'] ?? '',
    );
  }
}
