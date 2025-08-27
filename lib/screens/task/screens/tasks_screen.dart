// tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:notepad/screens/task/controllers/task_controller.dart';
import 'package:provider/provider.dart';
import 'package:notepad/screens/task/widgets/calendar_and_controls.dart';
import 'package:notepad/screens/task/widgets/task_list_section.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final controller = TaskController();
        controller.refreshAllTasks();
        return controller;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Yapılacaklar Listesi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 166, 128, 199),
          centerTitle: true,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        body: Consumer<TaskController>(
          builder: (context, controller, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: CalendarAndControls()),
                // TaskListSection widget'ına controller'ı sağlıyoruz
                TaskListSection(controller: controller),
              ],
            );
          },
        ),
      ),
    );
  }
}
