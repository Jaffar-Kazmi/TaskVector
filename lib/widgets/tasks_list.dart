import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Task> tasksBox = Hive.box<Task>('tasks');

    return ValueListenableBuilder<Box<Task>>(
      valueListenable: tasksBox.listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return const Center(child: Text('No tasks yet'));
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
                'Due: ${task.dueDate?.day}-${task.dueDate?.month}-${task.dueDate?.year}',
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye_outlined),
              ),
              childrenPadding:
              const EdgeInsets.fromLTRB(26, 12, 20, 12),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(task.description ?? 'No description'),
                ),
                Row(
                  children: [
                    Chip(
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
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // open edit screen and after save, update box
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    IconButton(
                      onPressed: () {
                        box.deleteAt(index);
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
