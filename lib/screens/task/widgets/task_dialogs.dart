// import 'package:flutter/material.dart';
// import 'package:notepad/databases/database.dart';
// import 'package:notepad/models/task.dart';
// import 'color_circle.dart';

// Future<void> showAddTaskDialog(
//   BuildContext context,
//   DateTime selectedDate,
//   VoidCallback onTaskAdded,
// ) {
//   String newTitle = '';
//   String selectedColor = 'white';

//   return showDialog(
//     context: context,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setStateDialog) => AlertDialog(
//         title: const Text('Yeni Görev Ekle'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               autofocus: true,
//               onChanged: (v) => newTitle = v,
//               decoration: const InputDecoration(
//                 hintText: 'Görev adı',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ColorCircle(
//                   color: Colors.red,
//                   value: 'red',
//                   selected: selectedColor,
//                   onSelect: (c) => setStateDialog(() => selectedColor = c),
//                 ),
//                 ColorCircle(
//                   color: Colors.yellow,
//                   value: 'yellow',
//                   selected: selectedColor,
//                   onSelect: (c) => setStateDialog(() => selectedColor = c),
//                 ),
//                 ColorCircle(
//                   color: Colors.green,
//                   value: 'green',
//                   selected: selectedColor,
//                   onSelect: (c) => setStateDialog(() => selectedColor = c),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('İptal'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (newTitle.trim().isEmpty) return;
//               final task = Task(
//                 title: newTitle.trim(),
//                 description: '',
//                 isDone: false,
//                 createdAt: DateTime.now().millisecondsSinceEpoch,
//                 date: selectedDate,
//                 color: selectedColor,
//               );
//               await NotePadDatabase.instance.createTask(task);
//               if (context.mounted) Navigator.pop(context);
//               onTaskAdded();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade500,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Kaydet'),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Future<void> showEditTaskDialog(
//   BuildContext context,
//   Task task,
//   VoidCallback onTaskEdited,
// ) {
//   String updatedTitle = task.title;
//   String selectedColor = task.color ?? 'white';
//   final TextEditingController titleCtrl = TextEditingController(
//     text: task.title,
//   );

//   return showDialog(
//     context: context,
//     builder: (context) => StatefulBuilder(
//       builder: (context, setStateDialog) => AlertDialog(
//         title: const Text('Görevi Düzenle'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleCtrl,
//               autofocus: true,
//               onChanged: (v) => updatedTitle = v,
//               decoration: const InputDecoration(
//                 hintText: 'Yeni görev adı',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ColorCircle(
//                   color: Colors.red,
//                   value: 'red',
//                   selected: selectedColor,
//                   onSelect: (c) => setStateDialog(() => selectedColor = c),
//                 ),
//                 ColorCircle(
//                   color: Colors.yellow,
//                   value: 'yellow',
//                   selected: selectedColor,
//                   onSelect: (c) => setStateDialog(() => selectedColor = c),
//                 ),
//                 ColorCircle(
//                   color: Colors.green,
//                   value: 'green',
//                   selected: selectedColor,
//                   onSelect: (c) => setStateDialog(() => selectedColor = c),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('İptal'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (updatedTitle.trim().isEmpty) return;
//               final updated = task.copy(
//                 title: updatedTitle.trim(),
//                 color: selectedColor,
//               );
//               await NotePadDatabase.instance.updateTask(updated);
//               if (context.mounted) Navigator.pop(context);
//               onTaskEdited();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade500,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Kaydet'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
