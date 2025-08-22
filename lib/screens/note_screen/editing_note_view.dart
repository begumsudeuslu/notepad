import 'package:flutter/material.dart';

class EditingNoteView extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final VoidCallback onSave;

  const EditingNoteView({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: titleController,
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
          controller: contentController,
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
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(
                255,
                189,
                157,
                216,
              ), // güncelleme gerekebilir
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
}
