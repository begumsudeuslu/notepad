import 'package:flutter/material.dart';
import 'package:notepad/databases/database.dart';
import '../models/task.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  List<Task> _tasks = [];
  String _selectedColor = 'white';

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    final tasks = await NotePadDatabase.instance.readAllTask();
    print("Tasks loaded: ${tasks.length}");
    setState(() {
      _tasks = tasks;
    });
  }

  void addTask() {
    _showAddTaskDialog();
  }

  // Hata vermemesi için _buildColorCircle'ı en başa aldık
  Widget _buildColorCircle(
    Color color,
    String value,
    String selected,
    Function(String) onSelect,
  ) {
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected == value ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  Color _getTaskColor(String color) {
    switch (color) {
      case 'red':
        return Colors.red.shade100;
      case 'yellow':
        return Colors.yellow.shade100;
      case 'green':
        return Colors.green.shade100;
      default:
        return Colors.white;
    }
  }

  void _showAddTaskDialog() {
    String newTask = '';
    String selectedColor = 'white';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Yeni Görev Ekle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  onChanged: (value) => newTask = value,
                  decoration: const InputDecoration(hintText: 'Görev adı'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorCircle(
                      Colors.red,
                      'red',
                      selectedColor,
                      (color) => setStateDialog(() => selectedColor = color),
                    ),
                    _buildColorCircle(
                      Colors.yellow,
                      'yellow',
                      selectedColor,
                      (color) => setStateDialog(() => selectedColor = color),
                    ),
                    _buildColorCircle(
                      Colors.green,
                      'green',
                      selectedColor,
                      (color) => setStateDialog(() => selectedColor = color),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () async {
                  if (newTask.isNotEmpty) {
                    final task = Task(
                      title: newTask,
                      description: '',
                      isDone: false,
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                      color: selectedColor,
                    );
                    await NotePadDatabase.instance.createTask(task);
                    Navigator.pop(context);
                    _refreshTasks();
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleTask(int index) async {
    final task = _tasks[index];
    final updatedTask = task.copy(isDone: !task.isDone);
    await NotePadDatabase.instance.updateTask(updatedTask);
    _refreshTasks();
  }

  void _deleteTask(int index) async {
    await NotePadDatabase.instance.deleteTask(_tasks[index].id!);
    _refreshTasks();
  }

  // Yeni düzenleme metodunu doğru yere taşıdık ve `_editTask` yerine bunu kullanacağız
  void _showEditTaskDialog(int index) {
    final Task originalTask = _tasks[index];
    String updatedTitle = originalTask.title;
    String selectedColor = originalTask.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Görevi Düzenle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  controller: TextEditingController(text: originalTask.title),
                  onChanged: (value) => updatedTitle = value,
                  decoration: const InputDecoration(hintText: 'Yeni görev adı'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorCircle(
                      Colors.red,
                      'red',
                      selectedColor,
                      (color) => setStateDialog(() => selectedColor = color),
                    ),
                    _buildColorCircle(
                      Colors.yellow,
                      'yellow',
                      selectedColor,
                      (color) => setStateDialog(() => selectedColor = color),
                    ),
                    _buildColorCircle(
                      Colors.green,
                      'green',
                      selectedColor,
                      (color) => setStateDialog(() => selectedColor = color),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () async {
                  if (updatedTitle.isNotEmpty) {
                    final updated = originalTask.copy(
                      title: updatedTitle,
                      color: selectedColor,
                    );
                    await NotePadDatabase.instance.updateTask(updated);
                    Navigator.pop(context);
                    _refreshTasks();
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks.isEmpty) {
      return const Center(
        child: Text(
          'Henüz görev yok. + simgesine tıklayarak görev ekleyebilirsin.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Dismissible(
          key: Key(task.id.toString()),

          // Sola kaydırınca görünecek arka plan (Silme Butonu)
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),

          // Sola kaydırma yönü için (endToStart)
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),

          // Sadece silme işlemini bu metotla yapıyoruz
          onDismissed: (direction) async {
            if (direction == DismissDirection.endToStart) {
              _deleteTask(index);
            }
          },

          // Bu, kaydırmayı belirli bir mesafede durdurmaya yarıyor
          dismissThresholds: const {
            DismissDirection.endToStart: 0.2, // Sağa kaydırma için
            DismissDirection.startToEnd: 0.2, // Sola kaydırma için
          },

          // Ana widget'ımız. Kartın kendisi.
          child: Card(
            color: _getTaskColor(task.color),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            child: ListTile(
              leading: Checkbox(
                value: task.isDone,
                onChanged: (value) => _toggleTask(index),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 18,
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              // Buraya yeni menü butonlarını ekliyoruz
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditTaskDialog(index),
                  ),
                  //   IconButton(
                  //     icon: const Icon(Icons.delete, color: Colors.red),
                  //     onPressed: () => _deleteTask(index),
                  //   ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
