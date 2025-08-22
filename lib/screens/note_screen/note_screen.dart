import 'package:flutter/material.dart';
import 'package:notepad/databases/database.dart';
import '../../models/note.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'note_card.dart';
import 'search_bar.dart';
import 'note_editing_page.dart';

class NoteScreen extends StatefulWidget {
  final VoidCallback? onAddNote;
  const NoteScreen({super.key, this.onAddNote});

  @override
  NoteScreenState createState() {
    return NoteScreenState();
  }
}

enum SortOption { latest, oldest, alphabetical }

enum ViewOption { list, grid }

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

  SortOption _currentSortOption = SortOption.latest;
  ViewOption _currentViewOption = ViewOption.list;

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
      _notes = notes; // db'den al
      _sortNotes();
      _foundNotes = List<Note>.from(_notes); //kopya
      _isLoading = false;
    });
  }

  void _sortNotes() {
    switch (_currentSortOption) {
      case SortOption.latest:
        _notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.oldest:
        _notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOption.alphabetical:
        _notes.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
    }
    //sıralanan listeyi foundNotes'a yansıtılmalı
    _filterNotes();
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
            .toList(); //zaten kopya
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

  void _editNote(BuildContext context, Note note) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditingPage(note: note)),
    );

    if (updatedNote != null && updatedNote is Note) {
      await NotePadDatabase.instance.update(updatedNote);
      _refreshNotes();
    }
  }

  void _deleteNote(int id) async {
    final deletedNote = _notes.firstWhere((n) => n.id == id);

    setState(() {
      _notes.removeWhere((n) => n.id == id);
    });

    bool isUndo = false;

    final snackBar = SnackBar(
      content: Text('${deletedNote.title} adlı not silindi.'),
      action: SnackBarAction(
        label: 'Geri Al',
        onPressed: () {
          isUndo = true;
          setState(() {
            _notes.insert(0, deletedNote);
          });
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) async {
      if (!isUndo) {
        await NotePadDatabase.instance.delete(id);
      }
    });
    _filterNotes();
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

    if (_currentViewOption == ViewOption.list) {
      return SlidableAutoCloseBehavior(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: listToShow.length,
          itemBuilder: (context, index) {
            final note = listToShow[index];

            return NoteCard(
              note: note,
              onDelete: () {
                if (note.id != null) {
                  _deleteNote(note.id!);
                }
              },
              onTap: () => _showNoteDetail(context, note),
              onEdit: () => _editNote(context, note),
              isGridView: false,
            );
          },
        ),
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //her satırda 2 note
          childAspectRatio: 1.0, //genişlik/yükseklik oranı
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: listToShow.length,
        itemBuilder: (context, index) {
          final note = listToShow[index];

          return NoteCard(
            note: note,
            onDelete: () {
              if (note.id != null) {
                _deleteNote(note.id!);
              }
            },
            onTap: () => _showNoteDetail(context, note),
            onEdit: () => _editNote(context, note),
            isGridView: true,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Not Listesi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              PopupMenuButton<SortOption>(
                icon: const Icon(Icons.sort, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                onSelected: (SortOption result) {
                  setState(() {
                    _currentSortOption = result;
                    _sortNotes();
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SortOption>>[
                      const PopupMenuItem<SortOption>(
                        value: SortOption.latest,
                        child: Text('En Yeni'),
                      ),
                      const PopupMenuItem<SortOption>(
                        value: SortOption.oldest,
                        child: Text('En Eski'),
                      ),
                      const PopupMenuItem<SortOption>(
                        value: SortOption.alphabetical,
                        child: Text('Alfabetik'),
                      ),
                    ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentViewOption = _currentViewOption == ViewOption.list
                        ? ViewOption.grid
                        : ViewOption.list;
                  });
                },
                icon: Icon(
                  _currentViewOption == ViewOption.list
                      ? Icons.grid_view
                      : Icons.list,
                  color: Colors.white,
                ),
              ),
            ],
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

          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: _buildNotesList(),
            ),
          ),
        ],
      ),
    );
  }
}
