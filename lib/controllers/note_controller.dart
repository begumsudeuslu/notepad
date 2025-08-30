import 'package:flutter/material.dart';
import '../screens/note_screen.dart';
import '../databases/database.dart';
import '../models/note.dart';

class NoteController extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _foundNotes = [];
  bool _isLoading = false;
  SortOption _currentSortOption = SortOption.latest;
  ViewOption _currentViewOption = ViewOption.list;

  List<Note> get foundNotes => _foundNotes;
  bool get isLoading => _isLoading;
  SortOption get currentSortOption => _currentSortOption;
  ViewOption get currentViewOption => _currentViewOption;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  NoteController() {
    _searchController.addListener(_filterNotes);
    refreshNotes();
  }

  @override
  void dispose()  {
    _searchController.removeListener(_filterNotes);
    _searchController.dispose();
    super.dispose();
  }

  void _filterNotes()  {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _foundNotes = List<Note>.from(_notes);
    } else {
      _foundNotes = _notes
          .where(
            (note) =>
                 note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query),
           )
          .toList(); //zaten kopya
    }
    notifyListeners();
  }

  void _sortNotes() async  {
    switch(_currentSortOption)   {
      case SortOption.alphabetical:
        _notes.sort((a,b)=> a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      
      case SortOption.latest:
        _notes.sort((a,b)=> a.createdAt.compareTo(b.createdAt));
        break;

      case SortOption.oldest:
        _notes.sort((a,b)=> b.createdAt.compareTo(a.createdAt));
        break;
    }
    _filterNotes();
  }

  void updateSortOption(SortOption newOptions)  {
    _currentSortOption=newOptions;
    _sortNotes();
    notifyListeners();
  }

  void toggleViewOption()   {
    _currentViewOption=_currentViewOption==ViewOption.list?ViewOption.grid:ViewOption.list;
    notifyListeners();
  }

  Future<void> addNoteFromExternal({Note? note}) async {
    final newNote = note ?? Note(
      title: 'Yeni Not ${_notes.length + 1}',
      content: 'Bu notun içeriği..',
      createdAt: DateTime.now(),
    );
    await NotePadDatabase.instance.create(newNote);
    refreshNotes();
    }

  Future<void> deleteNote(int id) async  {
    await NotePadDatabase.instance.delete(id);
    _notes.removeWhere((n)=>n.id==id);
    _filterNotes();
    notifyListeners();
  }

  Future<void> permanentDelete(int id) async {
    await NotePadDatabase.instance.delete(id);
    refreshNotes();
  }

  Future<void> refreshNotes() async  {
    _isLoading=true;
    notifyListeners();
    _notes = await NotePadDatabase.instance.readAllNotes();
    _sortNotes();
    _foundNotes=List<Note>.from(_notes);
    _isLoading=false;
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
  await NotePadDatabase.instance.updateNote(note);
  await refreshNotes();
}

}