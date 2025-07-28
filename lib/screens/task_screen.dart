import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  TasksScreenState createState() => TasksScreenState();
}

class TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimationController;
  late AnimationController _listAnimationController;
  String _searchQuery = '';
  String _sortBy = 'created'; // created, alphabetical, priority
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fabAnimationController.forward();
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _listAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void addTask() {
    _showAddTaskDialog();
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String priority = 'Orta';
    Color selectedColor = Colors.blue;

    final List<Color> taskColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.add_task, color: selectedColor, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Yeni Görev Oluştur',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık girişi
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Görev Başlığı *',
                    hintText: 'Görevinizi buraya yazın...',
                    prefixIcon: const Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: selectedColor, width: 2),
                    ),
                  ),
                  maxLength: 50,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),

                // Açıklama girişi
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Açıklama (İsteğe bağlı)',
                    hintText: 'Görev detaylarını ekleyin...',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: selectedColor, width: 2),
                    ),
                  ),
                  maxLines: 3,
                  maxLength: 200,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),

                // Öncelik seçimi
                const Text(
                  'Öncelik Seviyesi:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Yüksek',
                      child: Row(
                        children: [
                          Icon(
                            Icons.priority_high,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text('Yüksek Öncelik'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Orta',
                      child: Row(
                        children: [
                          Icon(Icons.remove, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          const Text('Orta Öncelik'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Düşük',
                      child: Row(
                        children: [
                          Icon(
                            Icons.low_priority,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text('Düşük Öncelik'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      priority = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Renk seçimi
                const Text(
                  'Görev Rengi:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: taskColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.black54
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('İptal'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  setState(() {
                    _tasks.add({
                      'title': titleController.text.trim(),
                      'description': descriptionController.text.trim(),
                      'done': false,
                      'priority': priority,
                      'color': selectedColor.value,
                      'createdAt': DateTime.now(),
                      'id': DateTime.now().millisecondsSinceEpoch,
                    });
                  });
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                  _showSnackBar(
                    'Görev başarıyla eklendi! 🎉',
                    Icons.check_circle,
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Kaydet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
      _tasks[index]['completedAt'] = _tasks[index]['done']
          ? DateTime.now()
          : null;
    });

    HapticFeedback.lightImpact();

    if (_tasks[index]['done']) {
      _showSnackBar('Görev tamamlandı! 🎊', Icons.celebration);
    } else {
      _showSnackBar('Görev tekrar aktif edildi', Icons.refresh);
    }
  }

  void _deleteTask(int index) {
    final task = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('${task['title']} silindi')),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'Geri Al',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _tasks.insert(index, task);
            });
          },
        ),
      ),
    );
  }

  void _showSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTaskDetails(Map<String, dynamic> task, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Color(task['color']),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task['description'] != null &&
                task['description'].isNotEmpty) ...[
              const Text(
                'Açıklama:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(task['description']),
              const SizedBox(height: 16),
            ],

            Row(
              children: [
                Icon(
                  task['priority'] == 'Yüksek'
                      ? Icons.priority_high
                      : task['priority'] == 'Orta'
                      ? Icons.remove
                      : Icons.low_priority,
                  color: task['priority'] == 'Yüksek'
                      ? Colors.red
                      : task['priority'] == 'Orta'
                      ? Colors.orange
                      : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text('${task['priority']} Öncelik'),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  task['done']
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task['done'] ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(task['done'] ? 'Tamamlandı' : 'Devam ediyor'),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Oluşturulma: ${_formatDate(task['createdAt'])}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            if (task['completedAt'] != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.done, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Tamamlandı: ${_formatDate(task['completedAt'])}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _toggleTask(index);
            },
            icon: Icon(task['done'] ? Icons.refresh : Icons.check),
            label: Text(task['done'] ? 'Yeniden Aç' : 'Tamamla'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _deleteTask(index);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  List<Map<String, dynamic>> get _filteredTasks {
    List<Map<String, dynamic>> filtered = _tasks.where((task) {
      if (!_showCompleted && task['done']) return false;
      if (_searchQuery.isEmpty) return true;
      return task['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (task['description'] ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();

    // Sıralama
    switch (_sortBy) {
      case 'alphabetical':
        filtered.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      case 'priority':
        final priorityOrder = {'Yüksek': 0, 'Orta': 1, 'Düşük': 2};
        filtered.sort((a, b) {
          int priorityA = priorityOrder[a['priority']] ?? 3;
          int priorityB = priorityOrder[b['priority']] ?? 3;
          return priorityA.compareTo(priorityB);
        });
        break;
      default: // created
        filtered.sort(
          (a, b) => (b['createdAt'] as DateTime).compareTo(
            a['createdAt'] as DateTime,
          ),
        );
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Column(
      children: [
        // Arama ve filtre çubuğu
        Container(
          padding: const EdgeInsets.all(16),
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
              // Arama çubuğu
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Görevlerde ara...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
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
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Filtre ve sıralama seçenekleri
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sortBy,
                      decoration: InputDecoration(
                        labelText: 'Sırala',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'created',
                          child: Text('Oluşturulma Tarihi'),
                        ),
                        DropdownMenuItem(
                          value: 'alphabetical',
                          child: Text('Alfabetik'),
                        ),
                        DropdownMenuItem(
                          value: 'priority',
                          child: Text('Öncelik'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilterChip(
                    label: Text(_showCompleted ? 'Tümü' : 'Aktif'),
                    selected: !_showCompleted,
                    onSelected: (selected) {
                      setState(() {
                        _showCompleted = !selected;
                      });
                    },
                    avatar: Icon(
                      _showCompleted ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // İstatistikler
        if (_tasks.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.purple[50]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Toplam',
                  _tasks.length.toString(),
                  Icons.list_alt,
                ),
                _buildStatItem(
                  'Tamamlanan',
                  _tasks.where((t) => t['done']).length.toString(),
                  Icons.check_circle,
                ),
                _buildStatItem(
                  'Devam Eden',
                  _tasks.where((t) => !t['done']).length.toString(),
                  Icons.pending,
                ),
              ],
            ),
          ),

        // Görev listesi
        Expanded(
          child: filteredTasks.isEmpty
              ? _buildEmptyState()
              : AnimatedBuilder(
                  animation: _listAnimationController,
                  builder: (context, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final originalIndex = _tasks.indexOf(task);

                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          curve: Curves.easeOutBack,
                          child: SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _listAnimationController,
                                    curve: Interval(
                                      index * 0.1,
                                      1.0,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                                ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      task['color'],
                                    ).withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  onTap: () =>
                                      _showTaskDetails(task, originalIndex),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Color(task['color']),
                                        width: 2,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                _toggleTask(originalIndex),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: task['done']
                                                    ? Color(task['color'])
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: Color(task['color']),
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: task['done']
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 18,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        task['title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: task['done']
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: task['done']
                                              ? Colors.grey[600]
                                              : null,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (task['description'] != null &&
                                              task['description']
                                                  .isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              task['description'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      task['priority'] ==
                                                          'Yüksek'
                                                      ? Colors.red[100]
                                                      : task['priority'] ==
                                                            'Orta'
                                                      ? Colors.orange[100]
                                                      : Colors.green[100],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  task['priority'],
                                                  style: TextStyle(
                                                    color:
                                                        task['priority'] ==
                                                            'Yüksek'
                                                        ? Colors.red[700]
                                                        : task['priority'] ==
                                                              'Orta'
                                                        ? Colors.orange[700]
                                                        : Colors.green[700],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _formatDate(task['createdAt']),
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        color: Colors.red[400],
                                        onPressed: () =>
                                            _deleteTask(originalIndex),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[600], size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[300]!, Colors.purple[300]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.note_add, size: 60, color: Colors.white),
          ),
          const SizedBox(height: 24),
          const Text(
            'Notlarınızı Oluşturun!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Aramanızla eşleşen görev bulunamadı.'
                : 'Henüz hiç görev yok.\n+ simgesine tıklayarak ilk görevinizi ekleyin.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (_searchQuery.isEmpty)
            ElevatedButton.icon(
              onPressed: addTask,
              icon: const Icon(Icons.add),
              label: const Text('İlk Görevi Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
