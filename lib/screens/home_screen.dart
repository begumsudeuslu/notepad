import 'package:flutter/material.dart';
import 'note_screen.dart';
import 'task_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Alt menüde gösterilecek sayfalar
  final List<Widget> _pages = [NoteScreen(), TasksScreen(), AccountScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex], // Seçilen ekranı göster
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
      // FAB sadece Notlar veya Görevler ekranında görünsün
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? FloatingActionButton(
              onPressed: () {
                // Fonksiyon
              },
              backgroundColor: Colors.blueAccent,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
