import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Hesap Sayfası(Giriş Yapma/Kayıt Olma)",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
