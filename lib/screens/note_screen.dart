import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  int _selectedIndex = 0;

  // Not listesi (şimdilik string olarak içerik)
  final List<String> _notes = [];

  // Bottom bar butonları
  final List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Not'),
    BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Görev'),
    BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addNote() {
    setState(() {
      // Geçici not içeriği
      _notes.add("Yeni not #${_notes.length + 1}");
    });
  }

  Widget _buildNotesList() {
    if (_notes.isEmpty) {
      return Center(
        child: Text(
          'Henüz not yok. ➕ simgesine tıklayarak not ekleyebilirsin.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _notes[index],
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _buildNotesList(),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: _addNote,
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
