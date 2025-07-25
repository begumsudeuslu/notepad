// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
// Diğer ekran dosyalarını import ediyoruz
import 'package:notepad/screens/account_screen.dart';
import 'package:notepad/screens/notes_screen.dart';
import 'package:notepad/screens/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Alt menüdeki seçili öğenin indeksi
  // 0: Hesap, 1: Notlar, 2: Görevler. Biz Notlar (index 1) ile başlayacağız.
  int _selectedIndex = 1; 

  // Alt menüde gösterilecek ekranların listesi
  static final List<Widget> _widgetOptions = <Widget>[
    const AccountScreen(), // Hesap Sayfası
    const NotesScreen(),   // Notlar Sayfası (Ana Ekran)
    const TasksScreen(),   // Görevler Sayfası (Şimdilik boş yer tutucu)
  ];

  // Alt menü öğesine tıklandığında çalışacak fonksiyon
  void _onItemTapped(int index) {
    setState(() { // Ekranı yeniden çizmek için kullanılır (durum değiştiğinde UI güncellenir)
      _selectedIndex = index; // Seçilen indeksi günceller
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Temel Materyal Tasarım düzeni
      appBar: AppBar( // Uygulamanın üst çubuğu (başlık çubuğu)
        title: const Text('My Notes & Tasks'), // Uygulama başlığı
        // Arama çubuğu daha sonra buraya eklenecek
      ),
      body: Center( // Ekran içeriğini ortala
        child: _widgetOptions.elementAt(_selectedIndex), // Seçili olan ekranı gösterir
      ),
      bottomNavigationBar: BottomNavigationBar( // Uygulamanın alt navigasyon çubuğu
        items: const <BottomNavigationBarItem>[ // Navigasyon öğeleri (tuşları)
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Hesap ikonu
            label: 'Hesap',           // Hesap etiketi
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),   // Notlar ikonu
            label: 'Notlar',          // Notlar etiketi
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),   // Görevler ikonu
            label: 'Görevler',         // Görevler etiketi
          ),
        ],
        currentIndex: _selectedIndex, // Şu an aktif olan öğenin indeksi
        selectedItemColor: Colors.amber[800], // Seçili öğenin rengi
        onTap: _onItemTapped, // Öğeye tıklandığında _onItemTapped fonksiyonunu çalıştır
      ),
    );
  }
}