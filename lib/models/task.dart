class Task {
  final int? id;
  final String title;
  final String? description;
  final bool isDone;
  final int createdAt;
  final String? color; // Bu da eksik olabilir dikkat
  final DateTime date; // takvim için date eklendi

  Task({
    this.id,
    required this.title,
    this.description,
    required this.isDone,
    int? createdAt,
    this.color,
    DateTime? date,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
       date = date ?? DateTime.now(); // null ise şimdiye ayarla

  @override
  String toString() {
    return 'Task(id: $id, title: $title, desc: $description, isDone: $isDone, createdAt: $createdAt, color: $color, date: $date)';
  }

  // Gerekirse nesneyi kopyalamak için
  Task copy({
    int? id,
    String? title,
    String? description,
    bool? isDone,
    int? createdAt,
    String? color,
    DateTime? date,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    isDone: isDone ?? this.isDone,
    createdAt: createdAt ?? this.createdAt,
    color: color ?? this.color,
    date: date ?? this.date,
  );

  // MAP'E ÇEVİR
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0, // SQLite bool desteklemez, int kullanılır
      'createdAt': createdAt,
      'color': color,
      'date': date.millisecondsSinceEpoch,
    };
  }

  // MAP'TEN NESNEYE DÖNÜŞTÜR
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
      createdAt: map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      color: map['color'],
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : DateTime.now(),
    );
  }
}
