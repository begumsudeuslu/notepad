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
  late final TaskController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Provider.of<TaskController>(context, listen: false);
    _controller.refreshAllTasks();
  }

  // Hem görev ekleme hem de düzenleme için kullanılan metod.
  // Bu metot, AddTaskScreen'den dönülen değeri kontrol ederek listeyi yeniler.
  Future<void> _navigateAndRefresh({Task? taskToEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(taskToEdit: taskToEdit),
      ),
    );

    // Eğer AddTaskScreen'den true değeri dönerse (görev kaydedildi/güncellendi)
    // Listeyi yenile.
    if (result == true) {
      _controller.refreshAllTasks();
    }
  }

  // Ortak stilize butonu oluşturan yeni metot
  Widget _buildStyledFloatingActionButton({required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: SizedBox(
        width: 55,
        height: 75,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: const Color(0xFFC3A5DE),
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double expandedHeight = screenHeight * 0.6;

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
          SliverToBoxAdapter(child: SizedBox(height: 80.0)),
        ],
      ),
      // Butonun stilini de koruyarak _navigateAndRefresh metodunu kullanıyoruz.
      floatingActionButton: _buildStyledFloatingActionButton(
        onPressed: () async {
          await _navigateAndRefresh();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
