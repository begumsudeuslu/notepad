import 'package:flutter/material.dart';
import 'package:notepad/databases/database.dart';
import 'package:notepad/screens/note_screen/note_screen.dart';
import 'package:notepad/screens/task_screen/tasks_screen.dart';
import 'manage_signin_signup/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ilk olarak giriş yapılmadığını varsayalım
  bool _isLoggedIn = false;
  bool _enableNotifications = true;

  String _username = "Misafir Kullanıcı";
  String _email = "misafir@example.com";

  int _notesCount = 0;
  int _tasksCount = 0;
  int _completedTasksCount = 0;

  ///ileriki adımlarda kullanıcının giriş durumunu kontrol edebilirsiniz
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // database ihtiyacı, eğer login yapılmadığı durumu test etmek isteniliyorsa yorum satırına alınacak
    if (_isLoggedIn) {
      _loadProductivityStats();
    }
    _loadNotificationSetting();
  }

  // kimlik kontrolü burada yapılacak, kullanıcı giriş kontrolü database'den alınan verilerle olacak
  void _checkLoginStatus() {
    setState(() {
      // setState ile değiştir
      _isLoggedIn = true; // giriş yapıldığını varsayalım
      _username = "Flutter Server";
      _email = "flutter.server@example.com";
    });
  }

  void _loadProductivityStats() async {
    // Gerçek bir uygulamada burada veritabanından veya bir API'den veriler çekilir.

    // Şimdilik sabit değerler atayalım.
    setState(() {
      _notesCount = 12;
      _tasksCount = 5;
      _completedTasksCount = 3;
    });
  }

  void _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Eğer daha önce kaydedilmiş bir değer varsa onu yükle, yoksa true olarak başlat.
      _enableNotifications = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  // hesap bilgilerin güncellemek için
  void _updateAccountInfo() {
    // print("Hesap bilgileri güncelleniyor..");
    String newUsername =
        _username; // Yeni kullanıcı adını tutacak geçici değişken

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hesap Bilgilerini Düzenle"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Mevcut e-posta adresi (düzenlenemez)
                ListTile(
                  title: const Text("E-posta Adresi"),
                  subtitle: Text(_email),
                  leading: const Icon(Icons.email),
                ),
                const SizedBox(height: 20),
                // Kullanıcı adı için düzenlenebilir alan
                TextFormField(
                  initialValue: _username,
                  decoration: const InputDecoration(
                    labelText: "Yeni Kullanıcı Adı",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: Color(0xFFC3A5DE)),
                  ),
                  onChanged: (value) {
                    newUsername = value; // Değişiklikleri yakala
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Kaydet"),
              onPressed: () {
                setState(() {
                  _username = newUsername.isNotEmpty
                      ? newUsername
                      : _username; // Boş değilse güncelle
                });
                Navigator.of(context).pop(); // Diyalogu kapat
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kullanıcı adı başarıyla güncellendi!"),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // şifre değiştirme
  void _changePassword() {
    // print("şifre değişiriliyor..")
    final _formKey = GlobalKey<FormState>();

    // databaseden gelenlerle gidenler..
    String oldPassword = '';
    String newPassword = '';
    String confirmNewPassword = '';

    // normalde databaseden gelmeli
    const String correctOldPassword = "123";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Şifre Değiştir"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Mevcut Şifre",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) => oldPassword = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lütfen mevcut şifrenizi girin.";
                      }
                      // sadece simülasyon
                      if (value != correctOldPassword) {
                        return "Mevcut şifreniz yanlış.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Yeni Şifre",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) => newPassword = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lütfen yeni şifrenizi girin.";
                      }
                      if (value.length < 6) {
                        return "Şifre en az 6 karakter olmalı.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Yeni Şifreyi Doğrula",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_person),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) => confirmNewPassword = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lütfen yeni şifrenizi tekrar girin.";
                      }
                      if (value != newPassword) {
                        return "Şifreler uyuşmuyor.";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Kaydet"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Şifreler başarıyla güncellendiğinde yapılacaklar.
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Şifreniz başarıyla değiştirildi!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // database güncellenmeli
                }
              },
            ),
          ],
        );
      },
    );
  }

  // uygulama ayarlarını güncelle
  void _openAppSettings() {
    // print("uygulama ayarlarını düzenle...")

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uygulama Ayarları"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Bildirimleri Etkinleştir",
                    style: TextStyle(fontSize: 16),
                  ),
                  StatefulBuilder(
                    builder:
                        (BuildContext context, StateSetter setStateInDialog) {
                          return Switch(
                            value: _enableNotifications,
                            onChanged: (bool value) async {
                              // Sadece diyalog içindeki state'i güncelle
                              setStateInDialog(() {
                                _enableNotifications = value;
                              });

                              // shared_preferences'a yeni değeri kaydet
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool(
                                'notifications_enabled',
                                value,
                              );
                            },
                          );
                        },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// giriş yapıldığında kullanılacak fonksiyon
  void _handleLoginRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Giriş yapıldı/Kayıt olundu (ama simülasyonda)"),
      ),
    );
  }

  /// çıkış yapıldığında kullanılacak fonksiyon
  void _handleLogOut() {
    // print("Çıkış yapılıyor");
    setState(() {
      _isLoggedIn = false;
      _username = "Misafir Kullanıcı";
      _email = "misafir@example.com";
      _notesCount = 0;
      _tasksCount = 0;
      _completedTasksCount = 0;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Hesaptan çıkış yapıldı!")));
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 230, 254),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color.fromARGB(255, 233, 192, 245),
            child: Icon(
              Icons.person,
              size: 40,
              color: const Color.fromARGB(255, 149, 21, 192),
            ),
            //daha sonrasında profil iconu yerine fotoğraf konulabilir
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isLoggedIn ? "Merhaba, $_username!" : "Hoş Geldiniz!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ), // FontWeight bir enum değeri o yüzden const olur
              ),

              if (_isLoggedIn)
                Text(
                  _email,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hesap Bilgileri",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const Divider(height: 20, thickness: 1),

            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: Color.fromARGB(255, 166, 128, 199),
              ),
              title: const Text("Kullanıcı adı"),
              subtitle: Text(_username),
              horizontalTitleGap: 10.0,
            ),

            ListTile(
              leading: const Icon(
                Icons.email_outlined,
                color: Color.fromARGB(255, 166, 128, 199),
              ),
              title: const Text("E-posta adresi"),
              subtitle: Text(_email),
              horizontalTitleGap: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft, // sola hizalamak için
              child: const Text(
                "Hesap Ayarları",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // textAlign: TextAlign.start işe yaramadı hala sola yatık olacak kadar baskın değil
              ),
            ),

            const Divider(height: 20, thickness: 1),

            ListTile(
              leading: const Icon(Icons.edit, color: Colors.green),
              title: const Text("Hesap Bilgilerini Güncelle"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _updateAccountInfo,
              horizontalTitleGap: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordManagementSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Şifre Yönetimi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),

            const Divider(height: 20, thickness: 1),

            ListTile(
              leading: const Icon(
                Icons.vpn_key_off_outlined,
                color: Colors.orange,
              ),
              title: const Text("Şifreyi değiştir"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _changePassword,
              horizontalTitleGap: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Uygulama Ayarları",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),

            const Divider(height: 20, thickness: 1),

            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: Colors.purple,
              ),
              title: const Text("Genel Ayarlar"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _openAppSettings,
              horizontalTitleGap: 10.0,
            ),
            // buraya bildirim ayarları, tema vs vs eklenecek
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRegistrationSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Hesabınıza giriş yapın veya yeni bir hesap oluşturun.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _handleLoginRegistration,
              icon: const Icon(Icons.login),
              label: const Text("Giriş Yap/ Kayıt Ol"),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _handleLogOut,
        icon: const Icon(Icons.logout),
        label: const Text("Çıkış Yap"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          minimumSize: const Size(160, 40), // buton boyutu
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hesap İstatistikleri",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.notes,
                  label: "Notlar",
                  count: _notesCount,
                  color: Color.fromARGB(255, 166, 128, 199),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NoteScreen()),
                    );
                  },
                ),
                _buildStatItem(
                  icon: Icons.assignment_outlined,
                  label: "Görevler",
                  count: _tasksCount,
                  color: Color.fromARGB(255, 166, 128, 199),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TasksScreen()),
                    );
                  },
                ),
                _buildStatItem(
                  icon: Icons.check_circle_outline,
                  label: "Tamamlanan",
                  count: _completedTasksCount,
                  color: Color.fromARGB(255, 166, 128, 199),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TasksScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 230, 240, 255),
            radius: 30,
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hesabım',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 166, 128, 199),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // kullanıcı adı ve profil alanı
            _buildProfileHeader(),
            const SizedBox(height: 10),

            // hesap bilgileri ya da login registration
            if (_isLoggedIn)
              _buildAccountInfoSection()
            else
              _buildLoginRegistrationSection(),
            const SizedBox(height: 10),

            if (_isLoggedIn) _buildStatsSection() else const SizedBox.shrink(),
            const SizedBox(height: 10),

            // open the account setting section, if user is logged in
            if (_isLoggedIn)
              _buildAccountSettingSection()
            else
              const SizedBox.shrink(), //shrink() gizlemek için kullanılır
            const SizedBox(height: 10),

            // password management section
            if (_isLoggedIn)
              _buildPasswordManagementSection()
            else
              const SizedBox.shrink(),
            const SizedBox(height: 10),

            // app settings section
            _buildAppSettingsSection(),
            const SizedBox(height: 10),

            // logout section
            if (_isLoggedIn) _buildLogoutButton() else const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
