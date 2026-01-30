import 'package:flutter/material.dart';

class TaskFilters extends StatefulWidget {
  final Function(String?) onTimeFilterChanged;
  final Function(String?) onStatusFilterChanged;
  final Function(String?) onPriorityFilterChanged;

  final String? currentTimeFilter;
  final String? currentStatusFilter;
  final String? currentPriorityFilter;

  const TaskFilters({
    super.key,
    required this.onTimeFilterChanged,
    required this.onStatusFilterChanged,
    required this.onPriorityFilterChanged,
    this.currentTimeFilter,
    this.currentStatusFilter,
    this.currentPriorityFilter
  });

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
                selectedValue: widget.currentTimeFilter ?? "All Tasks",
                onSelected: widget.onTimeFilterChanged,
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
                selectedValue: widget.currentStatusFilter ?? "All Status",
                onSelected: widget.onStatusFilterChanged,
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
                selectedValue: widget.currentPriorityFilter ?? "All Priority",
                onSelected: widget.onPriorityFilterChanged,
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