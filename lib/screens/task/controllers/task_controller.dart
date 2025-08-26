import 'package:flutter/material.dart';
import 'package:notepad/models/task.dart';
import 'package:notepad/databases/database.dart';

class TaskController extends ChangeNotifier {
  List<Task> _tasks = [];
  final TextEditingController searchController = TextEditingController();

  String _searchQuery = '';
  bool _showCompleted = true;

  List<Task> get tasks => List.unmodifiable(_tasks);

  String get searchQuery => _searchQuery;
  bool get showCompleted => _showCompleted;

  // DB’den görevleri yükle
  Future<void> refreshAllTasks() async {
    _tasks = await NotePadDatabase.instance.readAllTask();
    notifyListeners();
  }

  // Görev ekle
  void addTask(Task task) async {
    await NotePadDatabase.instance.createTask(task);
    await refreshAllTasks();
  }

  // Görev tamamlanma durumunu değiştir
  void toggleTask(int index) {
    final updatedTask = _tasks[index].copy(isDone: !_tasks[index].isDone);
    _tasks[index] = updatedTask;
    NotePadDatabase.instance.updateTask(updatedTask);
    notifyListeners();
  }

  // Görev düzenle
  void editTask(int index, Task updatedTask) {
    _tasks[index] = updatedTask;
    // NotePadDatabase.instance.updateTask(updatedTask);
    notifyListeners();
  }

  // Görev sil
  void deleteTask(int index) async {
    final id = _tasks[index].id;
    if (id != null) {
      await NotePadDatabase.instance.deleteTask(id);
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  // Arama ile filtrele
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    searchController.clear();
    notifyListeners();
  }

  // Tamamlananları göster/gizle
  void toggleShowCompleted(bool val) {
    _showCompleted = val;
    notifyListeners();
  }

  // Arama ve filtre uygulanmış görevler
  List<Task> get filteredTasks {
    return _tasks.where((task) {
      final matchesSearch = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCompleted = _showCompleted || !task.isDone;
      return matchesSearch && matchesCompleted;
    }).toList();
  }
}
