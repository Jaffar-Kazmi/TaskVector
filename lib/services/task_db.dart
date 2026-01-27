import 'package:hive/hive.dart';

import '../models/task.dart';

class TaskDb {
  static final Box<Task> _box = Hive.box('tasks');

  static Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  static List<Task> getAllTasks() {
    return _box.values.toList();
  }

  static Future<void> deleteTask(String id) {
    return _box.delete(id);
  }
}