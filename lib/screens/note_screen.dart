import 'dart:collection';

import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  final VoidCallback? onAddNote;
  const NoteScreen({Key? key, this.onAddNote}) : super(key: key);

  @override
  NoteScreenState createState() { return NoteScreenState();}
}

class NoteScreenState extends State<NoteScreen> {
  bool _selectionMode = false;
  final List<String> _notes = [];
  final Set<int> _selectedNotes = {};
  int? _editingIndex; // Hangi notun düzenlendiğini tutar, int olabailir ama null da olabilir
  final TextEditingController _editingController = TextEditingController();


  /*Sayfayı çöpe atıyorsun ama içindeki bazı dosyalar hâlâ açık — dispose() onları kapatır.
  dispose() bir temizlik zamanıdır.
  Sayfa silinirken, içerideki özel şeylerin (controller gibi) kapatılmasını sağlar.
  Aksi takdirde uygulama yavaşlayabilir ya da hata verir.
  
  _editingController.dispose();
  Eğer bir TextEditingController kullanıyorsan, bu nesneyi elle kapatman gerekir.
  Aksi takdirde, Flutter onun hâlâ bellekte olduğunu zannedip sızıntı (leak) yapabilir.

  super.dispose();
  State sınıfının kendi içindeki dispose() mantığını da çalıştırır.
  Kendi temizliğini yaptıktan sonra, Flutter'ın da gerekli temizlikleri yapmasını sağlar.
  */
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }


  /**
   * setState(): ekranda bir şey değişti yeniden çiz
   * notes: notların içeriğini tutar
   */
  void addNoteFromExternal() {
    setState(() {
      _notes.add("Yeni not #${_notes.length + 1}");
    });
  }


  /**
   * _editingIndex!: bull-safety işareti, _editingIndex'in null olmadığına eminim (yukarıdaki if ile)
   */
  void _saveEditedNote() {
    if (_editingIndex != null) {   //şu an düzenlenen not olup olmadığına bakar
      setState(() {
        _notes[_editingIndex!] = _editingController.text;
        _editingIndex = null; // Düzenleme modundan çık
        _editingController.clear();     //her yzdığımız değişiklik ilk _editingControllerda olur aslında textEditingController sayesinde, bunu temizle ki yeni düzenleme eskiyi eklemesin
      });
    }
  }


  /**
   * seçilen note eğer zaten selectedNotestaysa yani önceden seçilmişse kaldır, değilse ekle
   * eğer selectedNotes boşsa ve selection_mode ona rağmen açıksa kapat(selection_mode is false) 
   */
  void _onSelectToggle(int index) {
    setState(() {
      if (_selectedNotes.contains(index)) {
        _selectedNotes.remove(index);
      } else {
        _selectedNotes.add(index);
      }
      if (_selectedNotes.isEmpty && _selectionMode) {
        _selectionMode = false;
      }
    });
  } 


  /**
   * uzun süre basıldığında selection modu açar ama avrsayalım ki bir notu düzenlerken başka bir nota uzun süre bastım, düzenlediğim notu kaydeder
   */
  void _onLongPress(int index) {
    if (_editingIndex != null) {
      _saveEditedNote(); // Düzenleme modundaysa kaydet
    }
    setState(() {   // güncelle
      if (!_selectionMode) {
        _selectionMode = true;
      }
      _onSelectToggle(index);
    });
  }

  /**
   * seçim modundan çıkar ve seçilen notları temizler
   */
  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedNotes.clear();
      _editingIndex = null; // Seçim modundan çıkınca düzenlemeyi de bitir
      _editingController.clear();
    });
  }


  /**
   * seçili notları sil
   */
  void _deleteSelectedNotes() {
    showDialog(       // ekrana küçük bir pencere açar
      context: context,
      builder: (context) => AlertDialog(   // alertDialog başlık, içerik ve iki düğme açar
        title: const Text("Notları Sil"),
        content: const Text("Seçilen notları silmek istediğinize emin misiniz?"),
        actions: [      // iki buton: evet, hayır
          TextButton(
            onPressed: () => Navigator.of(context).pop(),    // şu anki sayfayı yani diyalog kutusunu geri çeker/kapatır/siler
            child: const Text("Hayır"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final sortedIndexes = _selectedNotes.toList()..sort((a, b) => b.compareTo(a));   // seçilen indexleri büyükten küçüğe sırala ki silerken de sondan başa sil yoksa kayar
                for (var index in sortedIndexes) {    // seçilen her notu siler 
                  _notes.removeAt(index);
                }
                _selectedNotes.clear();
                _selectionMode = false;
                _editingIndex = null; // Silme işleminden sonra düzenlemeyi de bitir
                _editingController.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text("Evet", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  /**
   * notları düzenleme aşamasındaki yönlendirme
   */
  void _onNoteTap(int index) {
    if (_selectionMode) {   // eğer seçim modundaysa
      _onSelectToggle(index);   // ekle/kaldır
    } else {    //seçim modunda değilse
      setState(() {
        if (_editingIndex == index) {     // eğer tıkladığın index editlenmekte olan notun indexine eşitse yani aynı nota tıkladıysan
          // notu kaydet
          _saveEditedNote();
        } else {
          // Başka bir nota tıkladıysan önceki notu kaydet ve yeni tıkladığın notu düzenleme başla
          if (_editingIndex != null) {
            _saveEditedNote();
          }
          // Yeni notu düzenleme moduna al, artık editinIndex yeni index, en son onu düzenledik
          _editingIndex = index;
          _editingController.text = _notes[index];
        }
      });
    }
  }

  /**
   * herhangi bir not yoksa
   */
  Widget _buildEmptyNotesMessage()  {
    return Center(
      child: Text(
        'Henüz not yok. ➕ simgesine tıklayarak not ekleyebilirsin.',
        style: const TextStyle(fontSize: 18, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }

  /**
   * Her bir not kartını oluşturan fonksiyon
   */
  Widget _buildNoteCard(BuildContext context, int index, bool selected, bool isEditing) {
    return GestureDetector(
      onLongPress: () => _onLongPress(index),  // uzun basıllınca çoklu seçim moduna geçmek 
      onTap: () => _onNoteTap(index),    // tıklanırsa _oneNoteTap fonksyionu çağırılır, düzenleyebilirsin veya seçim modunda seçim yaparsın
      child: Card(     //notu gösteren kart
        elevation: isEditing ? 8 : 3, // Düzenlenirken daha belirgin olsun, gölgelendirme
        margin: const EdgeInsets.symmetric(vertical: 8),      // her not kartının arasına dikey olarak (üst ve alt) 8 piksel boşluk bırakır
        shape: RoundedRectangleBorder(   // şekil
          borderRadius: BorderRadius.circular(12),   // kartın köşelerini 12 birim yuvarlar, yumuşak kenar
          side: isEditing                                                  // düzenleniyora
            ? const BorderSide(color: Colors.blueAccent, width: 2)   // mavi kenarlı çerçeve
            : BorderSide.none,
        ),
        color: selected   // eğer selected ise (silme işlemi için): daha koyu mavi, eğer selected değil ama editleniyorsa (düzenleniyorsa): daha açık mavi, erğer hiçbiri yoksa: default (varsayılan) yani null
            ? Colors.blue.withOpacity(0.2)
            : (isEditing ? Colors.blue.withOpacity(0.1) : null),
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Not içeriğine ek boşluk
            child: isEditing
              ? _buildEditingNoteView() // Not düzenleme görünümü
              : _buildDisplayNoteView(index, selected), // Not görüntüleme görünümü
          ),
      ),
    );
  }


  /**
   * Not düzenleme modundayken gösterilecek görünümü oluşturan fonksiyon
   */
  Widget _buildEditingNoteView() {
    return Column(  // düzenleniyorsa
      crossAxisAlignment: CrossAxisAlignment.stretch,   /// alt elemanları yatayda tam genişliğe uzatır (özellikle buton için)
      children: [
        TextField(
          controller: _editingController,   // içerik kontrolü
          autofocus: true,   // düzenleme başladığında otomatik odaklanır, klavye açılır
          maxLines: null, // Sınırsız satır   // satır sınırı yok
          keyboardType: TextInputType.multiline,     // enter tuşuyla yeni satır geçişi
          decoration: const InputDecoration(    // kullanıcıya kılvauz metin
            hintText: 'Notunuzu buraya yazın...',
            border: InputBorder.none, // Sınırları kaldır, kenar çizgilerini gösterme
          ),
          style: const TextStyle(fontSize: 18),
          onSubmitted: (_) => _saveEditedNote(), // Enter'a basınca kaydet
        ),
        Align(    //kaydet butonunu sağ alta hizalamak için kullanılıyor
          alignment: Alignment.bottomRight,    // sağ alt
          child: ElevatedButton(    // amvi kaydet butonu
            onPressed: _saveEditedNote,     // tıklayınca kaydet
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Kaydet'),
          ),
        ),
      ],
    );
  }

  /**
   * Not görüntüleme modundayken gösterilecek görünümü oluşturan fonksiyon 
  */
  Widget _buildDisplayNoteView(int index, bool selected) {
    return ListTile(          // when isEditing is false, sadece görüntüle
      // leaading, title, trailing
      // leading: icon, avatar (en sağda)
      // title: ortadaki metin
      // trailing: en sağda gösterilen şey (genelde buton, icon, checkbox)
      title: Text(
        _notes[index],    // note metni ekrana yazılır
        style: const TextStyle(fontSize: 18),
      ),
      trailing: _selectionMode      // selection mode açık mı?
        ? Checkbox(       // açıksa checkboxu göster
          value: selected,
          onChanged: (_) => _onSelectToggle(index),
          shape: const CircleBorder(),
          activeColor: Colors.blue,
        )
        : null,   // slection mode açık değilse gösterme
    );
  }



  /**
   * Ana Not Listesi Oluşturucu
   */
  Widget _buildNotesList() {
    if (_notes.isEmpty) {     // herhangi bir not yoksa
      return _buildEmptyNotesMessage();
    }
    return GestureDetector(   // GestureDetector: kullanıcının dokunma hareketlerini algılar
      onTap: () {     // liste dışında bir yere dokunduğunda
        if (_selectionMode) {    // selection mod açıksa
          _exitSelectionMode();   //kapat
        } else if (_editingIndex != null) {     // notu editliyorsan
          _saveEditedNote(); //düzenlemeyi kaydet
        }
      },
      child: ListView.builder(    // listeyi oluşturu her notu sırayla aşağıdaki gibi çizmek için kullanılır
        padding: const EdgeInsets.all(12),   // alt, üst, sağ, sol 12 boşluk
        itemCount: _notes.length,    // kaç tane not varsa o kadar item çiz
        itemBuilder: (context, index) {   // her bir notun nasıl görüneceğini tanımlar
          final selected = _selectedNotes.contains(index);      // şu anki index seçim modunda seçili mi
          final isEditing = _editingIndex == index;          // şu anli index düzenleniyor mu

          return _buildNoteCard(context, index, selected, isEditing);
        },
      ),
    );
  }

  /**
   * Seçim modundayken gösterilecek AppBar'ı oluşturan fonksiyon
   */
  AppBar _buildSelectionModeAppBar() {
      return AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(   // sol köşede buton
          icon: const Icon(Icons.close),      // çık butonu
          onPressed: _exitSelectionMode,     // çık
        ),
        title: Text('${_selectedNotes.length} Seçildi'),
        actions: [      // butonlar
          IconButton(
            icon: const Icon(Icons.delete),    // delete iconu
            onPressed: _deleteSelectedNotes,   // basıldığında _deleteSelectedNotes
            tooltip: 'Sil',                   // tooltip, bir kullanıcının bir butonun (veya başka bir widget'ın) üzerine uzun basması ya da fareyle üzerine gelmesi durumunda
                                             // görünen küçük bilgi balonudur
          )
        ],
      );
    }

  /** 
   * Not düzenleme modundayken gösterilecek AppBar'ı oluşturan fonksiyon
  */
  AppBar _buildEditingModeAppBar() {
    return AppBar(
      // Düzenleme modundayken üst barı özelleştir, 
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.check), // sola kaydetme ikonu ekle
        onPressed: _saveEditedNote,     // tıkladığında _savedEditedNote fonksyionunu kaydet
        tooltip: 'Değişiklikleri Kaydet',
      ),
      title: const Text('Notu Düzenle'),
      actions: [        // buton ekle
        IconButton(
          icon: const Icon(Icons.cancel), // sağa iptal ikonu ekle 
          onPressed: () {   // bastığında
          setState(() {   // güncelle
            _editingIndex = null; // Düzenlemeyi iptal et
            _editingController.clear();    // controllero temizle
          });
        },
        tooltip: 'İptal Et',
        ),
      ],
    );
  }

  /**
   * Ana AppBar'ı duruma göre seçip döndüren fonksiyon 
  */
  AppBar? _buildAppBar() {
    if (_selectionMode) {    // appBar yani en üstteki bar duruma göre değişir, eğer selection mdoe açıksa
      return _buildSelectionModeAppBar();
    } else if (_editingIndex != null) {      // select mode açıksa ve index null değilse yani bir şeyler düzenleniyorsa
      return _buildEditingModeAppBar();
    }
    return null; // Ne seçim modu ne de düzenleme modu aktifse, varsayılan AppBar (boş)
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // AppBar'ı buradan alıyoruz
      body: _buildNotesList(),
    );
  }
}