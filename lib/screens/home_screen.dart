import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskvector/provider/theme_provider.dart';
import 'package:taskvector/provider/user_provider.dart';
import 'package:taskvector/screens/add_task_screen.dart';
import 'package:taskvector/screens/profile_screen.dart';
import 'package:taskvector/widgets/categories_list.dart';
import 'package:taskvector/widgets/task_filters.dart';
import 'package:taskvector/widgets/tasks_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? _selectedCategoryId;
  String? _timeFilter = "All Tasks";
  String? _statusFilter = "All Status";
  String? _priorityFilter = "All Priority";

  bool _isSearching = false;
  bool _showProfile = false;

  final TextEditingController searchController = TextEditingController();
  late AnimationController _animationController;

  late Animation<Offset> _homeSlide;
  late Animation<Offset> _profileSlide;

  void _handleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        searchController.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _homeSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.35),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _profileSlide = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _openProfile() {
    setState(() {
      _showProfile = true;
    });
    _animationController.forward();
  }

  void _closeProfile() async {
    await _animationController.reverse();
    setState(() {
      _showProfile = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SlideTransition(
            position: _homeSlide,
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Scaffold(
                  appBar: AppBar(
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: GestureDetector(
                        onTap: _openProfile,
                        child: Hero(
                          tag: 'profile_hero',
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: userProvider.user?.profileImagePath != null
                                ? FileImage(File(userProvider.user!.profileImagePath!))
                                : null,
                            backgroundColor: Colors.grey[300],
                            child: userProvider.user?.profileImagePath == null
                                ? Icon(Icons.person, color: Colors.grey[600])
                                : null,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return IconButton(
                            icon: themeProvider.themeMode == ThemeMode.dark ? Icon(Icons.light_mode_rounded) : Icon(Icons.dark_mode_rounded),
                            onPressed: () => themeProvider.changeTheme(
                              themeProvider.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: IconButton(
                            onPressed: _handleSearch,
                            icon: Icon(_isSearching ? Icons.close : Icons.search)
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
                            child: Text('What\'s up, ${userProvider.user?.username.split(' ')[0]}', style: TextStyle(fontSize: 30),),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(12, 8, 0, 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CategoriesList(
                                    onSelectedCategory: (categoryId) {
                                      setState(() {
                                        _selectedCategoryId = categoryId;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(12, 20, 8, 8),
                            child: TaskFilters(
                              currentTimeFilter: _timeFilter,
                              currentStatusFilter: _statusFilter,
                              currentPriorityFilter: _priorityFilter,
                              onTimeFilterChanged: (value) => setState(() { _timeFilter = value; }),
                              onStatusFilterChanged: (value) => setState(() { _statusFilter = value; }),
                              onPriorityFilterChanged: (value) => setState(() { _priorityFilter = value; }),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(12, 8, 12, 8),
                                child: TasksList(
                                  searchQuery: searchController.text,
                                  categoryId: _selectedCategoryId,
                                  timeFilter: _timeFilter,
                                  statusFilter: _statusFilter,
                                  priorityFilter: _priorityFilter,
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
          ),
          if (_showProfile)
            SlideTransition(
              position: _profileSlide,
              child: ProfileScreen(
                onClose: _closeProfile,
              ),
            ),
        ],
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