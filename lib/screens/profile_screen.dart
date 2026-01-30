import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onClose;

  const ProfileScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.transparent),
          ),
        ),

        GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < 0) {
              onClose();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 60),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),

            ),
            child: Column(
              mainAxisSize: .min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 36),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_double_arrow_up,
                        color: Colors.grey,
                        size: 28,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                      ),
                      onPressed: onClose,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile content here
                      const SizedBox(height: 24),
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=512',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Jaffar Raza',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'CS Student | FYP Warrior',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Stats row
                      Row(
                        children: [
                          Expanded(child: _StatCard(
                            title: 'Total',
                            value: '127',
                            icon: Icons.task_alt,
                          )),
                          const SizedBox(width: 16),
                          Expanded(child: _StatCard(
                            title: 'Done',
                            value: '89',
                            icon: Icons.check_circle,
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _StatCard(
                            title: 'Overdue',
                            value: '12',
                            icon: Icons.warning,
                          )),
                          const SizedBox(width: 16),
                          Expanded(child: _StatCard(
                            title: 'Due Soon',
                            value: '26',
                            icon: Icons.schedule,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _StatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
