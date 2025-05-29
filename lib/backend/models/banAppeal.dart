class BanAppeal {
  final String? id;
  final String userId;
  final DateTime? appealedAt;
  final String title;
  final String details;
  final String status;

  BanAppeal({
    this.id,
    required this.userId,
    this.appealedAt,
    required this.title,
    required this.details,
    required this.status,
  });

  BanAppeal createBanAppeal({
    String? id,
    required String userId,
     DateTime? appealedAt,
    required String title,
    required String details,
    required String status,
  }) {
    return BanAppeal(
      userId: userId,
      appealedAt: appealedAt,
      title: title,
      details: details,
      status: status,
    );
  }

  /// Factory method to create a `BanAppeal` instance from a JSON map.
  factory BanAppeal.fromJson(Map<String, dynamic> json) {
    return BanAppeal(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      appealedAt: DateTime.parse(json['appealed_at'] as String), // Adjust parsing as needed
      title: json['title'] as String,
      details: json['details'] as String,
      status: json['status'] as String,
    );
  }

  /// Convert a `BanAppeal` instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'appealed_at': appealedAt?.toIso8601String(), // Ensure timestamp conversion
      'title': title,
      'details': details,
      'status': status,
    };
  }
}