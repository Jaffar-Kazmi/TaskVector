import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taskvector/provider/theme_provider.dart';
import 'package:taskvector/provider/user_provider.dart';  // ← ADD THIS
import 'package:taskvector/screens/onboarding_screen.dart';
import 'package:taskvector/screens/home_screen.dart';
import 'package:taskvector/screens/splash_screen.dart';
import 'package:taskvector/services/user_db.dart';
import 'models/task.dart';
import 'models/task_category.dart';
import 'models/user.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskCategoryAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());

  await Hive.openBox<Task>('tasks');
  await Hive.openBox<TaskCategory>('categories');
  await Hive.openBox('settings');
  await Hive.openBox<User>('users');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(create: (context) => UserProvider()..loadUser()),
      ],
      child: TaskVectorApp(),
    ),
  );
}

class TaskVectorApp extends StatefulWidget {
  const TaskVectorApp({super.key});

  @override
  State<TaskVectorApp> createState() => _TaskVectorAppState();
}

class _TaskVectorAppState extends State<TaskVectorApp> {
  bool _isInitialized = false;

  void _onSplashComplete() {
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TaskVector',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) {
              if (!_isInitialized) {
                return SplashScreen(onInitializationComplete: _onSplashComplete);
              } else {
                final userDb = UserDb();
                return FutureBuilder<bool>(
                  future: userDb.init().then((_) => userDb.hasUser()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.data == true) {
                      return const HomeScreen();
                    }
                    return const OnboardingScreen();
                  },
                );
              }
            },
            '/home': (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}
