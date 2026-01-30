import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskvector/provider/theme_provider.dart';
import 'package:taskvector/screens/add_task_screen.dart';
import 'package:taskvector/widgets/categories_list.dart';
import 'package:taskvector/widgets/task_filters.dart';
import 'package:taskvector/widgets/tasks_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String firstName = 'Jaffar';
  final String lastName = 'Raza';

  String? _selectedCategoryId;
  String? _timeFilter = "All Tasks";
  String? _statusFilter = "All Status";
  String? _priorityFilter = "All Priority";

  bool _isSearching = false;
  final TextEditingController searchController = TextEditingController();

  void _handleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? TextField(
          controller: searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search tasks',
            prefixIcon: Icon(Icons.search),
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() {}),
        ) : Text('TaskVector'),
        // leading: Padding(
        //   padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        //   child: IconButton(
        //       icon: Icon(Icons.account_circle_rounded, size: 25,),
        //       onPressed: () {},
        //   ),
        // ),
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
                child: Text('What\'s up, $firstName!', style: TextStyle(fontSize: 30),),
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