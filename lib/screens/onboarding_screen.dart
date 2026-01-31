import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';
import '../services/user_db.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _usernameController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    print('🔥 PICK IMAGE BUTTON PRESSED');

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      print('📸 Picked: $pickedFile');

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        print('✅ Image loaded!');
      }
    } catch (e) {
      print('💥 Error: $e');
    }
  }

  Future<void> _completeSetup() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final userDb = UserDb();
    final user = User(
      username: _usernameController.text.trim(),
      profileImagePath: _profileImage?.path,
    );

    await userDb.saveCurrentUser(user);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 62),
                const Text(
                  'Welcome to TaskVector!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Set up your profile to get started',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),
        
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.add_photo_alternate, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
        
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 32),
        
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _completeSetup,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Continue', style: TextStyle(fontSize: 18)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}