import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  // Yeni: Not ekleme callback'i (şu anlık kullanılmıyor ama durabilir)
  final VoidCallback? onAddNote;

  const NoteScreen({Key? key, this.onAddNote}) : super(key: key);

  @override
  // _NoteScreenState'i NoteScreenState olarak değiştiriyoruz.
  // Artık dışarıdan erişilebilir olacak.
  NoteScreenState createState() => NoteScreenState();
}

// _NoteScreenState'i NoteScreenState olarak değiştiriyoruz.
class NoteScreenState extends State<NoteScreen> {
  bool _selectionMode = false;
  final List<String> _notes = [];
  final Set<int> _selectedNotes = {};

  // Public metot: HomeScreen'den çağrılacak.
  void addNoteFromExternal() {
    setState(() {
      _notes.add("Yeni not #${_notes.length + 1}");
    });
  }

  void _onLongPress(int index) {
    setState(() {
      if (!_selectionMode) {
        _selectionMode = true;
      }
      _onSelectToggle(index);
    });
  }

  void _onSelectToggle(int index) {
    setState(() {
      if (_selectedNotes.contains(index)) {
        _selectedNotes.remove(index);
      } else {
        _selectedNotes.add(index);
      }
      if (_selectedNotes.isEmpty && _selectionMode) {
        _selectionMode = false;
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
        title: const Text("Notları Sil"),
        content: const Text("Seçilen notları silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Hayır"),
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
              Navigator.of(context).pop();
            },
            child: const Text("Evet", style: TextStyle(color: Colors.red)),
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
          style: const TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_selectionMode) {
          _exitSelectionMode();
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final selected = _selectedNotes.contains(index);

          return GestureDetector(
            onLongPress: () => _onLongPress(index),
            onTap: () {
              if (_selectionMode) {
                _onSelectToggle(index);
              }
            },
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: selected ? Colors.blue.withOpacity(0.2) : null,
              child: ListTile(
                title: Text(
                  _notes[index],
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: _selectionMode
                    ? Checkbox(
                        value: selected,
                        onChanged: (_) => _onSelectToggle(index),
                        shape: const CircleBorder(),
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
      appBar: _selectionMode
          ? AppBar(
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _exitSelectionMode,
              ),
              title: Text('${_selectedNotes.length} Seçildi'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelectedNotes,
                  tooltip: 'Seçilenleri Sil',
                )
              ],
            )
          : null,
      body: _buildNotesList(),
    );
  }
}