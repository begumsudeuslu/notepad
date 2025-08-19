class Task {
  final int? id;
  final String title;
  final String? description;
  final bool isDone;
  final int createdAt;
  final String color; // Bu da eksik olabilir dikkat

  Task({
    this.id,
    required this.title,
    this.description,
    required this.isDone,
    required this.createdAt,
    required this.color,
  });

  // Gerekirse nesneyi kopyalamak için
  Task copy({
    int? id,
    String? title,
    String? description,
    bool? isDone,
    int? createdAt,
    String? color,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    isDone: isDone ?? this.isDone,
    createdAt: createdAt ?? this.createdAt,
    color: color ?? this.color,
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
    };
  }

  // MAP'TEN NESNEYE DÖNÜŞTÜR
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
      createdAt: map['createdAt'],
      color: map['color'],
    );
  }
}
