//lib/databases/database.dart

import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../models/task.dart';

class NotePadDatabase {
  static final NotePadDatabase instance = NotePadDatabase._init();
  static Database? _database;

  NotePadDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dbase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5, // Artırılmış versiyon
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // notes tablosu
    await db.execute('''
  CREATE TABLE notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    createdAt INTEGER NOT NULL
  )
''');

    // tasks tablosu (date sütunu eklendi)
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isDone INTEGER NOT NULL,
        createdAt INTEGER NOT NULL,
        color TEXT,
        date INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dbase.db'); // doğru dosya adı
    await deleteDatabase(path);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await db.execute(
        'ALTER TABLE tasks ADD COLUMN date INTEGER NOT NULL DEFAULT 0',
      );
    }

    if (oldVersion < 5) {
      await db.execute('ALTER TABLE notes ADD COLUMN updatedAt INTEGER');
    }
  }

  ///CRUD METHODS

  //NOTES

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copy(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = 'createdAt DESC';
    final result = await db.query('notes', orderBy: orderBy);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // TASKS
  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    return task.copy(id: id);
  }

  Future<List<Task>> readAllTask() async {
    final db = await instance.database;
    final orderBy = 'createdAt DESC';
    final result = await db.query('tasks', orderBy: orderBy);
    return result.map((json) => Task.fromMap(json)).toList();
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

  Future close() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }
}
