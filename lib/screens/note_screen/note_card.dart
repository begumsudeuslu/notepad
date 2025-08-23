// NoteCard.dart
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final bool isGridView;

  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onTap,
    required this.onEdit,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ), // distance between  notes
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Slidable(
        key: ValueKey(note.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(),
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
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: ShapeDecoration(
              shape:
                  Theme.of(context).cardTheme.shape ??
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
              color: Theme.of(context).cardColor,
            ),
            child: isGridView
                ? _buildGridViewContent()
                : _buildListViewContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildListViewContent() {
    // Liste görünümü için mevcut ListTile yapısını kullan.
    return ListTile(
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
              _formatDate(),
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
    );
  }

  Widget _buildGridViewContent() {
    return Container(
      padding: const EdgeInsets.all(
        12.0,
      ), // padding is inside the container, margin is arround the container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(note.content, maxLines: 4, overflow: TextOverflow.ellipsis),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              _formatDate(),
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate() {
    final date = note.updatedAt ?? note.createdAt;
    final prefix = note.updatedAt != null ? 'Düzenlendi' : 'Oluşturuldu';
    return '$prefix: ${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute}';
  }
}
