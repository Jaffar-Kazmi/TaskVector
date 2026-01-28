import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskvector/screens/edit_task_screen.dart';
import '../models/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Task> tasks = Hive.box<Task>('tasks');

    Future<void> _handleDelete({
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
        if (box.isEmpty) {
          return const Center(child: Text('No tasks yet', style: TextStyle(fontSize: 16),));
        }

        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final task = box.getAt(index);

            if (task == null) return const SizedBox.shrink();

            return ExpansionTile(
              leading: IconButton(
                onPressed: () {
                  task.status = task.status == TaskStatus.done
                        ? TaskStatus.pending
                        : TaskStatus.done;
                  task.save();
                },
                icon: Icon(
                  task.status == TaskStatus.done
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: task.status == TaskStatus.done
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
              title: task.status == TaskStatus.done
                  ? Text(
                task.title,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              )
                  : Text(
                task.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                task.dueDate != null
                ? 'Due: ${task.dueDate?.day}-${task.dueDate?.month}-${task.dueDate?.year}'
                    : ' ',
              ),
              trailing: Chip(
                label: Text(
                  task.priority.name.toUpperCase(),
                  style: const TextStyle(color: Colors.black),
                ),
                backgroundColor:
                task.priority == TaskPriority.high
                    ? Colors.red[200]
                    : Colors.blue[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                shadowColor: Colors.grey,
                side: BorderSide.none,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(26, 12, 20, 12),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(task.description ?? 'No description'),
                ),
                Row(
                  children: [
                    Chip(
                      label: Text(task.category?.name ?? 'No Category', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,),),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      side: BorderSide.none,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
                        );
                          
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    IconButton(
                      onPressed: () {
                        _handleDelete(context: context, tasks: tasks, task: task);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
