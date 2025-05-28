

class Report {
  final String userId;
  final String title;
  final String type;
  final String details;
  final String status;
  final DateTime? submittedAt;
  final List<String>? screenshots;

  Report({
    required this.userId,
    required this.title,
    required this.type,
    required this.details,
    required this.status,
    this.submittedAt,
    this.screenshots,
  });

  /// Converts Report object to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'type': type,
      'details': details,
      'status': status,
      'submitted_at': submittedAt,
      'screenshots': screenshots,
    };
  }

  /// Function to send a report to the backend

}