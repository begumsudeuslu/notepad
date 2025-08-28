import 'package:flutter/material.dart';
import 'note_screen.dart';
import 'tasks_screen.dart';
import 'account_screen.dart';
import 'package:notepad/widgets/task_widgets/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:notepad/controllers/note_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPressed() {
    if (_selectedIndex == 0) {
      final noteController = Provider.of<NoteController>(
        context,
        listen: false,
      );
      noteController.addNoteFromExternal();
    } else if (_selectedIndex == 1) {
      // Görev ekleme diyalogunu doğrudan burada çağırırız
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddTaskScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 194, 163, 222),
        unselectedItemColor: const Color.fromARGB(255, 106, 104, 104),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notlar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Görevler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Kullanıcılar',
          ),
        ],
      ),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: SizedBox(
                width: 55,
                height: 75,
                child: FloatingActionButton(
                  onPressed: _onAddPressed,
                  backgroundColor: const Color(0xFFC3A5DE),
                  elevation: 8,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, size: 30),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPage() {
    if (_selectedIndex == 0) {
      return const NoteScreen();
    } else if (_selectedIndex == 1) {
      return const TasksScreen();
    } else {
      return const AccountScreen();
    }
  }
}
