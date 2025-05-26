class TaskFolder {
  final String title;
  final String background;
  final DateTime timestamp;
  final bool isDeleted;

  TaskFolder({
    required this.title,
    required this.background,
    required this.timestamp,
    required this.isDeleted,
  });

  /// Factory constructor to create a TaskFolder from JSON
  factory TaskFolder.fromJson(Map<String, dynamic> json) {
    return TaskFolder(
      title: json['title'] as String,
      background: json['background'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isDeleted: json['is_deleted'] as bool,
    );
  }

  /// Converts this TaskFolder to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'background': background,
      'timestamp': timestamp.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }
}
