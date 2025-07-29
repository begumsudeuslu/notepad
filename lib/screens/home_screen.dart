import 'package:flutter/material.dart';
import 'note_screen.dart';
import 'task_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() { 
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Sayfaları GlobalKey ile kontrol edeceğiz
  final GlobalKey<NoteScreenState> _noteKey = GlobalKey();
  final GlobalKey<TasksScreenState> _taskKey = GlobalKey();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      NoteScreen(key: _noteKey),
      TasksScreen(key: _taskKey),
      const AccountScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPressed() {
    if (_selectedIndex == 0) {
      _noteKey.currentState?.addNoteFromExternal();
    } else if (_selectedIndex == 1) {
      _taskKey.currentState?.addTask();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton(
                onPressed: _onAddPressed,
                backgroundColor: Colors.blueAccent,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.add, size: 30),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
