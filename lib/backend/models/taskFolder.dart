import 'dart:convert';
import 'package:deck/backend/models/newTask.dart';
import 'package:http/http.dart' as http;

import '../auth/auth_service.dart';

class TaskFolder {
  final String id;
  final String title;
  final String background;
  final DateTime timestamp;
  final bool isDeleted;
  final String? userId;
  final int totalTasks;
  final int completedTasksCount;

  final String deckTaskManagerAPIUrl =
      "https://deck-task-manager-api-taglvgaoma-uc.a.run.app";
  final String deckTaskManagerLocalAPIUrl =
      "http://10.0.2.2:5001/deck-f429c/us-central1/deck_task_manager_api";

  TaskFolder({
    required this.id,
    required this.title,
    required this.background,
    required this.timestamp,
    required this.isDeleted,
    this.userId,
    required this.totalTasks,
    required this.completedTasksCount,
  });

  /// Factory constructor to create a TaskFolder from JSON
  factory TaskFolder.fromJson(Map<String, dynamic> json) {
    return TaskFolder(
      id: json['id'] as String,
      title: json['title'] as String,
      background: json['background'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isDeleted: json['is_deleted'] as bool,
      userId: json['user_id'] as String?,
      totalTasks: json['totalTasks'] as int? ?? 0,
      completedTasksCount: json['completedTasksCount'] as int? ?? 0,
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
      'totalTasks': totalTasks,
      'completedTasksCount': completedTasksCount,
    };
  }
}
