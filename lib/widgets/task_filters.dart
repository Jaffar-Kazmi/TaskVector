import 'package:flutter/material.dart';

class TaskFilters extends StatefulWidget {
  const TaskFilters({super.key});

  @override
  State<TaskFilters> createState() => _TaskFiltersState();
}

class _TaskFiltersState extends State<TaskFilters> {
  String selectedTimeFilter = "All Tasks";
  String selectedStatusFilter = "All Status";
  String selectedPriorityFilter = "All Priority";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterButton(
                context: context,
                selectedValue: selectedTimeFilter,
                onSelected: (value) {
                  setState(() {
                    selectedTimeFilter = value;
                  });
                  },
                items: [
                  "All Tasks",
                  "Due Today",
                  "Due Tomorrow",
                  "By Week",
                  "By Month",
                ],
              ),

              SizedBox(width: 8,),

              // Status Filter
              _buildFilterButton(
                context: context,
                selectedValue: selectedStatusFilter,
                onSelected: (value) {
                  setState(() {
                    selectedStatusFilter = value;
                  });
                  },
                items: [
                  "All Status",
                  "Completed",
                  "In Progress",
                  "Not Started",
                ],
              ),

              SizedBox(width: 8,),

              // Priority Filter
              _buildFilterButton(
                context: context,
                selectedValue: selectedPriorityFilter,
                onSelected: (value) {
                  setState(() {
                    selectedPriorityFilter = value;
                  });
                  },
                items: [
                  "All Priority",
                  "High",
                  "Medium",
                  "Low",
                ],
              ),

              SizedBox(width: 8,),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required String selectedValue,
    required Function(String) onSelected,
    required List<String> items,
  }) {
    return PopupMenuButton<String>(
      initialValue: selectedValue,
      onSelected: onSelected,
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem(
        value: item,
        child: Text(item),
      ))
          .toList(),
      borderRadius: BorderRadius.all(Radius.circular(12)),
      color: Theme.of(context).colorScheme.primary,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue,
              style: TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}