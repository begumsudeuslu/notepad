import 'package:flutter/material.dart';
import 'manage_account_screens/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ilk olarak giriş yapılmadığını varsayalım
  bool _isLoggedIn = false;
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

  void _loadProductivityStats() {
    // Gerçek bir uygulamada burada veritabanından veya bir API'den veriler çekilir.
    // Şimdilik sabit değerler atayalım.
    setState(() {
      _notesCount = 12;
      _tasksCount = 5;
      _completedTasksCount = 3;
    });
  }

  // hesap bilgilerin güncellemek için
  void _updateAccountInfo() {
    // print("Hesap bilgileri güncelleniyor..");
  }

  // şifre değiştirme
  void _changePassword() {
    // print("şifre değişiriliyor..")
  }

  // uygulama ayarlarını güncelle
  void _openAppSettings() {
    // print("uygulama ayarlarını düzenle...")
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
      // 👇 YENİ: Çıkış yapıldığında istatistikleri sıfırla.
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
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent.shade100,
            child: Icon(Icons.person, size: 40, color: Colors.blue.shade800),
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
              leading: const Icon(Icons.person_outline, color: Colors.blue),
              title: const Text("Kullanıcı adı"),
              subtitle: Text(_username),
              horizontalTitleGap: 10.0,
            ),

            ListTile(
              leading: const Icon(Icons.email_outlined, color: Colors.blue),
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
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.assignment_outlined,
                  label: "Görevler",
                  count: _tasksCount,
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.check_circle_outline,
                  label: "Tamamlanan",
                  count: _completedTasksCount,
                  color: Colors.blue,
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
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 230, 240, 255),
          radius: 30,
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesabım'),
        centerTitle: false,
        backgroundColor: Colors.blue,
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
