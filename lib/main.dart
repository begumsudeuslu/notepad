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
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 173, 134, 207),
        useMaterial3: false,
        inputDecorationTheme: const InputDecorationTheme(
          prefixIconColor: Color.fromARGB(255, 173, 134, 207), // ikon mor
          floatingLabelStyle: TextStyle(
            color: Color.fromARGB(255, 173, 134, 207), // focus olunca label mor
          ),
          labelStyle: TextStyle(
            color: Colors.grey, // normal label gri
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 173, 134, 207), // focus border mor
              width: 2,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
