import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> _tasks = []; // Görev listesi

  // Görev ekleme
  void addTask() {
    _showAddTaskDialog();
  }

  // Yeni görev ekleme diyalogu
  void _showAddTaskDialog() {
    String newTask = '';
    String selectedColor = 'white'; // Varsayılan renk

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
                  onChanged: (value) => newTask = value,
                  decoration: const InputDecoration(hintText: 'Görev adı'),
                ),
                const SizedBox(height: 16),
                // Renk seçme butonları
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
                onPressed: () {
                  if (newTask.isNotEmpty) {
                    setState(() {
                      _tasks.add({
                        'title': newTask,
                        'done': false,
                        'color': selectedColor,
                      });
                    });
                    Navigator.pop(context);
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

  // Renk seçme widget'ı (yuvarlak)
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

  // Görev renklendirme
  Color _getTaskColor(String color) {
    switch (color) {
      case 'red':
        return Colors.red.shade100;
      case 'yellow':
        return Colors.yellow.shade100;
      case 'green':
      default:
        return Colors.white;
    }
  }

  // Görev tamamlama
  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  // Görev silme
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Görev düzenleme (sadece başlık - istersen renge de ekleyebiliriz)
  void _editTask(int index) {
    String updatedTask = _tasks[index]['title'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Görevi Düzenle'),
          content: TextField(
            controller: TextEditingController(text: _tasks[index]['title']),
            onChanged: (value) => updatedTask = value,
            decoration: const InputDecoration(hintText: 'Yeni görev adı'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (updatedTask.isNotEmpty) {
                  setState(() {
                    _tasks[index]['title'] = updatedTask;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
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
        return Card(
          color: _getTaskColor(task['color']), // Arka plan rengi
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 3,
          child: ListTile(
            leading: Checkbox(
              value: task['done'],
              onChanged: (value) => _toggleTask(index),
            ),
            title: Text(
              task['title'],
              style: TextStyle(
                fontSize: 18,
                decoration: task['done']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editTask(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
