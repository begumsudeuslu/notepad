// task_list_section.dart
import 'package:flutter/material.dart';
import 'package:notepad/controllers/task_controller.dart';
import 'package:notepad/widgets/task_widgets/add_task_screen.dart';
import 'task_list_view.dart';
import 'task_dialogs.dart';

class TaskListSection extends StatelessWidget {
  final TaskController controller;

  const TaskListSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final filtered = controller.filteredTasks;

    if (filtered.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Hiç sonuç yok.\nYeni görev eklemek için + simgesine tıkla.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return TaskListView(
      filteredTasks: filtered,
      // Düzeltildi: index ile Task nesnesine eriş ve controller'a gönder
      onToggleTask: (index) => controller.toggleTask(filtered[index]),
      onEditTask: (index) async {
        final task = controller.filteredTasks[index];
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTaskScreen(taskToEdit: task),
          ),
        );
        if (result == true) {
          controller.refreshAllTasks();
        }
      },
      // Düzeltildi: index ile Task nesnesinin id'sine eriş ve controller'a gönder
      onDeleteTask: (index) => controller.deleteTask(filtered[index].id!),
    );
  }
}
