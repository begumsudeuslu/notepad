import 'package:flutter/material.dart';
import 'package:notepad/databases/database.dart';
import '../../models/note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'note_card.dart';
import 'search_bar.dart';

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
  List<Note> _foundNotes = [];

  bool _isLoading = false;
  bool _isSearching = false;

  int? _editingNoteId;

  final TextEditingController _editingTitleController = TextEditingController();
  final TextEditingController _editingContentController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _editingTitleController.dispose();
    _editingContentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });
    final notes = await NotePadDatabase.instance.readAllNotes();
    setState(() {
      _notes = notes.reversed.toList();
      _foundNotes = List<Note>.from(_notes); // <-- kopya
      _isLoading = false;
    });
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _foundNotes = List<Note>.from(_notes); // <-- kopya
      } else {
        _foundNotes = _notes
            .where(
              (note) =>
                  note.title.toLowerCase().contains(query) ||
                  note.content.toLowerCase().contains(query),
            )
            .toList(); // zaten kopya
      }
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
      final noteToUpdate = _notes.firstWhere(
        (note) => note.id == _editingNoteId,
      );
      final updatedNote = noteToUpdate.copy(
        title: _editingTitleController.text,
        content: _editingContentController.text,
        updatedAt: DateTime.now(),
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

  // notu silen fonksiyon
  void _deleteNote(int id) async {
    // Silmeden önce notu bul (undo için sakla)
    final deletedNote = _notes.firstWhere((n) => n.id == id);

    setState(() {
      // Index yerine id ile güvenli sil
      _notes.removeWhere((n) => n.id == id);
      _foundNotes.removeWhere((n) => n.id == id);
    });

    bool isUndo = false;

    final snackBar = SnackBar(
      content: Text('${deletedNote.title} adlı not silindi.'),
      action: SnackBarAction(
        label: 'Geri Al',
        onPressed: () {
          isUndo = true;
          setState(() {
            // En üste geri koy
            _notes.insert(0, deletedNote);

            // Arama aktifse, eşleşiyorsa geri göster
            final q = _searchController.text.toLowerCase();
            final matches =
                q.isEmpty ||
                deletedNote.title.toLowerCase().contains(q) ||
                deletedNote.content.toLowerCase().contains(q);

            if (matches) {
              _foundNotes.insert(0, deletedNote);
            }
          });
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) async {
      if (!isUndo) {
        await NotePadDatabase.instance.delete(id);
      }
    });
  }

  void _showNoteDetail(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(note.title),
          content: SingleChildScrollView(child: Text(note.content)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Kapat"),
            ),
          ],
        );
      },
    );
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

  Widget _buildNotesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final listToShow = _isSearching ? _foundNotes : _notes;

    if (listToShow.isEmpty) {
      return _buildEmptyNotesMessage();
    }

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: listToShow.length,
        itemBuilder: (context, index) {
          final note = listToShow[index];
          final isEditing = _editingNoteId == note.id;

          return NoteCard(
            note: note,
            isEditing: isEditing,
            titleController: _editingTitleController,
            contentController: _editingContentController,
            onStartEdit: () => _startEditing(note),
            onSaveEdit: _saveEditedNote,
            onDelete: () {
              if (note.id != null) {
                _deleteNote(note.id!);
              }
            },
            onTap: () => _showNoteDetail(context, note),
          );
        },
      ),
    );
  }

  AppBar _buildEditingModeAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 166, 128, 199),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _editingNoteId != null
          ? Column(
              children: [
                _buildEditingModeAppBar(),
                Expanded(child: _buildNotesList()),
              ],
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 50.0,
                  floating: true,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 166, 128, 199),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  centerTitle: true,
                  title: const Text(
                    'Not Listesi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SearchBarWidget(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _filterNotes();
                          });
                        },
                        onClear: () {
                          _searchController.clear();
                          setState(() {
                            _filterNotes();
                          });
                        },
                      ),
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final note = _foundNotes[index];
                    final isEditing = _editingNoteId == note.id;

                    return NoteCard(
                      note: note,
                      isEditing: isEditing,
                      titleController: _editingTitleController,
                      contentController: _editingContentController,
                      onStartEdit: () => _startEditing(note),
                      onSaveEdit: _saveEditedNote,
                      onDelete: () {
                        if (note.id != null) {
                          _deleteNote(note.id!);
                        }
                      },
                      onTap: () => _showNoteDetail(context, note),
                    );
                  }, childCount: _foundNotes.length),
                ),

                if (_foundNotes.isEmpty && !_isLoading)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyNotesMessage(),
                  ),
              ],
            ),
      // home_screen de tanımlandı o yüzden buradan kaldırıldı:)
      // floatingActionButton: FloatingActionButton(
      //   onPressed: addNoteFromExternal,
      //   backgroundColor: Colors.blue.shade500,
      //   foregroundColor: Colors.white,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
