import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notepad/databases/database.dart';
import 'package:notepad/models/task.dart';
import '../task_screen/task_list_view.dart';
import '../task_screen/calendar_and_controls.dart';
import '../task_screen/task_dialogs.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];

  DateTime _selectedDate = DateTime.now();
  bool _isDateSelected = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'created';
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    _refreshAllTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshAllTasks() async {
    final tasks = await NotePadDatabase.instance.readAllTask();
    setState(() {
      _allTasks = tasks;
      _refreshFilteredTasks();
    });
  }

  void _refreshFilteredTasks() {
    final filtered = _allTasks.where((task) {
      final isSameDayCondition =
          !_isDateSelected || isSameDay(task.date, _selectedDate);
      final matchesSearchQuery =
          _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (task.description ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final showCompleted = _showCompleted || !task.isDone;
      return isSameDayCondition && matchesSearchQuery && showCompleted;
    }).toList();

    filtered.sort((a, b) {
      if (_sortBy == 'alphabetical') {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });

    setState(() {
      _filteredTasks = filtered;
    });
  }

  void _toggleTask(int index) async {
    final task = _filteredTasks[index];
    final updatedTask = task.copy(isDone: !task.isDone);
    await NotePadDatabase.instance.updateTask(updatedTask);
    _refreshAllTasks();
  }

  void _deleteTask(int index) async {
    final id = _filteredTasks[index].id;
    if (id != null) {
      await NotePadDatabase.instance.deleteTask(id);
      _refreshAllTasks();
    }
  }

  void addTask() {
    showAddTaskDialog(context, _selectedDate, _refreshAllTasks);
  }

  void _showEditTaskDialog(int index) {
    final task = _filteredTasks[index];
    showEditTaskDialog(context, task, _refreshAllTasks);
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      if (_isDateSelected && isSameDay(day, _selectedDate)) {
        _isDateSelected = false;
      } else {
        _selectedDate = day;
        _isDateSelected = true;
      }
      _refreshFilteredTasks();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _refreshFilteredTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yapılacaklar Listesi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 67, 122, 69),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 550.0,
            floating: true,
            pinned: false,
            flexibleSpace: CalendarAndControls(
              searchController: _searchController,
              searchQuery: _searchQuery,
              selectedDate: _selectedDate,
              isDateSelected: _isDateSelected,
              allTasks: _allTasks,
              showCompleted: _showCompleted,
              sortBy: _sortBy,
              onSearchChanged: _onSearchChanged,
              onDaySelected: _onDaySelected,
              onShowCompletedChanged: (val) {
                setState(() {
                  _showCompleted = val;
                  _refreshFilteredTasks();
                });
              },
              onSortByChanged: (v) {
                if (v != null) {
                  setState(() {
                    _sortBy = v;
                    _refreshFilteredTasks();
                  });
                }
              },
            ),
          ),
          TaskListView(
            filteredTasks: _filteredTasks,
            onToggleTask: _toggleTask,
            onEditTask: _showEditTaskDialog,
            onDeleteTask: _deleteTask,
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: addTask,
      //   backgroundColor: Colors.blue.shade500,
      //   foregroundColor: Colors.white,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
