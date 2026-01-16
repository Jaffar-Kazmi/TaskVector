import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task_category.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TaskCategoryAdapter());
  await Hive.openBox<TaskCategory>('categories');

  runApp(TaskVectorApp());
}

class TaskVectorApp extends StatefulWidget{
  const TaskVectorApp({super.key});

  @override
  State<TaskVectorApp> createState() => _TaskVectorAppState();
}

class _TaskVectorAppState extends State<TaskVectorApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(){
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final VoidCallback onToggleTheme = _toggleTheme;
    return MaterialApp(
      title: 'TaskVector',
      home: HomeScreen(onToggleTheme: onToggleTheme),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}