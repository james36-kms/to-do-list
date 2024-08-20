import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:todo_list_app/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List tasksList = json.decode(tasksString);
      _tasks = tasksList.map((task) => Task.fromMap(task)).toList();
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task, int index) async {
    if (index >= 0) {
      _tasks[index] = task;
      await saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int index) async {
    if (index >= 0) {
      _tasks.removeAt(index);
      await saveTasks();
      notifyListeners();
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> tasksList =
        _tasks.map((task) => task.toMap()).toList();
    prefs.setString('tasks', json.encode(tasksList));
  }
}
