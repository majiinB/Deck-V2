class Ban {
  final String id;
  final String userId;
  final DateTime? bannedAt;
  final String reason;
  final bool isAppealed;
  final String rejectReason;

  Ban({
    required this.id,
    required this.userId,
    this.bannedAt,
    required this.reason,
    required this.isAppealed,
    required this.rejectReason,
  });

  /// Factory method to create a `Ban` instance from a JSON map.
  factory Ban.fromJson(Map<String, dynamic> json) {
    return Ban(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bannedAt: json['banned_at'], // Ensure timestamp conversion if needed
      reason: json['reason'] as String,
      isAppealed: json['is_appealed'] as bool,
      rejectReason: json['reject_reason'] as String,
    );
  }

  /// Convert a `Ban` instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'banned_at': bannedAt?.toIso8601String(), // Ensure timestamp conversion
      'reason': reason,
      'is_appealed': isAppealed,
      'reject_reason': rejectReason,
    };
  }
}