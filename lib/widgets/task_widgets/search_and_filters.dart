import 'package:flutter/material.dart';
import 'package:notepad/controllers/task_controller.dart';
import 'package:notepad/models/task.dart';
import 'package:notepad/widgets/task_widgets/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:notepad/widgets/task_widgets/calendar_and_controls.dart';
import 'package:notepad/widgets/task_widgets/task_list_section.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late TaskController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Provider.of<TaskController>(context, listen: false);
    _controller.refreshAllTasks();
  }

  Future<void> _navigateAndRefresh({Task? taskToEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(taskToEdit: taskToEdit),
      ),
    );

    if (result == true) {
      _controller.refreshAllTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 50.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 166, 128, 199),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            centerTitle: true,
            title: const Text(
              'Yapılacaklar Listesi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CalendarAndControls(),
                  const SizedBox(height: 8),
                  Consumer<TaskController>(
                    builder: (context, controller, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Switch(
                                  value: controller.showCompletedOnly,
                                  onChanged: (val) {
                                    controller.toggleShowCompleted(val);
                                  },
                                  // Switch'in açıkkenki rengini belirliyoruz
                                  activeColor: Colors.purple,
                                  // Switch'in kapalıykenki topuz rengini belirliyoruz
                                  inactiveThumbColor: Colors.grey,
                                  // Switch'in kapalıykenki yol rengini belirliyoruz
                                  inactiveTrackColor: Colors.grey.shade300,
                                ),
                                const Text('Tamamlananları göster'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Consumer<TaskController>(
            builder: (context, controller, child) {
              return TaskListSection(
                onEditTask: (index) async {
                  final task = controller.filteredTasks[index];
                  await _navigateAndRefresh(taskToEdit: task);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
