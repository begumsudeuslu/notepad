import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> _tasks = []; // Görev listesi


  // HomeScreen'den çağrılacak görev ekleme metodu
  void addTask() {
    _showAddTaskDialog();
  }

  void _showAddTaskDialog() {
    String newTask = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Görev Ekle'),
        content: TextField(
          onChanged: (value) => newTask = value,
          decoration: const InputDecoration(hintText: 'Görev adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Vazgeç
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (newTask.isNotEmpty) {
                setState(() {
                  _tasks.add({'title': newTask, 'done': false});
                });
              }
              Navigator.pop(context); // Diyaloğu kapat
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // DÜZENLEME (EDIT) ÖZELLİĞİ
  void _editTask(int index) {
    String updatedTask = _tasks[index]['title'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Görevi Düzenle'),
          content: TextField(
            controller: TextEditingController(text: _tasks[index]['title']),
            onChanged: (value) {
              updatedTask = value;
            },
            decoration: const InputDecoration(hintText: 'Yeni görev adı'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // İptal
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (updatedTask.isNotEmpty) {
                  setState(() {
                    _tasks[index]['title'] =
                        updatedTask; // Görev başlığını güncelle
                  });
                  Navigator.pop(context); // Diyaloğu kapat
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
                  onPressed: () => _editTask(index), // Düzenleme butonu
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
