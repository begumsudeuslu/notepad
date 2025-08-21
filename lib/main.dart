import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:notepad/databases/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // veritabanını sıfırla
  // await NotePadDatabase.instance.resetDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notepad App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: const HomeScreen(),
    );
  }
}
