class TaskFolder {
  final String id;
  final String title;
  final String background;
  final DateTime timestamp;
  final bool isDeleted;
  final String? userId;  // Optional because sometimes it might not be used on client side

  TaskFolder({
    required this.id,
    required this.title,
    required this.background,
    required this.timestamp,
    required this.isDeleted,
    this.userId,
  });

  /// Factory constructor to create a TaskFolder from JSON
  factory TaskFolder.fromJson(Map<String, dynamic> json) {
    return TaskFolder(
      id: json['id'] as String,
      title: json['title'] as String,
      background: json['background'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isDeleted: json['is_deleted'] as bool,
      userId: json['user_id'] as String?,  // nullable
    );
  }

  /// Converts this TaskFolder to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'background': background,
      'timestamp': timestamp.toIso8601String(),
      'is_deleted': isDeleted,
      if (userId != null) 'user_id': userId,
    };
  }
}
