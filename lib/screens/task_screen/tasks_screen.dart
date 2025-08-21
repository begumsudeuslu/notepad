import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:notepad/databases/database.dart';
import 'package:notepad/models/task.dart';
import 'package:notepad/screens/task_screen/add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  // ... (mevcut değişkenleriniz)
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

  // YENİ GÖREV EKLEMEK İÇİN KULLANILAN METOT
  void addTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (result == true) {
      _refreshAllTasks();
    }
  }

  // GÖREVİ DÜZENLEMEK İÇİN KULLANILAN YENİ METOT
  void _editTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen(taskToEdit: task)),
    );
    if (result == true) {
      _refreshAllTasks();
    }
  }

  // ... (diğer mevcut metotlarınız)
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

  Color _getTaskColor(String color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      case 'purple':
        return const Color(0xFFC3A5DE);
      case 'gray':
        return const Color(0xFFCFCFCF);
      case 'FF5733':
        return const Color(0xFFFF5733);
      case 'FFBD33':
        return const Color(0xFFFFBD33);
      case '33FF57':
        return const Color(0xFF33FF57);
      case '33B5FF':
        return const Color(0xFF33B5FF);
      case 'C3A5DE':
        return const Color(0xFFC3A5DE);
      case '8A2BE2':
        return const Color(0xFF8A2BE2);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredTasks;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          'Yapılacaklar Listesi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 166, 128, 199),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Görevlerde ara",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _refreshFilteredTasks();
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _searchQuery = v;
                          _refreshFilteredTasks();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _selectedDate,
                        selectedDayPredicate: (day) =>
                            _isDateSelected && isSameDay(_selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          if (_isDateSelected &&
                              isSameDay(selectedDay, _selectedDate)) {
                            setState(() {
                              _isDateSelected = false;
                              _refreshFilteredTasks();
                            });
                          } else {
                            setState(() {
                              _selectedDate = selectedDay;
                              _isDateSelected = true;
                              _refreshFilteredTasks();
                            });
                          }
                        },
                        eventLoader: (day) {
                          final hasTasks = _allTasks.any(
                            (task) => isSameDay(task.date, day),
                          );
                          return hasTasks ? [true] : [];
                        },
                        calendarStyle: CalendarStyle(
                          selectedDecoration: const BoxDecoration(
                            color: Color.fromARGB(255, 149, 141, 157),
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle: const TextStyle(
                            color: Colors.blueGrey,
                          ),
                          markerDecoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          outsideTextStyle: const TextStyle(color: Colors.grey),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Switch(
                                value: _showCompleted,
                                activeColor: const Color(0xFFC3A5DE),
                                inactiveThumbColor: Colors.grey.shade400,
                                inactiveTrackColor: Colors.grey.shade200,
                                onChanged: (val) {
                                  setState(() {
                                    _showCompleted = val;
                                    _refreshFilteredTasks();
                                  });
                                },
                              ),
                              const Text('Tamamlananları göster'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
          if (list.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final task = list[index];
                return Dismissible(
                  key: Key('${task.id ?? '${task.title}-$index'}'),
                  background: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.centerLeft,
                    color: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.centerRight,
                    color: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      _deleteTask(index);
                    }
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 70,
                          decoration: BoxDecoration(
                            color: _getTaskColor(task.color ?? 'white'),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (v) => _toggleTask(index),
                              activeColor: Colors.blue.shade500,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: Colors.grey.shade600,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue.shade600,
                              ),
                              // DÜZENLEME İŞLEMİ BURADA TETİKLENİR
                              onPressed: () => _editTask(task),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: list.length),
            ),
          if (list.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Hiç sonuç yok.\nYeni görev eklemek için + simgesine tıkla.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
