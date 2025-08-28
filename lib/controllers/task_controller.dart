import 'package:flutter/material.dart';
import 'package:notepad/models/task.dart';
import 'package:notepad/databases/database.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskController extends ChangeNotifier {
  List<Task> _allTasks = [];
  String _searchQuery = '';
  // true: sadece tamamlananları, false: sadece tamamlanmayanları
  bool _showCompletedOnly = false; // Varsayılan olarak tamamlananları gösterme
  DateTime? _selectedDate = DateTime.now();
  String _sortBy = 'created';

  final TextEditingController searchController = TextEditingController();

  TaskController() {
    refreshAllTasks();
  }

  List<Task> get allTasks => List.unmodifiable(_allTasks);
  String get searchQuery => _searchQuery;
  bool get showCompletedOnly => _showCompletedOnly;
  DateTime? get selectedDate => _selectedDate;
  String get sortBy => _sortBy;

  /// Veritabanından tüm görevleri çek ve UI'ı güncelle
  Future<void> refreshAllTasks() async {
    _allTasks = await NotePadDatabase.instance.readAllTask();
    notifyListeners();
  }

  /// Görev ekle ve UI'ı anında güncelle
  Future<void> addTask(Task task) async {
    final newTask = await NotePadDatabase.instance.createTask(task);
    _allTasks.add(newTask);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await NotePadDatabase.instance.updateTask(task);
    final index = _allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _allTasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    await NotePadDatabase.instance.deleteTask(taskId);
    _allTasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  void toggleTask(Task task) async {
    final updatedTask = task.copy(isDone: !task.isDone);
    await updateTask(updatedTask);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleShowCompleted(bool val) {
    _showCompletedOnly = val;
    notifyListeners();
  }

  void setSortBy(String value) {
    _sortBy = value;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void clearSelectedDate() {
    _selectedDate = null;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    searchController.clear();
    notifyListeners();
  }

  /// Filtrelenmiş görevler
  List<Task> get filteredTasks {
    List<Task> filtered = _allTasks.where((task) {
      final matchesDate =
          _selectedDate == null || isSameDay(task.date, _selectedDate!);
      final matchesSearch =
          _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (task.description ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      // Yeni filtre mantığı
      final matchesCompleted = _showCompletedOnly ? task.isDone : !task.isDone;

      return matchesDate && matchesSearch && matchesCompleted;
    }).toList();

    filtered.sort((a, b) {
      if (_sortBy == 'alphabetical') {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });

    return filtered;
  }

  /// Takvimde nokta göstermek için o güne ait görevler
  List<Task> getTasksForDay(DateTime day) {
    return _allTasks.where((task) => isSameDay(task.date, day)).toList();
  }
}
