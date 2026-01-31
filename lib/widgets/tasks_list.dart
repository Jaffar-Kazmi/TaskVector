import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskvector/screens/edit_task_screen.dart';
import 'package:taskvector/widgets/task_tile.dart';
import '../models/task.dart';

class TasksList extends StatefulWidget {
  final String searchQuery;
  final String? categoryId;
  final String? timeFilter;
  final String? statusFilter;
  final String? priorityFilter;


  const TasksList({
    super.key,
    this.searchQuery = '',
    this.categoryId,
    this.timeFilter,
    this.statusFilter,
    this.priorityFilter,
  });

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  int? _expandedIndex;

  bool _matchesTimeFilter(Task task) {
    if(widget.timeFilter == "All Tasks" || widget.timeFilter == null) return true;

    final now = DateTime.now();
    final dueDate = task.dueDate;
    if (dueDate == null) return false;

    switch (widget.timeFilter) {
      case "Due Today":
        return dueDate.isToday(now);
      case "Due Tomorrow":
        return dueDate.isTomorrow(now);
      case "By Week":
        return dueDate.isSameWeek(now);
      case "By Month":
        return dueDate.isSameMonth(now);
      default:
        return true;
    }
  }

  bool _matchesStatusFilter(Task task) {
    if(widget.statusFilter == "All Status" || widget.statusFilter == null) return true;

    switch (widget.statusFilter) {
      case "Completed":
        return task.status == TaskStatus.done;
      case "In Progress":
        return task.status == TaskStatus.ongoing;
      case "Not Started":
        return task.status == TaskStatus.pending;
      default:
        return true;
    }
  }

  bool _matchesPriorityFilter(Task task) {
    if(widget.priorityFilter == "All Priority" || widget.priorityFilter == null) return true;

    return task.priority.name.toUpperCase() == widget.priorityFilter?.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Box<Task> tasks = Hive.box<Task>('tasks');

    Future<void> handleDelete({
      required BuildContext context,
      required Box<Task> tasks,
      required Task task,
    }) async {
      final String? taskKey = task.key;
      final Task deletedTask = task;

      final confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmDelete != true || taskKey == null) return;

      await tasks.delete(taskKey);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [Text('Task deleted')]),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () async {
                await tasks.put(taskKey, deletedTask);
              },
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            persist: false,
          ),
        );
      }
    }

    return ValueListenableBuilder<Box<Task>>(
      valueListenable: tasks.listenable(),
      builder: (context, box, _) {
        final filteredTasks = box.values.where((task) {
          final matchesSearch = task.title.toLowerCase().contains(
              widget.searchQuery.toLowerCase()) ||
              (task.description ?? '').toLowerCase().contains(
                  widget.searchQuery.toLowerCase());

          final matchesCategory = widget.categoryId == null ||
              task.category?.id == widget.categoryId;

          final matchesTime = _matchesTimeFilter(task);

          final matchesStatus = _matchesStatusFilter(task);

          final matchesPriority = _matchesPriorityFilter(task);

          return matchesCategory && matchesSearch && matchesTime && matchesStatus && matchesPriority;
        }).toList();

        if (box.isEmpty) {
          return const Center(child: Text('No tasks yet', style: TextStyle(fontSize: 16),));
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            return TaskTile(
              task: filteredTasks[index],
              tasksBox: box,
              index: index,
              isExpanded: _expandedIndex == index,
              onExpand: (expandedIndex) {
                setState(() {
                  _expandedIndex = expandedIndex == _expandedIndex ? null : expandedIndex;
                });
              },
            );
          },
        );
      },
    );
  }
}
