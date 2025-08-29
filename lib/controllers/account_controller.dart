import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notepad/databases/database.dart';

class AccountController extends ChangeNotifier {
  int _notesCount = 0;
  int _tasksCount = 0;
  int _completedTasksCount = 0;
  bool _enableNotifications = true;

  int get notesCount => _notesCount;
  int get tasksCount => _tasksCount;
  int get completedTasksCount => _completedTasksCount;
  bool get enableNotifications => _enableNotifications;

  //simülasyon
  Future<void> loadProductivityStats() async {
    final notes = await NotePadDatabase.instance.readAllNotes();
    final tasks = await NotePadDatabase.instance.readAllTask();
    _notesCount = notes.length;
    _tasksCount = tasks.length;
    _completedTasksCount = tasks.where((task) => task.isDone).length;
    notifyListeners();
  }

  void resetStats() {
    _notesCount = 0;
    _tasksCount = 0;
    _completedTasksCount = 0;
    notifyListeners();
  }

  Future<void> loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _enableNotifications = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _enableNotifications = value;
    await prefs.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<void> deleteAccount() async  {
    try {
      //await
    } catch (e)  {
      rethrow;
    }
  }
}
