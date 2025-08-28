import 'package:flutter/material.dart';
import 'package:notepad/controllers/task_controller.dart';
import 'package:notepad/models/task.dart';
import 'package:provider/provider.dart';
import 'task_list_view.dart';

class TaskListSection extends StatelessWidget {
  // onEditTask parametresini burada tanımlıyoruz
  final Function(int) onEditTask;

  const TaskListSection({super.key, required this.onEditTask});

  @override
  Widget build(BuildContext context) {
    // Controller'a erişmek için zaten TasksScreen'de Consumer kullanıldığı için burada gerek yok
    final controller = Provider.of<TaskController>(context);
    final filtered = controller.filteredTasks;

    // Liste boşsa bu mesajı gösterir
    if (filtered.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
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
      );
    }

    // Liste boş değilse, TaskListView'ı döndürür ve parametreleri doğru şekilde iletir
    return TaskListView(
      filteredTasks: filtered,
      onToggleTask: (index) => controller.toggleTask(filtered[index]),
      onEditTask: onEditTask, // Parametreyi TaskListView'a iletiyor
      onDeleteTask: (index) => controller.deleteTask(filtered[index].id!),
    );
  }
}
