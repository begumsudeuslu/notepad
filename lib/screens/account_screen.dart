import 'package:flutter/material.dart';
import 'package:notepad/widgets/account_widgets/account_info_section.dart';
import 'package:notepad/widgets/account_widgets/account_settings_section.dart';
import 'package:notepad/widgets/account_widgets/app_settings_section.dart';
import 'package:notepad/widgets/account_widgets/login_registration_section.dart';
import 'package:notepad/widgets/account_widgets/stats_section.dart';
import 'package:provider/provider.dart';
import '../screens/note_screen.dart';
import '../screens/tasks_screen.dart';
import 'manage_account/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/account_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/account_widgets/profile_header.dart';
import 'package:notepad/widgets/account_widgets/change_password_section.dart';
import 'package:notepad/widgets/account_widgets/logout_button.dart';

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
  void _updateAccountInfo(BuildContext context, AuthController auth) {
    // print("Hesap bilgileri güncelleniyor..");
    String newUsername = auth.username;

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
                  subtitle: Text(auth.email),
                  leading: const Icon(Icons.email),
                ),
                const SizedBox(height: 20),
                // Kullanıcı adı için düzenlenebilir alan
                TextFormField(
                  initialValue: auth.username,
                  decoration: const InputDecoration(
                    labelText: "Kullanıcı Adı",
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
                if (newUsername.isNotEmpty && newUsername != auth.username) {
                  auth.updateUsername(newUsername);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Kullanıcı adı güncellendi!")),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // şifre değiştirme
  void _changePassword(BuildContext context, AuthController auth) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    //normalde database'den alınmalı
    const String correctOldPassword = "123";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Şifre Değiştir"),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: oldPasswordController,
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
                    controller: newPasswordController,
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
                    controller: confirmPasswordController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lütfen yeni şifrenizi tekrar girin.";
                      }
                      if (value != newPasswordController.text) {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 166, 128, 199),
              ),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 166, 128, 199),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // şifreyi başarıyla değiştirdiği simülasyon

                  try {
                    await auth.changePassword(
                      oldPasswordController.text,
                      newPasswordController.text,
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Şifreniz başarıyla değiştirildi!"),
                        backgroundColor: Colors.green,
                      ),
                    ); // database güncellenmeli
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  // uygulama ayarlarını güncelle
  void _openAppSettings(BuildContext context, AccountController account) {
    // print("uygulama ayarlarını düzenle...")

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uygulama Ayarları"),
          content: Consumer<AccountController>(
            builder: (context, accountController, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bildirimleri Etkinleştir",
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: accountController.enableNotifications,
                        onChanged: (bool value) async {
                          await accountController.toggleNotifications(value);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
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
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final account = Provider.of<AccountController>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.isLoggedIn) {
        account.loadProductivityStats();
      } else {
        account.resetStats();
      }
      account.loadNotificationSetting();
    });

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
            const ProfileHeader(),
            const SizedBox(height: 10),

            // hesap bilgileri ya da login registration
            if (auth.isLoggedIn) ...[
              const AccountInfoSection(),

              const SizedBox(height: 10),

              const StatsSection(),

              const SizedBox(height: 10),

              AccountSettingsSection(
                auth: auth,
                onUpdateAccountInfo: _updateAccountInfo,
              ),

              const SizedBox(height: 10),

              ChangePasswordSection(
                auth: auth,
                onChangePassword: _changePassword,
              ),

              const SizedBox(height: 10),
            ] else ...[
              LoginRegistrationSection(
                onHandleLoginRegistration: _handleLoginRegistration,
              ),

              const SizedBox(height: 10),
            ],

            AppSettingsSection(
              account: account,
              onOpenAppSettings: _openAppSettings,
            ),
            const SizedBox(height: 10),

            // Çıkış yap butonu
            if (auth.isLoggedIn)
              LogoutButton(auth: auth)
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
