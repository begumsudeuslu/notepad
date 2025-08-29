import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notepad/databases/database.dart';
import '../services/account_service.dart';

class AccountController extends ChangeNotifier {

  final AccountService _accountService=AccountService();

  int _notesCount = 0;
  int _tasksCount = 0;
  int _completedTasksCount = 0;
  bool _enableNotifications = true;

  int get notesCount => _notesCount;
  int get tasksCount => _tasksCount;
  int get completedTasksCount => _completedTasksCount;
  bool get enableNotifications => _enableNotifications;

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
      await _accountService.deleteAccount();
      resetStats();
      _enableNotifications=true;
      notifyListeners();
    } catch (e)  {
      rethrow;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try{
      await _accountService.changePassword(oldPassword, newPassword);
      notifyListeners();
    } on FirebaseAuthException catch (e)  {
      rethrow;
    } catch (e)  {
      rethrow;
    }
  }
}
