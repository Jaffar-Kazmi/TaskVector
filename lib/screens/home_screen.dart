import 'package:flutter/material.dart';
import 'package:taskvector/widgets/categories_list.dart';
import 'package:taskvector/widgets/task_filters.dart';

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
              icon: Icon(Icons.menu),
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
              Container(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}