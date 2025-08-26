import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notepad/screens/task/controllers/task_controller.dart';

class SearchAndFilters extends StatelessWidget {
  final TaskController controller;

  const SearchAndFilters({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: "Görevlerde ara",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        controller.clearSearch();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            onChanged: (v) {
              controller.setSearchQuery(v);
            },
          ),
        ),
        // Tarih seçici ve tamamlanan switch burada
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Switch(
                      value: controller.showCompleted,
                      onChanged: (val) => controller.toggleShowCompleted(val),
                    ),
                    const Text('Tamamlananları göster'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
