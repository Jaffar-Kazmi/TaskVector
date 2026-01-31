import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../provider/theme_provider.dart';
import '../services/user_db.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onClose;

  const ProfileScreen({super.key, required this.onClose});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await UserDb().getCurrentUser();
    setState(() {
      _user = user;
    });
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

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
            if (details.delta.dy < 0) {
              widget.onClose();
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
              mainAxisSize: MainAxisSize.min,
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
                      onPressed: widget.onClose,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _user!.profileImagePath != null
                            ? FileImage(File(_user!.profileImagePath!))
                            : null,
                        child: _user!.profileImagePath == null
                            ? Icon(Icons.person, size: 60)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _user!.username,
                        style: const TextStyle(
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

class _ProfileUpdateSection extends StatefulWidget {
  const _ProfileUpdateSection();

  @override
  State<_ProfileUpdateSection> createState() => _ProfileUpdateSectionState();
}

class _ProfileUpdateSectionState extends State<_ProfileUpdateSection> {
  File? _newImage;
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userDb = UserDb();
    final user = userDb.currentUser;
    if (user != null) {
      _usernameController.text = user.username;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _newImage = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    final userDb = UserDb();
    await userDb.updateUser(
      username: _usernameController.text.trim(),
      profileImagePath: _newImage?.path,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
      setState(() => _newImage = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: _newImage != null
                ? FileImage(_newImage!)
                : null,
            child: _newImage == null
                ? const Icon(Icons.camera_alt, size: 40)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveProfile,
          child: const Text('Update Profile'),
        ),
      ],
    );
  }
}