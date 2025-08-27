import 'package:flutter/material.dart';
import 'package:notepad/models/task.dart';
import 'package:notepad/databases/database.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskController extends ChangeNotifier {
  // Yönetilecek veriler
  List<Task> _allTasks = [];
  String _searchQuery = '';
  bool _showCompleted = true;
  DateTime _selectedDate = DateTime.now();
  String _sortBy = 'created';

  // Controller'a dışarıdan erişim için getter'lar
  List<Task> get allTasks => List.unmodifiable(_allTasks);
  String get searchQuery => _searchQuery;
  bool get showCompleted => _showCompleted;
  DateTime get selectedDate => _selectedDate;
  String get sortBy => _sortBy;

  // Arama çubuğu için controller
  final TextEditingController searchController = TextEditingController();

  // Constructor
  TaskController() {
    refreshAllTasks();
  }

  // Tüm görevleri veritabanından yükler ve filtreleme işlemini başlatır
  Future<void> refreshAllTasks() async {
    _allTasks = await NotePadDatabase.instance.readAllTask();
    _refreshFilteredTasks();
  }

  // Görev ekler ve listeyi yeniler
  Future<void> addTask(Task task) async {
    await NotePadDatabase.instance.createTask(task);
    await refreshAllTasks();
  }

  // Görev düzenler ve listeyi yeniler
  Future<void> updateTask(Task task) async {
    await NotePadDatabase.instance.updateTask(task);
    await refreshAllTasks();
  }

  // Görev siler ve listeyi yeniler
  Future<void> deleteTask(int taskId) async {
    await NotePadDatabase.instance.deleteTask(taskId);
    await refreshAllTasks();
  }

  // Görev tamamlanma durumunu değiştirir
  void toggleTask(Task task) async {
    final updatedTask = task.copy(isDone: !task.isDone);
    await NotePadDatabase.instance.updateTask(updatedTask);
    await refreshAllTasks();
  }

  // Arama, filtre ve takvim mantığını tek bir metotta toplar
  void _refreshFilteredTasks() {
    notifyListeners();
  }

  // Arama sorgusunu ayarlar
  void setSearchQuery(String query) {
    _searchQuery = query;
    _refreshFilteredTasks();
  }

  // Tamamlanan görevlerin gösterilip gösterilmeyeceğini ayarlar
  void toggleShowCompleted(bool val) {
    _showCompleted = val;
    _refreshFilteredTasks();
  }

  // Sıralama türünü ayarlar
  void setSortBy(String value) {
    _sortBy = value;
    _refreshFilteredTasks();
  }

  // Takvimden seçilen tarihi ayarlar
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _refreshFilteredTasks();
  }

  // Seçili tarihi temizler
  void clearSelectedDate() {
    _selectedDate = DateTime.now();
    _refreshFilteredTasks();
  }

  // Arama sorgusunu temizler
  void clearSearch() {
    _searchQuery = '';
    searchController.clear();
    _refreshFilteredTasks();
  }

  // Arama ve filtre uygulanmış görevleri döndüren getter
  List<Task> get filteredTasks {
    List<Task> filtered = _allTasks.where((task) {
      final isSameDayCondition = isSameDay(task.date, _selectedDate);
      final matchesSearchQuery =
          _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (task.description ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final showCompletedCondition = _showCompleted || !task.isDone;
      return isSameDayCondition && matchesSearchQuery && showCompletedCondition;
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

  // Takvimde nokta göstermek için o güne ait görevleri döndürür
  List<Task> getTasksForDay(DateTime day) {
    return _allTasks.where((task) => isSameDay(task.date, day)).toList();
  }
}
