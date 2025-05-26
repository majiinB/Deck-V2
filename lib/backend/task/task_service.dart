import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';
import '../models/TaskFolder.dart';
import '../models/task.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String deckTaskManagerAPIUrl = "https://deck-task-manager-api-taglvgaoma-uc.a.run.app";
  final String deckTaskManagerLocalAPIUrl = "http://10.0.2.2:5001/deck-f429c/us-central1/deck_task_manager_api";

  Future<List<Task>> getTasksOnSpecificDate() async {
    List<Task> list = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('tasks').where('user_id', isEqualTo: AuthService().getCurrentUser()?.uid).get();
      // Iterate through the query snapshot to extract document data
      for (var doc in querySnapshot.docs) {
        String uid = doc.id;
        String title = doc['title'];
        String description = doc['description'];
        String priority = doc['priority'];
        String userId = doc['user_id'];
        bool isDone = doc['is_done'];
        bool isActive = doc['is_active'];
        DateTime setDate = doc['set_date'].toDate();
        DateTime endDate = doc['end_date'].toDate();
        bool isDeleted = doc['is_deleted'];
        DateTime doneDate = doc['done_date'].toDate();
        list.add(Task(uid, title, description, priority, userId, isDone, isActive, setDate, endDate, isDeleted, doneDate));
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

  Future<void> updateTaskFromLoadedTasks(List<Task> list, Task task) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('tasks').doc(task.uid).get();
      if (!snapshot.exists) { return; }
      var data = snapshot.data() as Map<String, dynamic>;
      Task loadedTask = Task(
        task.uid,
        data['title'],
        data['description'],
        data['priority'],
        data['user_id'],
        data['is_done'],
        data['is_active'],
        data['set_date'].toDate(),
        data['end_date'].toDate(),
        data['is_deleted'],
        data['done_date'],
      );
      print(list.length);
        for (int i = 0; i < list.length; i++) {
          if (list[i].uid == task.uid) {
            list[i] = loadedTask;
            break;
          }
        }
    } catch (e){
      print(e);
    }
  }

  Future<void> addTaskFromLoadedTasks(List<Task> list, Map<String, dynamic> taskData) async {
    final db = FirebaseFirestore.instance;
    final doc = await db.collection('tasks').add(taskData);

    Task task = Task(
      doc.id,
      taskData['title'],
      taskData['description'],
      taskData['priority'],
      taskData['user_id'],
      taskData['is_done'],
      taskData['is_active'],
      taskData['set_date'],
      taskData['end_date'],
      taskData['is_deleted'],
      taskData['done_date'],
    );
    list.add(task);
  }

  Future<Task> getTaskById(String id) async {
    final db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection('tasks').doc(id).get();
    var data = snapshot.data() as Map<String, dynamic>;
    return Task(
      id,
      data['title'],
      data['description'],
      data['priority'],
      data['user_id'],
      data['is_done'],
      data['is_active'],
      data['set_date'].toDate(),
      data['end_date'].toDate(),
      data['is_deleted'],
      data['done_date'].toDate(),
    );
  }

  Future<TaskFolder> createTaskFolder({
    required String title,
    required String background,
    required DateTime timeStamp,
  }) async {
    final token = await AuthService().getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final uri = Uri.parse('$deckTaskManagerLocalAPIUrl/v1/task/create-task-folder');

    final body = {
      "taskFolderDetails": {
        "title": title,
        "background": background,
        "timestamp": timeStamp.toUtc().toIso8601String(),
        "is_deleted": false
      }
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final bodyText = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : 'No response body';
      throw Exception(
          'Failed to create task folder (${response.statusCode}): $bodyText');
    }

    final Map<String, dynamic> jsonData =
    jsonDecode(response.body) as Map<String, dynamic>;

    if (jsonData['success'] != true) {
      throw Exception('Task folder creation failed: ${jsonData['message']}');
    }

    final Map<String, dynamic> newFolderJson = jsonData['data']['new_task_folder'];

    return TaskFolder.fromJson(newFolderJson);
  }

  Future<List<TaskFolder>> getTaskFolders() async {
    final token = await AuthService().getIdToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final uri = Uri.parse('$deckTaskManagerLocalAPIUrl/v1/task/get-task-folders');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      final bodyText = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : 'No response body';
      throw Exception(
          'Failed to fetch task folders (${response.statusCode}): $bodyText');
    }

    final Map<String, dynamic> jsonData =
    jsonDecode(response.body) as Map<String, dynamic>;

    if (jsonData['success'] != true) {
      throw Exception('Failed to retrieve task folders: ${jsonData['message']}');
    }

    final List<dynamic> foldersJson = jsonData['data'];

    final List<TaskFolder> taskFolders = foldersJson
        .map((folderJson) => TaskFolder.fromJson(folderJson))
        .toList();

    return taskFolders;
  }

}