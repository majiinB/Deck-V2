import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> getTasksOnSpecificDate() async {
    List<Task> list = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('tasks').where('user_id', isEqualTo: AuthService().getCurrentUser()?.uid).get();
      // Iterate through the query snapshot to extract document data
      for (var doc in querySnapshot.docs) {
        String uid = doc.id;
        String title = doc['title'];
        String description = doc['description'];
        String userId = doc['user_id'];
        bool isDone = doc['is_done'];
        DateTime setDate = doc['set_date'].toDate();
        DateTime endDate = doc['end_date'].toDate();
        bool isDeleted = doc['is_deleted'];
        DateTime doneDate = doc['done_date'].toDate();
        list.add(Task(uid, title, description, userId, isDone, setDate, endDate, isDeleted, doneDate));
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
        data['user_id'],
        data['is_done'],
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
      taskData['user_id'],
      taskData['is_done'],
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
      data['user_id'],
      data['is_done'],
      data['set_date'].toDate(),
      data['end_date'].toDate(),
      data['is_deleted'],
      data['done_date'].toDate(),
    );
  }

}