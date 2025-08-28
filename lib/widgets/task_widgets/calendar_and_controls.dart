import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notepad/controllers/task_controller.dart';
import 'package:notepad/models/task.dart';

class CalendarAndControls extends StatelessWidget {
  const CalendarAndControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TaskController>(context);

    // Takvimde kırmızı noktaların görünmesi için gerekli fonksiyon
    List<Task> getTasksForDay(DateTime day) {
      return controller.allTasks.where((task) {
        final taskDay = DateTime(
          task.date.year,
          task.date.month,
          task.date.day,
        );
        final compareDay = DateTime(day.year, day.month, day.day);
        return taskDay == compareDay;
      }).toList();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // Arama çubuğu
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
              focusedDay: controller.selectedDate ?? DateTime.now(),
              selectedDayPredicate: (day) =>
                  controller.selectedDate != null &&
                  isSameDay(controller.selectedDate!, day),
              onDaySelected: (selectedDay, focusedDay) {
                if (controller.selectedDate != null &&
                    isSameDay(selectedDay, controller.selectedDate!)) {
                  controller.clearSelectedDate();
                } else {
                  controller.setSelectedDate(selectedDay);
                }
              },
              // Bir güne ait tek nokta göstermek için markerBuilder kullanıyoruz
              eventLoader: getTasksForDay,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, tasks) {
                  // O gün için görev varsa sadece bir nokta döndür
                  if (tasks.isNotEmpty) {
                    return Positioned(
                      bottom: 6,
                      child: Container(
                        height: 7.0,
                        width: 7.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              // Sizin kodunuzdaki takvim stilini buraya ekledim
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 166, 128, 199),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.blueGrey),
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
                      value: controller.showCompletedOnly,
                      onChanged: (value) =>
                          controller.toggleShowCompleted(value),
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
