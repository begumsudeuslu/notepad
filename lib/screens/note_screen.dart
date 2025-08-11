import 'package:flutter/material.dart';
import 'package:notepad/databases/database.dart';
import '../models/note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteScreen extends StatefulWidget {
  final VoidCallback? onAddNote;
  const NoteScreen({super.key, this.onAddNote});

  @override
  NoteScreenState createState() {
    return NoteScreenState();
  }
}

class NoteScreenState extends State<NoteScreen> {
  List<Note> _notes = [];
  bool _isLoading = false;
  int? _editingNoteId;
  final TextEditingController _editingTitleController = TextEditingController();
  final TextEditingController _editingContentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  void dispose() {
    _editingTitleController.dispose();
    _editingContentController.dispose();
    super.dispose();
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });
    final notes = await NotePadDatabase.instance.readAllNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  void addNoteFromExternal() async {
    final newNote = Note(
      title: 'Yeni Not ${_notes.length + 1}',
      content: 'Bu notun içeriği..',
      createdAt: DateTime.now(),
    );
    await NotePadDatabase.instance.create(newNote);
    _refreshNotes();
  }

  void _saveEditedNote() async {
    if (_editingNoteId != null) {
      final noteToUpdate = _notes.firstWhere((note) => note.id == _editingNoteId);
      final updatedNote = noteToUpdate.copy(
        title: _editingTitleController.text,
        content: _editingContentController.text,
      );
      await NotePadDatabase.instance.update(updatedNote);
      setState(() {
        _editingNoteId = null;
        _editingContentController.clear();
        _editingTitleController.clear();
      });
      _refreshNotes();
    }
  }

  void _startEditing(Note note) {
    setState(() {
      if (_editingNoteId != null) {
        _saveEditedNote();
      }
      _editingNoteId = note.id;
      _editingTitleController.text = note.title;
      _editingContentController.text = note.content;
    });
  }

  // Hata veren kısmı düzelterek notu silen fonksiyon
  void _deleteNote(int id, int index) async {
    final deletedNote = _notes[index];
    setState(() {
      _notes.removeAt(index);
    });

    // Kullanıcının notu geri alıp almadığını kontrol etmek için bir bayrak
    bool isUndo = false;

    final snackBar = SnackBar(
      content: Text('${deletedNote.title} adlı not silindi.'),
      action: SnackBarAction(
        label: 'Geri Al',
        onPressed: () {
          // 'Geri Al' butonuna basıldıysa bayrağı true yap
          isUndo = true;
          // Notu listeye geri ekle
          setState(() {
            _notes.insert(index, deletedNote);
          });
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((reason) async {
      // SnackBar kapandığında, eğer 'Geri Al' butonuna basılmadıysa notu veritabanından kalıcı olarak sil
      if (!isUndo) {
        await NotePadDatabase.instance.delete(id);
      }
    });
  }

  Widget _buildEmptyNotesMessage() {
    return const Center(
      child: Text(
        'Henüz not yok. ➕ simgesine tıklayarak not ekleyebilirsin.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, bool isEditing) {
  if (isEditing) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      color: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildEditingNoteView(),
      ),
    );
  }

  return Card(
    elevation: 3,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Slidable(
      key: ValueKey(note.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _startEditing(note),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Düzenle',
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Notu Sil"),
                    content: const Text("Bu notu silmek istediğinize emin misiniz?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Hayır"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          final index = _notes.indexOf(note);
                          if (index != -1) {
                            _deleteNote(note.id!, index);
                          }
                        },
                        child: const Text("Evet"),
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Sil',
          ),
        ],
      ),
      child: _buildDisplayNoteView(note), // Balonun içeriği
    ),
  );
}

  Widget _buildEditingNoteView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _editingTitleController,
          autofocus: true,
          maxLines: 1,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Başlık',
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
          style: const TextStyle(fontSize: 18),
        ),
        const Divider(height: 10, thickness: 1, indent: 0, endIndent: 0),
        TextField(
          controller: _editingContentController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Notunuzu buraya yazın..',
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: _saveEditedNote,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Kaydet'),
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayNoteView(Note note) {
    return ListTile(
      title: Text(
        note.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        note.content,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      // Yüksekliği daha tutarlı hale getirmek için bu parametreleri ayarlayın
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      isThreeLine: false, // subtitle 2 satır olduğu için bunu false yapın
    );
  }

  Widget _buildNotesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_notes.isEmpty) {
      return _buildEmptyNotesMessage();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        final isEditing = _editingNoteId == note.id;
        return _buildNoteCard(context, note, isEditing);
      },
    );
  }

  AppBar _buildEditingModeAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.check),
        onPressed: _saveEditedNote,
        tooltip: 'Değişiklikleri Kaydet',
      ),
      title: const Text('Notu Düzenle'),
      actions: [
        IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            setState(() {
              _editingNoteId = null;
              _editingTitleController.clear();
              _editingContentController.clear();
            });
          },
          tooltip: 'İptal Et',
        ),
      ],
    );
  }

  AppBar? _buildAppBar() {
    if (_editingNoteId != null) {
      return _buildEditingModeAppBar();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildNotesList(),
    );
  }
}