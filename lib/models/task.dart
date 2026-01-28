import 'package:hive/hive.dart';
import 'package:taskvector/models/task_category.dart';


part 'task.g.dart';

@HiveType(typeId: 0)
enum TaskPriority {
  @HiveField(0)
  low, 
  @HiveField(1)
  medium,
  @HiveField(2)
  high 
}

@HiveType(typeId: 1)
enum TaskStatus { 
  @HiveField(0)
  pending, 
  @HiveField(1)
  ongoing,
  @HiveField(2)
  done
}

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  TaskCategory? category;
  @HiveField(4)
  DateTime? dueDate;
  @HiveField(5)
  TaskPriority priority;
  @HiveField(6)
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.dueDate,
    required this.priority,
    required this.status,
  });
}