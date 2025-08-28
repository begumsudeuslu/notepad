import 'package:flutter/material.dart';
import 'package:notepad/models/task.dart';
import 'package:notepad/widgets/task_widgets/task_card.dart';

class TaskListView extends StatelessWidget {
  // filteredTasks parametresini ekle
  final List<Task> filteredTasks;
  final Function(int) onToggleTask;
  final Function(int) onEditTask;
  final Function(int) onDeleteTask;

  const TaskListView({
    super.key,
    required this.filteredTasks,
    required this.onToggleTask,
    required this.onEditTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          task: task,
          onToggle: () => onToggleTask(index),
          onEdit: () => onEditTask(index),
          // Buraya on Delete parametresini ekliyoruz
          onDelete: () => onDeleteTask(index),
        );
      }, childCount: filteredTasks.length),
    );
  }
}
