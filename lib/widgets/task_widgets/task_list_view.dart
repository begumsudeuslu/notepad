import 'package:flutter/material.dart';
import 'package:notepad/models/task.dart';
import 'task_card.dart';

class TaskListView extends StatelessWidget {
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
    if (filteredTasks.isEmpty) {
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

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final task = filteredTasks[index];
        return Dismissible(
          key: Key('${task.id ?? '${task.title}-$index'}'),
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.centerRight,
            color: Colors.red.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onDeleteTask(index);
            }
          },
          child: TaskCard(
            task: task,
            onToggle: () => onToggleTask(index),
            onEdit: () => onEditTask(index),
          ),
        );
      }, childCount: filteredTasks.length),
    );
  }
}
