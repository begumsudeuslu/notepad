import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notepad/models/task.dart';
import 'package:notepad/databases/database.dart';

class CalendarAndControls extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final DateTime selectedDate;
  final bool isDateSelected;
  final List<Task> allTasks;
  final bool showCompleted;
  final String sortBy;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<bool> onShowCompletedChanged;
  final ValueChanged<String?> onSortByChanged;

  const CalendarAndControls({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.selectedDate,
    required this.isDateSelected,
    required this.allTasks,
    required this.showCompleted,
    required this.sortBy,
    required this.onSearchChanged,
    required this.onDaySelected,
    required this.onShowCompletedChanged,
    required this.onSortByChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Ara...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) =>
                  isDateSelected && isSameDay(selectedDate, day),
              onDaySelected: (sDay, fDay) => onDaySelected(sDay),
              eventLoader: (day) {
                final hasTasks = allTasks.any(
                  (task) => isSameDay(task.date, day),
                );
                return hasTasks ? [true] : [];
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.blueGrey),
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(color: Colors.black),
                outsideTextStyle: const TextStyle(color: Colors.grey),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Switch(
                      value: showCompleted,
                      onChanged: onShowCompletedChanged,
                    ),
                    const Text('Tamamlananları göster'),
                  ],
                ),
              ),
              DropdownButton<String>(
                value: sortBy,
                items: const [
                  DropdownMenuItem(
                    value: 'created',
                    child: Text('Tarihe göre'),
                  ),
                  DropdownMenuItem(
                    value: 'alphabetical',
                    child: Text('Alfabetik'),
                  ),
                ],
                onChanged: onSortByChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
