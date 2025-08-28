import 'package:flutter/material.dart';
import 'package:notepad/models/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Bir görevi görselleştirmek için kullanılan özelleştirilmiş bir widget'tır.
// StatelessWidget olduğu için kendi durumunu (state) tutmaz, sadece aldığı veriye göre arayüzü çizer.
class TaskCard extends StatelessWidget {
  // Görev verilerini içeren Task nesnesi
  final Task task;
  // Görevin tamamlanma durumunu değiştirmek için bir geri çağırma (callback) fonksiyonu
  final VoidCallback onToggle;
  // Görevi düzenleme diyaloğunu açmak için bir geri çağırma fonksiyonu
  final VoidCallback onEdit;
  // Görevi silme işlemi için bir geri çağırma fonksiyonu
  final VoidCallback onDelete;

  // Kurucu metot(contructor), gerekli verileri dışarıdan alır
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  // Bu metot, Task nesnesindeki renk adını (örneğin 'red') alıp,
  // karşılık gelen Flutter Color nesnesini döndürür.
  Color _getTaskColor(String? color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      // Yeni eklenen mor ve gri renkler
      case 'purple':
        return const Color(0xFFC3A5DE); // Tatlı mor rengi
      case 'gray':
        return const Color(0xFFCFCFCF); // Tatlı gri rengi
      default:
        return Colors.transparent; // Tanımlı bir renk yoksa şeffaf döner.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      // Card'ı Slidable widget'ı ile sarıyoruz.
      child: Slidable(
        key: ValueKey(task.id), // Her öğenin benzersiz bir anahtarı olmalı
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(),
              backgroundColor: const Color.fromARGB(255, 173, 134, 207),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Düzenle',
            ),
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: Color.fromARGB(255, 117, 116, 116),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Sil',
            ),
          ],
        ),
        child: Row(
          children: [
            // Kartın sol tarafına renkli bir bar ekliyoruz.
            Container(
              width: 8,
              height: 70,
              decoration: BoxDecoration(
                // _getTaskColor metodu ile dinamik renk ataması
                color: _getTaskColor(task.color),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            // Geri kalan alanı doldurmak için Expanded kullanıyoruz.
            Expanded(
              // Görev başlığını, checkbox'ı ve düzenleme ikonunu içeren ana liste elemanı
              child: ListTile(
                // İçerik boşluklarını ayarlıyoruz.
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                // Başlangıçta yuvarlak mor onay butonu ekliyoruz
                leading: InkWell(
                  onTap:
                      onToggle, // Tıklandığında onToggle fonksiyonunu çağırıyoruz
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isDone
                          ? const Color.fromARGB(
                              255,
                              173,
                              134,
                              207,
                            ) // Tamamlandıysa mor
                          : Colors.transparent, // Tamamlanmadıysa şeffaf
                      border: Border.all(
                        color: task.isDone
                            ? const Color.fromARGB(
                                255,
                                173,
                                134,
                                207,
                              ) // Tamamlandıysa mor
                            : Colors.grey, // Tamamlanmadıysa gri
                        width: 2,
                      ),
                    ),
                    child: task.isDone
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
                // Görev başlığını gösteren metin (Text) widget'ı.
                title: Text(
                  task.title, // Task nesnesinden başlığı alıyoruz.
                  // Metin stilini ayarlıyoruz.
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    // Görev tamamlandıysa üstünü çiziyoruz.
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
