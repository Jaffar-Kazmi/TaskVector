import 'package:hive/hive.dart';
import '../models/task_category.dart';

class CategoryDb {
  static Box<TaskCategory> get _box => Hive.box<TaskCategory>('categories');

  static List<TaskCategory> getAll() => _box.values.cast<TaskCategory>().toList();

  static Future<void> add(TaskCategory category) async {
    await _box.put(category.id, category);
  }

  static Future<void> delete(String id) async {
    await _box.delete(id);
  }
}