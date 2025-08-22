// lib/models/note.dart

/// Noteları yapılandırmak için model sınıfı oluşturduk
class Note   {   
  int? id;    // yeni oluşturulan notların henüz idsi olmaz o yüzden int?
  String title;
  String content;
  DateTime createdAt;    // oluşturulduğu tarih
  DateTime? updatedAt;    // en son düzenlenen tarih

  // constructor, zorunlu olanlar belirtildi
  Note({this.id, required this.title, required this.content, required this.createdAt, this.updatedAt});

  // map structure to store and edit the notes style, as parts
  Map<String, dynamic> toMap()   {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt != null ? updatedAt!.millisecondsSinceEpoch : null,
    };
  }

  // databseden ya da ksondan gelen veriyi nesneye dönüştüren method: factroy
  factory Note.fromMap(Map<String, dynamic> map)   {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String, 
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int), 
      updatedAt: (map['updatedAt'] != null && map['updatedAt'] != 0) ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int) : null,
    );
  }

  /// copy methodu
  Note copy({int? id, String? title, String? content, DateTime? createdAt, DateTime? updatedAt}) 
    => Note(
      id:id ?? this.id,     // ?? bu yapı null operatörü kontrolü imiş..
      title:title?? this.title,     // eğer sol taraf null ise sağ tarafı kullan
      content: content ?? this.content,   // teni varsa yeniyi yoksa eskiyi kullan
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      );


  @override
  String toString()   {
    return 'Note {id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}