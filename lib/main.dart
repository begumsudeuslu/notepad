import 'package:flutter/material.dart';
import 'package:notepad/controllers/account_controller.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'package:notepad/databases/database.dart';
import 'controllers/note_controller.dart';
import 'controllers/task_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/account_controller.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteController()),
        ChangeNotifierProvider(create: (context) => TaskController()),
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => AccountController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notepad App',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 173, 134, 207),
          useMaterial3: false,
          inputDecorationTheme: const InputDecorationTheme(
            prefixIconColor: Color.fromARGB(255, 173, 134, 207), // ikon mor
            floatingLabelStyle: TextStyle(
              color: Color.fromARGB(
                255,
                173,
                134,
                207,
              ), // focus olunca label mor
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
          // Switch düğmesinin rengini burada global olarak ayarlıyoruz
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return const Color.fromARGB(
                  255,
                  173,
                  134,
                  207,
                ); // Açıkkenki topuz rengi
              }
              return Colors.grey; // Kapalıykenki topuz rengi
            }),
            trackColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return const Color.fromARGB(
                  255,
                  173,
                  134,
                  207,
                ).withOpacity(0.5); // Açıkkenki yol rengi
              }
              return Colors.grey.shade300; // Kapalıykenki yol rengi
            }),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
