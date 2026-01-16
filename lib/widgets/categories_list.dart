import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_category.dart';
import '../services/category_db.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ValueListenableBuilder<Box<TaskCategory>>(
          valueListenable: Hive.box<TaskCategory>('categories').listenable(),
          builder: (context, Box<TaskCategory> box, _) {
            final categories = box.values.toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Icon(Icons.add),
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18
                      ),
                      onPressed: () => _showAddCategoryDialog(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }

                final category = categories[index];
                final isSelected = category.id == selectedCategoryId;

                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category.name),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategoryId = selected ? category.id : null;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    side: BorderSide.none,
                  ),
                );
              },
            );
          }
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Add Category'),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(hintText: 'Enter category name'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')
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
                child: const Text('Add')
            )
          ],
        )
    );
  }
}