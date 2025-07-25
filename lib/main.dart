//lib/main.dart
import 'package:flutter/material.dart';

//MainScreen dosyasını import et
import 'package:notepad/screens/main_screen.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes & Tasks App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(), // Şimdi hata vermeyecek
    );
  }
}


