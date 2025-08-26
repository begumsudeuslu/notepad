import 'package:flutter/material.dart';
import 'package:notepad/screens/task/controllers/task_controller.dart';
import 'package:notepad/screens/task/widgets/add_task_screen.dart';

class FabAddTask extends StatelessWidget {
  final TaskController controller;

  const FabAddTask({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTaskScreen()),
        );
        if (result == true) {
          controller.refreshAllTasks(); // Controller içindeki listeyi güncelle
        }
      },
      child: const Icon(Icons.add),
    );
  }
}
