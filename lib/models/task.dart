enum TaskPriority { low, medium, high }
enum TaskStatus { pending, in_progress, done }

class Task {
  String id;
  String title;
  String? description;
  String? category;
  DateTime? dueDate;
  TaskPriority priority;
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