import 'package:flutter/material.dart';
import 'package:taskvector/screens/add_task_screen.dart';
import 'package:taskvector/widgets/categories_list.dart';
import 'package:taskvector/widgets/task_filters.dart';
import 'package:taskvector/widgets/tasks_list.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String firstName = 'Jaffar';
  final String lastName = 'Raza';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSearching = false;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: IconButton(
              icon: Icon(Icons.account_circle_rounded),
              onPressed: () {},
          ),
        ),
        actions: [
          IconButton(
            icon: isDark? Icon(Icons.light_mode_rounded) : Icon(Icons.dark_mode_rounded),
            onPressed: widget.onToggleTheme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
            child: IconButton(
                onPressed: () {},
                icon: Icon(isSearching ? Icons.close : Icons.search)
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(12, 8, 0, 8),
                child: Text('What\'s up, $firstName!', style: TextStyle(fontSize: 30),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 8, 0, 8),
                child: const CategoriesList(),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 20, 0, 8),
                child: const TaskFilters(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(12, 8, 12, 8),
                  child: const TasksList(),
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final added = Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen()));

          if (added == true) {
            setState(() {

            });
          }
        },
        label: Text('Add Task', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,)),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary,),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
      ),
    );
  }
}