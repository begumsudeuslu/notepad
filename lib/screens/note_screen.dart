import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  int _selectedIndex = 0;
  bool _selectionMode = false; // Seçim modu aktif mi?
  final List<String> _notes = [];
  final Set<int> _selectedNotes = {}; // Seçilen notların index'leri

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
      _notes.add("Yeni not #${_notes.length + 1}");
    });
  }

  void _onLongPress(int index) {
    setState(() {
      _selectionMode = true;
      _selectedNotes.add(index);
    });
  }

  void _onSelectToggle(int index) {
    setState(() {
      if (_selectedNotes.contains(index)) {
        _selectedNotes.remove(index);
      } else {
        _selectedNotes.add(index);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedNotes.clear();
    });
  }

  void _deleteSelectedNotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notları Sil"),
        content: Text("Seçilen notları silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Hayır
            child: Text("Hayır"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final sortedIndexes = _selectedNotes.toList()..sort((a, b) => b.compareTo(a));
for (var index in sortedIndexes) {
  _notes.removeAt(index);
}
                _selectedNotes.clear();
                _selectionMode = false;
              });
              Navigator.of(context).pop(); // Diyaloğu kapat
            },
            child: Text("Evet", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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

    return GestureDetector(
      onTap: () {
        if (_selectionMode) {
          _exitSelectionMode(); // Seçim modunu kapat
        }
      },
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final selected = _selectedNotes.contains(index);

          return GestureDetector(
            onLongPress: () => _onLongPress(index),
            child: Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  _notes[index],
                  style: TextStyle(fontSize: 18),
                ),
                trailing: _selectionMode
                    ? Checkbox(
                        value: selected,
                        onChanged: (_) => _onSelectToggle(index),
                        shape: CircleBorder(),
                        activeColor: Colors.blue,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          if (_selectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedNotes,
              tooltip: 'Seçilenleri Sil',
            )
        ],
        leading: _selectionMode
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: _exitSelectionMode,
              )
            : null,
      ),
      body: _buildNotesList(),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      floatingActionButton: !_selectionMode
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: FloatingActionButton(
                onPressed: _addNote,
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
