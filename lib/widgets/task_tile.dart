import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../screens/edit_task_screen.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final Box<Task> tasksBox;
  final int index;
  final bool isExpanded;
  final Function(int) onExpand;

  const TaskTile({
    super.key,
    required this.task,
    required this.tasksBox,
    required this.index,
    required this.isExpanded,
    required this.onExpand,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void didUpdateWidget(TaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded && !_animationController.isCompleted) {
      _animationController.forward();
    } else if (!widget.isExpanded && !_animationController.isDismissed) {
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    if (widget.isExpanded) _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleStatus() {
    setState(() {
      widget.task.status = widget.task.status == TaskStatus.done
          ? TaskStatus.pending
          : TaskStatus.done;
      widget.task.save();
    });
  }

  void _toggleExpand() {
    widget.onExpand(widget.index);
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade300;
      case TaskPriority.medium:
        return Colors.blueGrey;
      case TaskPriority.low:
        return Colors.green.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  blurRadius: 2,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(20),
                  leading: IconButton(
                    onPressed: _toggleStatus,
                    icon: Icon(
                      widget.task.status == TaskStatus.done
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: widget.task.status == TaskStatus.done ? Colors.green : Colors.grey,
                    ),
                  ),
                  title: Text(
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      decoration: widget.task.status == TaskStatus.done
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    widget.task.dueDate != null
                        ? 'Due: ${widget.task.dueDate!.day}-${widget.task.dueDate!.month}-${widget.task.dueDate!.year}'
                        : 'No due date',
                  ),
                  trailing: IconButton(onPressed: _toggleExpand, icon: Icon(Icons.expand_circle_down_outlined)),
                  onTap: _toggleExpand,
                ),

                SizeTransition(
                  sizeFactor: _animation,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        Text(
                          widget.task.description ?? 'No description',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  if (widget.task.category != null)
                                    Chip(
                                      label: Text(widget.task.category!.name),
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      labelStyle: TextStyle(color: Colors.white),
                                      side: BorderSide.none,
                                    ),
                                  SizedBox(width: 6,),
                                  Chip(
                                      label: Text(widget.task.priority.name.toUpperCase()),
                                      labelStyle: TextStyle(color: Colors.white),
                                      side: BorderSide.none,
                                      backgroundColor: _priorityColor(widget.task.priority)
                                  ),
                                ],
                              ),
                            ),),

                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditTaskScreen(task: widget.task)),
                              ),
                              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary,),
                            ),
                            IconButton(
                              onPressed: () => _showDeleteDialog(context),
                              icon: Icon(Icons.delete, color: Colors.red[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              final taskKey = widget.task.key;
              final deletedTask = widget.task.copy();

              widget.tasksBox.delete(taskKey);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Task deleted'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
                action: SnackBarAction(label: 'UNDO', onPressed: () async {
                  await widget.tasksBox.put(taskKey, deletedTask);
                }),
                persist: false,
              ),);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
