class BanAppeal {
  final String? id;
  final String userId;
  final DateTime? appealedAt;
  final String title;
  final String details;
  final String status;
  final String banId;
  BanAppeal({
    this.id,
    required this.userId,
    this.appealedAt,
    required this.title,
    required this.details,
    required this.status,
    required this.banId,
  });

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