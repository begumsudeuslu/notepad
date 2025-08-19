//lib/databases/database.dart

import 'dart:async';
import 'dart:core';

//sqlite kütüphanesi
import 'package:sqflite/sqflite.dart';

//path paketi, dosyalar için
import 'package:path/path.dart';

import '../models/note.dart'; // Note sınıfı import edildi
import '../models/task.dart'; // task sınıfı import edildi

// Class, database management
class NotePadDatabase {
  // singleton pattern (tekil desen): uygulamanın her yerinden database'e tek bir nesneden(instance) erişir, global eirşim
  static final NotePadDatabase instance = NotePadDatabase._init();

  // database nesnesini tutacak variable, static çünkü classa ait
  static Database? _database;

  // priviate kurucu method, dışarıdan nesne instance oluşumunu engeller, sadece yukarıdaki instance değişkeni aracılığıyla erişilir kılınır
  NotePadDatabase._init();

  // private, database açıksa döndür, değilse _initDB methodu ile dbase.db database'ini oluşturur
  Future<Database> get database async {
    if (_database != null) return _database!; // zaten bir database var, kullan

    _database = await _initDB('dbase.db'); // methodla tekrar oluştur

    return _database!;
  }

  // bağlantıyı başlatan method
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath); // database'in tam path'i

    // database yoksa oluşturur, varsa açar
    return await openDatabase(
      path,
      version:
          2, // database schema first version, if you change the schema version will be increase
      onCreate:
          _createDB, // database ilk oluşturuludğunda _createDB methodunu çaır ve database oluştur.
      onUpgrade:
          _upgradeDB, // eğer version arttırılırsa eski databasei güncellemek için kullanılır
    );
  }

  // database yoksa ve ilk kez oluşturulacaksa çağırılır
  Future _createDB(Database db, int version) async {
    // INTEGER PRIMARY KEY AUTOINCREMENT: otomatik artan benzersiz sayı (id)
    // TEXT NOT NULL: boş olamazlar
    await db.execute('''
 CREATE TABLE notes (
id INTEGER PRIMARY KEY AUTOINCREMENT,
 title TEXT NOT NULL,
 content TEXT NOT NULL,
 createdAt INTEGER NOT NULL
 )
 ''');

    // tasks tablosu
    await db.execute('''
 CREATE TABLE tasks(
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 title TEXT NOT NULL,
 description TEXT,
 isDone INTEGER NOT NULL,
 createdAt INTEGER NOT NULL,
 color TEXT NOT NULL
 )
''');
  }

  /// Veritabanı versiyonu arttığında yapılacak işlemler
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
 CREATE TABLE tasks (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 title TEXT NOT NULL,
 description TEXT,
 isDone INTEGER NOT NULL,
createdAt INTEGER NOT NULL,
 color TEXT NOT NULL
 )
 ''');
    }
  }

  /// Create, Read, Update, Delete (CRUD) methods

  Future<Note> create(Note note) async {
    final db = await instance.database;

    // notes tablosunun map'e dönüştürülmüş hali,
    final id = await db.insert(
      'notes',
      note.toMap(),
    ); // insert methodu eklenen satırın id'sini döndürür
    return note.copy(id: id); // database'e atanan id'yi ekleyip döndürür
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database; // database bağlantısı

    final orderBy =
        'createdAt DESC'; // en yeni en üste gelecek şekilde azalan sırada sırala

    final result = await db.query(
      'notes',
      orderBy: orderBy,
    ); // notes tablosundan tüm verileri srogulayıp sırala

    return result
        .map((json) => Note.fromMap(json))
        .toList(); // map listesini formMap methoduyla dönüştür
  }

  Future<int> update(Note note) async {
    final db =
        await instance.database; // database bağlantısı tekrar al, hep al..

    return db.update(
      'notes', // notes tablosundan
      note.toMap(), //notun güncel map hali
      where: 'id= ?', // ?: bir yer tutucu, whereArgs ile doldurur imiş
      whereArgs: [note.id], // id'yi buraya koyar
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database; // databse bağlantısı
    return await db.delete('notes', where: 'id=?', whereArgs: [id]);
  }

  // merve'nın task
  // TASK METODLARI
  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    return task.copy(id: id);
  }

  Future<List<Task>> readAllTask() async {
    final db = await instance.database; // database bağlantısı
    final orderBy =
        'createdAt DESC'; // en yeni en üste gelecek şekilde azalan sırada sırala

    final result = await db.query(
      'tasks',
      orderBy: orderBy,
    ); // notes tablosundan tüm verileri srogulayıp sırala
    return result
        .map((json) => Task.fromMap(json))
        .toList(); // map listesini formMap methoduyla dönüştür
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // kapat
  Future close() async {
    final db = await instance.database;
    db.close();
    _database = null; // bağlantıyı null yaparak kapatır
  }
}
