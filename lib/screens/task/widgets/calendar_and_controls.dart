// calendar_and_controls.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notepad/screens/task/controllers/task_controller.dart';

class CalendarAndControls extends StatelessWidget {
  const CalendarAndControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TaskController>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: "Görevlerde ara",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: controller.clearSearch,
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
            onChanged: controller.setSearchQuery,
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: controller.selectedDate,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDate, day) &&
                  controller.isDateSelected,
              onDaySelected: (selectedDay, focusedDay) {
                if (controller.isDateSelected &&
                    isSameDay(selectedDay, controller.selectedDate)) {
                  controller.clearSelectedDate();
                } else {
                  controller.setSelectedDate(selectedDay);
                }
              },
              eventLoader: (day) =>
                  controller.getTasksForDay(day).isNotEmpty ? [true] : [],
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 166, 128, 199),
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
                      value: controller.showCompleted,
                      onChanged: controller.toggleShowCompleted,
                    ),
                    const Text('Tamamlananları göster'),
                  ],
                ),
              ),
              DropdownButton<String>(
                value: controller.sortBy,
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
                onChanged: (v) {
                  if (v != null) {
                    controller.setSortBy(v);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
