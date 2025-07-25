//lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // HomeScreen dosyanın yolu (dosyanın konumuna göre güncelle)

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki debug yazısını kaldırır
      title: 'Notepad App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // Material 3 kullanmak istersen true yap
      ),
      home: HomeScreen(), // Başlangıç ekranı
    );
  }
}


