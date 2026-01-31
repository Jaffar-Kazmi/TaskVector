import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taskvector/provider/theme_provider.dart';
import 'package:taskvector/theme/app_theme.dart';
import '../models/task_category.dart';
import '../services/category_db.dart';

class CategoriesList extends StatefulWidget {
  final Function(String?) onSelectedCategory;

  const CategoriesList({super.key, required this.onSelectedCategory});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.themeMode == ThemeMode.dark;

        return SizedBox(
          height: 44,
          child: ValueListenableBuilder<Box<TaskCategory>>(
            valueListenable: Hive.box<TaskCategory>('categories').listenable(),
            builder: (context, Box<TaskCategory> box, _) {
              final categories = box.values.toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All', overflow: TextOverflow.ellipsis,),
                        selected: selectedCategoryId == null,
                        onSelected: (_) {
                          setState(() => selectedCategoryId = null);
                          widget.onSelectedCategory(null);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: isDark
                            ? AppColors.darkPrimary.withOpacity(0.3)
                            : AppColors.lightPrimary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 16,
                        ),
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        elevation: selectedCategoryId == null ? 2 : 0,
                        side: BorderSide.none,
                      ),
                    ),

                    ...categories.map((category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category.name, overflow: TextOverflow.ellipsis,),
                        labelStyle: TextStyle(
                          color: isDark ? AppColors.lightBackground : Colors.white,
                          fontSize: 16,
                        ),
                        selected: category.id == selectedCategoryId,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategoryId = selected ? category.id : null;
                          });
                          widget.onSelectedCategory(selected ? category.id : null);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        elevation: category.id == selectedCategoryId ? 4 : 1,
                        side: BorderSide.none,
                      ),
                    )),

                    // Add button
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        labelStyle: const TextStyle(fontSize: 18),
                        onPressed: () => _showAddCategoryDialog(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: categoryController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter category name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final categoryName = categoryController.text.trim();
              if (categoryName.isEmpty) return;

              final taskCategory = TaskCategory(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: categoryName,
              );

              await CategoryDb.add(taskCategory);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
