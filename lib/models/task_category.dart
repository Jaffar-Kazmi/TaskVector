import 'package:hive/hive.dart';

part 'task_category.g.dart';

@HiveType(typeId: 3)
class TaskCategory extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  TaskCategory({required this.id, required this.name});
}