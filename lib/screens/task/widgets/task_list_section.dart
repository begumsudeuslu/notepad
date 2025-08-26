import 'package:flutter/material.dart';
import 'package:notepad/screens/task/controllers/task_controller.dart';
import 'task_list_view.dart';
import 'task_dialogs.dart';

class TaskListSection extends StatelessWidget {
  final TaskController controller;

  const TaskListSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final filtered = controller.filteredTasks;

    if (filtered.isEmpty) {
      return const Center(
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
      );
    }

    return TaskListView(
      filteredTasks: filtered,
      onToggleTask: (index) => controller.toggleTask(index),
      onEditTask: (index) {
        final task = controller.filteredTasks[index];
        showEditTaskDialog(context, task, () async {
          final updated = task.copy(title: task.title); // örnek
          controller.editTask(index, updated);
        });
      },
      onDeleteTask: (index) => controller.deleteTask(index),
    );
  }
}
