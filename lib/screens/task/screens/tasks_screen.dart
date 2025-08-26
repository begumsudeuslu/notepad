import 'package:flutter/material.dart';
import 'package:notepad/screens/task/controllers/task_controller.dart';
import '../widgets/search_and_filters.dart';
import '../widgets/task_list_section.dart';
import '../widgets/fab_add_task.dart';
import 'package:notepad/screens/task/widgets/add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

// Public State sınıfı
class TasksScreenState extends State<TasksScreen> {
  final TaskController _controller = TaskController();
  void addTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (result == true) {
      _controller.refreshAllTasks(); // DB’den verileri tekrar çek
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.refreshAllTasks(); // DB’den verileri çek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
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
      body: Column(
        children: [
          SearchAndFilters(controller: _controller),
          Expanded(child: TaskListSection(controller: _controller)),
        ],
      ),
      floatingActionButton: FabAddTask(controller: _controller),
    );
  }
}
