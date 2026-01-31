import 'package:flutter/material.dart';
import 'package:taskvector/models/task.dart';
import 'package:taskvector/models/task_category.dart';
import 'package:taskvector/services/task_db.dart';
import 'package:uuid/uuid.dart';

import '../services/category_db.dart';

class AddTaskScreen  extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<TaskCategory> _categories = [];
  TaskCategory? _category;

  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.pending;
  DateTime? _dueDate;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
      status: _status,
    );

    await TaskDb.addTask(task);

    Navigator.pop(context, true);

  }

  @override
  void initState() {
    super.initState();
    _categories = CategoryDb.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Add Task'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    prefixIcon: Icon(Icons.task),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                ),

                SizedBox(height: 12,),

                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    initialValue: _category,
                    decoration: InputDecoration(
                      labelText: "Category",
                      prefixIcon: Icon(Icons.category),
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.name),
                      );
                    },).toList(),
                    onChanged: (value) {
                      setState(() => _category = value);
                    },
                  ),
                ),

                const SizedBox(height: 12,),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),

                const SizedBox(height: 12,),

                ListTile(
                  title: Text(_dueDate == null
                     ? 'Due Date'
                     : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
                  subtitle: const Text('Tap to change'),
                  leading: const Icon(Icons.calendar_today),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  tileColor: Colors.grey[100],
                  onTap: _pickDate,
                ),

                const SizedBox(height: 12,),

                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<TaskPriority>(
                    initialValue: _priority,
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    items: TaskPriority.values.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name.toUpperCase(),),),).toList(),
                    onChanged: (v) => setState(() => _priority = v!),
                  ),
                ),

                const SizedBox(height: 12,),

                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<TaskStatus>(
                      initialValue: _status,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      items: TaskStatus.values.map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name.toUpperCase()))).toList(),
                      onChanged: (v) => setState(() => _status = v!),
                  ),
                ),

                const SizedBox(height: 24,),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveTask,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}