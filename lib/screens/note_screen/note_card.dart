import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/note.dart';
import 'editing_note_view.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isEditing;
  final TextEditingController titleController;
  final TextEditingController contentController;

  final VoidCallback onStartEdit;
  final VoidCallback onSaveEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.isEditing,
    required this.titleController,
    required this.contentController,
    required this.onStartEdit,
    required this.onSaveEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color.fromARGB(255, 128, 124, 124),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: EditingNoteView(
            titleController: titleController,
            contentController: contentController,
            onSave: onSaveEdit,
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Slidable(
        key: ValueKey(note.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onStartEdit(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Düzenle',
            ),
            SlidableAction(
              onPressed: (context) async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
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
                if (confirmed == true) {
                  onDelete();
                }
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Sil',
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            note.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.content,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  note.updatedAt != null
                      ? 'Düzenlendi: ${note.updatedAt!.day}.${note.updatedAt!.month}.${note.updatedAt!.year} ${note.updatedAt!.hour}:${note.updatedAt!.minute}'
                      : 'Oluşturuldu: ${note.createdAt.day}.${note.createdAt.month}.${note.createdAt.year} ${note.createdAt.hour}:${note.createdAt.minute}',
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          isThreeLine: false,
          onTap: onTap,
        ),
      ),
    );
  }
}
