// lib/screens/notes_screen.dart
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notlar Sayfası (Ana Ekran)', style: TextStyle(fontSize: 24),),);
  }
}