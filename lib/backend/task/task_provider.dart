import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deck/backend/models/task.dart';
import 'package:deck/backend/task/task_service.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> list = [];

  List<Task> get getList => list;
  set setList(List<Task> list) {
    this.list = list;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    list = await TaskService().getTasksOnSpecificDate();
    orderListByEarliestDeadline();
    removeDeletedTasks();
    notifyListeners();
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    await TaskService().addTaskFromLoadedTasks(list, taskData);
    notifyListeners();
  }

  Future<void> editTask(Task task, Map<String, dynamic> data) async {
    final db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(task.uid).update(data);
    await TaskService().updateTaskFromLoadedTasks(list, task);
    notifyListeners();
  }

  Future<void> setTaskDone(Task task) async {
    final db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(task.uid).update({
      'is_done': true,
      'done_date': DateTime.now(),
    });
    await TaskService().updateTaskFromLoadedTasks(list, task);
    notifyListeners();
  }

  Future<void> setTaskUndone(Task task) async {
    final db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(task.uid).update({
      'is_done': false,
      'done_date': DateTime.now(),
    });
    await TaskService().updateTaskFromLoadedTasks(list, task);
    notifyListeners();
  }

  void orderListByEarliestDeadline(){
    list.sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  void removeDeletedTasks(){
    list.removeWhere((task) => task.isDeleted);
    notifyListeners();
  }

  Future<void> deleteTask(String id) async{
    final db = FirebaseFirestore.instance;
    await db.collection('tasks').doc(id).update({
      'is_deleted': true,
    });
    await loadTasks();
  }

  bool checkIfDeadlineIsToday() {
    if(list.isEmpty) return false;
    return list.any((element) => DateTime(element.deadline.month, element.deadline.day, 0, 0, 0).isAtSameMomentAs(DateTime(DateTime.now().month, DateTime.now().day, 0, 0, 0)) && !element.isDone) ? true : false;
  }

  DateTime findNearestDeadline(){
    DateTime now = DateTime.now();
    List<Task> fake = list;
    fake.sort((a, b) => a.deadline.compareTo(b.deadline));

    DateTime result = fake.firstWhere((task) => !task.isDone && task.deadline.isAfter(now), orElse: () => Task('','','','',false,DateTime.now(),DateTime.now(),false,DateTime.now())).deadline;
    return result;
  }
}


