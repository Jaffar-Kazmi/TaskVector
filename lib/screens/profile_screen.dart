import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:taskvector/provider/user_provider.dart';
import 'package:taskvector/widgets/stats_card.dart';

import '../models/task.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onClose;

  const ProfileScreen({super.key, required this.onClose});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, int> _stats = {
    'total': 0,
    'done': 0,
    'overdue': 0,
    'dueSoon': 0,
  };

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  Future<void> _calculateStats() async {
    final tasksBox = Hive.box<Task>('tasks');
    final allTasks = tasksBox.values.toList();

    final now = DateTime.now();
    final dueSoon = now.add(const Duration(days: 2));

    setState(() {
      _stats = {
        'total': allTasks.length,
        'done': allTasks.where((t) => t.status == TaskStatus.done).length,
        'overdue': allTasks
            .where((t) =>
        t.dueDate != null &&
            t.dueDate!.isBefore(now) &&
            t.status != TaskStatus.done)
            .length,
        'dueSoon': allTasks
            .where((t) =>
        t.dueDate != null &&
            t.dueDate!.isAfter(now) &&
            t.dueDate!.isBefore(dueSoon) &&
            t.status != TaskStatus.done)
            .length,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onClose,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.transparent),
          ),
        ),

        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null &&
                details.primaryDelta! < -10) {
              widget.onClose();
            }
          },
          child: Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.primary,
                child: SafeArea(
                  bottom: false,
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, _) {
                      if (userProvider.isLoading ||
                          userProvider.user == null) {
                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final user = userProvider.user!;

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: widget.onClose,
                                icon: Icon(
                                  Icons.keyboard_double_arrow_up,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 30,
                                ),
                              ),

                              const SizedBox(height: 24),

                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                user.profileImagePath != null
                                    ? FileImage(
                                    File(user.profileImagePath!))
                                    : null,
                                child: user.profileImagePath == null
                                    ? const Icon(Icons.person, size: 60)
                                    : null,
                              ),

                              const SizedBox(height: 16),

                              Text(
                                user.username,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color:
                                  theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'Momentum looks good on you.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 32),

                              Row(
                                children: [
                                  Expanded(
                                    child: StatsCard(
                                      title: 'Total',
                                      value: _stats['total']!,
                                      icon: Icons.task_alt,
                                      iconColor:
                                      theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: StatsCard(
                                      title: 'Done',
                                      value: _stats['done']!,
                                      icon: Icons.check_circle,
                                      iconColor: Colors.green,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: StatsCard(
                                      title: 'Overdue',
                                      value: _stats['overdue']!,
                                      icon: Icons.warning,
                                      iconColor: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: StatsCard(
                                      title: 'Due Soon',
                                      value: _stats['dueSoon']!,
                                      icon: Icons.schedule,
                                      iconColor: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
