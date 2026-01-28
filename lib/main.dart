import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskvector/models/task.dart';
import 'package:taskvector/provider/theme_provider.dart';
import 'models/task_category.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskCategoryAdapter());

  await Hive.openBox<Task>('tasks');
  await Hive.openBox<TaskCategory>('categories');
  await Hive.openBox('settings');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()..loadTheme(),
      child: TaskVectorApp()
    )
  );
}

class TaskVectorApp extends StatelessWidget{
  const TaskVectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'TaskVector',
          home: HomeScreen(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}