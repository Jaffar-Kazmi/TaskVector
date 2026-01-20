import 'package:flutter/material.dart';

import '../models/task.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  bool isCompleted = false;
  final tasks = <Task>[
    Task(
      id: '1',
      title: 'Finish FYP proposal',
      description: 'Write problem statement, scope, and initial system architecture.',
      dueDate: DateTime(2026, 1, 22),
      priority: TaskPriority.high,
      status: TaskStatus.pending,
    ),
    Task(
      id: '2',
      title: 'DSA practice',
      description: 'Solve 3 graph problems on LeetCode, focus on BFS/DFS templates.',
      dueDate: DateTime(2026, 1, 20),
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return ExpansionTile(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  task.status = task.status == TaskStatus.done ? TaskStatus.pending : TaskStatus.done;
                });
              },
              icon: Icon( task.status == TaskStatus.done
                  ? Icons.check_circle
                  : Icons.circle_outlined,
                color: task.status == TaskStatus.done ? Colors.green : Colors.grey,
              ),
            ),
            title: task.status == TaskStatus.done ? Text(task.title, style: TextStyle(decoration: TextDecoration.lineThrough),) : Text(task.title, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(
              'Due: ${task.dueDate?.day}-${task.dueDate?.month}-${task.dueDate?.year}'
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.remove_red_eye_outlined),
            ),
            childrenPadding: EdgeInsetsGeometry.fromLTRB(26, 12, 20, 12),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(task.description ?? 'No description'),
              ),
              Row(
                children: [
                  Chip(
                    label: Text(task.priority.name.toUpperCase(), style: TextStyle(color: Colors.black),),
                    backgroundColor: task.priority == TaskPriority.high
                        ? Colors.red[200]
                        : Colors.blue[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    shadowColor: Colors.grey,
                    side: BorderSide.none,
                  ),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.edit),
                    label: Text('Edit'),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete, color: Colors.red[600],),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }
}