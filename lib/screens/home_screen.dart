import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Bottom bar butonları için ikon ve label listesi
  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Not'),
    BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Görev'),
    BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Seçili sekme: ${_items[_selectedIndex].label}',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70), // 40px yukarı kaydır
        child: FloatingActionButton(
          onPressed: () {
            print("Yeni not/görev ekle");
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}