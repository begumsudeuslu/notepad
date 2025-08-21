import 'package:flutter/material.dart';
import 'package:notepad/databases/database.dart';
import 'package:notepad/models/task.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;
  late String _selectedColor;
  bool _setReminder = false;

  @override
  void initState() {
    super.initState();
    // Eğer bir görev düzenleniyorsa, mevcut verileri yükle
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description ?? '';
      _selectedDate = widget.taskToEdit!.date;
      _selectedTime = TimeOfDay.fromDateTime(widget.taskToEdit!.date);
      _selectedColor = widget.taskToEdit!.color ?? '8A2BE2';
    } else {
      // Yeni bir görev ekleniyorsa varsayılan değerleri ayarla
      _selectedDate = DateTime.now();
      _selectedColor = '8A2BE2';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Renk dairelerini oluşturan yardımcı metot
  Widget _buildColorCircle(String colorHex, ValueChanged<String> onSelected) {
    final color = Color(int.parse('0xFF$colorHex'));
    final isSelected = colorHex == _selectedColor;
    return GestureDetector(
      onTap: () {
        onSelected(colorHex);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
      ),
    );
  }

  void _saveTask() async {
    final newTitle = _titleController.text.trim();
    if (newTitle.isEmpty) return;

    if (widget.taskToEdit != null) {
      // Görevi güncelle
      final updatedTask = widget.taskToEdit!.copy(
        title: newTitle,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        color: _selectedColor,
      );
      await NotePadDatabase.instance.updateTask(updatedTask);
    } else {
      // Yeni görev oluştur
      final task = Task(
        title: newTitle,
        description: _descriptionController.text.trim(),
        isDone: false,
        date: _selectedDate,
        color: _selectedColor,
      );
      await NotePadDatabase.instance.createTask(task);
    }

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Görevi Düzenle' : 'Görev Ekle',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 166, 128, 199),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 166, 128, 199),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Kaydet'),
                  ),
                ],
              ),

              // const SizedBox(width: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Görev Başlığı',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Görev Açıklaması (isteğe bağlı)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 50),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  // Yeni eklenen Column
                  children: [
                    Row(
                      // Tarih satırı
                      children: [
                        Expanded(
                          child: Text(
                            'Tarih: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDate,
                          child: const Text('Tarih Seç'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ), // Tarih ve saat satırları arasına boşluk
                    Row(
                      // Saat satırı
                      children: [
                        Expanded(
                          child: Text(
                            'Saat: ${_selectedTime != null ? _selectedTime!.format(context) : 'Seçilmedi'}',
                          ),
                        ),
                        TextButton(
                          onPressed: _pickTime,
                          child: const Text('Saat Seç'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Önem Derecesini Belirle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildColorCircle(
                    'FF5733',
                    (color) => setState(() => _selectedColor = color),
                  ),
                  _buildColorCircle(
                    'FFBD33',
                    (color) => setState(() => _selectedColor = color),
                  ),
                  _buildColorCircle(
                    '33FF57',
                    (color) => setState(() => _selectedColor = color),
                  ),
                  _buildColorCircle(
                    '33B5FF',
                    (color) => setState(() => _selectedColor = color),
                  ),
                  _buildColorCircle(
                    'C3A5DE',
                    (color) => setState(() => _selectedColor = color),
                  ),
                  _buildColorCircle(
                    '8A2BE2',
                    (color) => setState(() => _selectedColor = color),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Hatırlatıcı Ekle'),
                  const Spacer(),
                  Switch(
                    value: _setReminder,
                    activeColor: const Color(0xFFC3A5DE),
                    onChanged: (val) {
                      setState(() {
                        _setReminder = val;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
