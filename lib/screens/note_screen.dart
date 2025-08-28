import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../widgets/note_widgets/note_card.dart';
import '../widgets/note_widgets/search_bar.dart';
import '../widgets/note_widgets/note_editing_page.dart';
import '../../controllers/note_controller.dart';

enum SortOption { latest, oldest, alphabetical }

enum ViewOption { list, grid }

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  void _showNoteDetail(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
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

  Future<void> _editNote(BuildContext context, Note note) async {
    final controller = Provider.of<NoteController>(context, listen: false);
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditingPage(note: note)),
    );

    if (updatedNote != null && updatedNote is Note) {
      await controller.updateNote(updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NoteController>(
        builder: (context, noteController, child) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context, noteController),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: SearchBarWidget(
                      controller: noteController.searchController,
                      onChanged: (value) {
                        noteController.searchController.text = value;
                      },
                      onClear: () {
                        noteController.searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: _buildNotesList(context, noteController),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, NoteController noteController) {
    return SliverAppBar(
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
            noteController.updateSortOption(result);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
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
            noteController.toggleViewOption();
          },
          icon: Icon(
            noteController.currentViewOption == ViewOption.list
                ? Icons.grid_view
                : Icons.list,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesList(BuildContext context, NoteController noteController) {
    if (noteController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final listToShow = noteController.foundNotes;

    if (listToShow.isEmpty) {
      return _buildEmptyNotesMessage();
    }

    if (noteController.currentViewOption == ViewOption.list) {
      return _buildListView(context, listToShow, noteController);
    } else {
      return _buildGridView(context, listToShow, noteController);
    }
  }

  Widget _buildListView(
    BuildContext context,
    List<Note> notes,
    NoteController noteController,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onDelete: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text("Notu Sil"),
                  content: const Text(
                    "Bu notu silmek istediğinize emin misiniz?",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Hayır"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Evet"),
                    ),
                  ],
                );
              },
            );

            if (confirmed == true && note.id != null) {
              final deletedNote = noteController.foundNotes.firstWhere(
                (n) => n.id == note.id,
              );

              noteController.deleteNote(note.id!);

              final snackBar = SnackBar(
                content: Text('${deletedNote.title} adlı not silindi.'),
                action: SnackBarAction(
                  label: 'Geri Al',
                  onPressed: () {
                    noteController.addNoteFromExternal(note: deletedNote);
                  },
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((
                reason,
              ) {
                if (reason != SnackBarClosedReason.action) {
                  noteController.permanentDelete(deletedNote.id!);
                }
              });
            }
          },
          onTap: () => _showNoteDetail(context, note),
          onEdit: () => _editNote(context, note),
          isGridView: false,
        );
      },
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List<Note> notes,
    NoteController noteController,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 5,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onDelete: () => noteController.deleteNote(note.id!),
          onTap: () => _showNoteDetail(context, note),
          onEdit: () => _editNote(context, note),
          isGridView: true,
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
}
