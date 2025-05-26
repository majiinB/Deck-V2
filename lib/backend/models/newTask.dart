class NewTask {
  final String taskId;
  final String taskFolderId;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? doneDate;

  NewTask({
    required this.taskId,
    required this.taskFolderId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.startDate,
    required this.endDate,
    this.doneDate,
  });

  factory NewTask.fromJson(Map<String, dynamic> json) {
    return NewTask(
      taskId: json["id"] as String,
      taskFolderId: json['task_folder_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      doneDate: json['done_date'] != null
          ? DateTime.parse(json['done_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'id' : taskId,
      'task_folder_id': taskFolderId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'start_date': startDate.toUtc().toIso8601String(),
      'end_date': endDate.toUtc().toIso8601String(),
    };
    if (doneDate != null) {
      m['done_date'] = doneDate!.toUtc().toIso8601String();
    }
    return m;
  }
}
