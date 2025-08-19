// forgot_password.dart
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // E-posta giriş alanının kontrolcüsü
  final TextEditingController _emailController = TextEditingController();

  // Şifre sıfırlama işlemini simüle eden fonksiyon
  void _handlePasswordReset() {
    final String email = _emailController.text;

    // Basit bir boş alan kontrolü
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen e-posta adresinizi girin."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Şimdilik başarılı bir simülasyon mesajı gösterildi ve ekran kapatıldı
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Şifre sıfırlama linki e-posta adresinize gönderildi!"),
        backgroundColor: Colors.green,
      ),
    );

    // İşlem tamamlandıktan sonra bir önceki ekrana geri dönüyoruz.
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
        centerTitle: false,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.lock_reset_outlined,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),

            const Text(
              'Şifrenizi Sıfırlayın',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Şifrenizi sıfırlamak için hesabınıza bağlı e-posta adresini girin.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // E-posta Girişi
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                hintText: 'ornek@mail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Şifremi Sıfırla Butonu
            ElevatedButton(
              onPressed: _handlePasswordReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Şifremi Sıfırla'),
            ),
          ],
        ),
      ),
    );
  }
}
