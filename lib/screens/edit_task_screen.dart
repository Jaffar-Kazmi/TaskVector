import 'package:flutter/material.dart';
import 'package:taskvector/models/task.dart';
import 'package:taskvector/models/task_category.dart';
import 'package:taskvector/services/category_db.dart';
import '../services/task_db.dart';  // If needed for consistency

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  List<TaskCategory> _categories = [];
  TaskCategory? _category;

  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.pending;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');

    _priority = widget.task.priority;
    _status = widget.task.status;
    _dueDate = widget.task.dueDate;

    _categories = CategoryDb.getAll();

    // Match existing category
    _category = _categories.firstWhere(
          (cat) => cat.name.toLowerCase() == widget.task.category?.name.toLowerCase(),
      orElse: () => _categories.first,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _dueDate ?? DateTime.now(),
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    widget.task.title = _titleController.text.trim();
    widget.task.description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();
    widget.task.category = _category;
    widget.task.dueDate = _dueDate;
    widget.task.priority = _priority;
    widget.task.status = _status;

    await widget.task.save();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task updated successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),

      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Edit Task')),
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
                      ? 'No due date'
                      : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  subtitle: const Text('Tap to change', style: TextStyle(color: Colors.white70),),
                  leading: const Icon(Icons.calendar_today, color: Colors.white70,),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70,),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: Theme.of(context).colorScheme.primary,
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
