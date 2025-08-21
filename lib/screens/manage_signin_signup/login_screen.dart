// login_screen.dart
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Giriş işlemini simüle eder.
  void _handleLogin() {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen e-posta ve şifrenizi girin."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // burada kimlik kontrolü yaplmalı normalde, database'den gelenlerle
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Giriş işlemi başarılı (simülasyon)"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  // forgot_password
  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  // register
  void _goToRegister() {
    Navigator.push(
      context,
      // Yeni oluşturduğumuz RegisterScreen'e yönlendiriyoruz.
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giriş Yap',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // AppBar rengini tatlı mor yapıyoruz
        backgroundColor: const Color(0xFFC3A5DE),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Uygulama Logosu veya Simgesi
            const Icon(
              Icons.lock_person_outlined,
              size: 100,
              color: Color(0xFFC3A5DE),
            ),
            const SizedBox(height: 10),

            // Başlık
            const Text(
              'Hesabınıza Giriş Yapın',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC3A5DE),
              ),
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
            const SizedBox(height: 15),

            // Şifre Girişi
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // Şifremi Unuttum Butonu
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _goToForgotPassword,
                child: const Text(
                  'Şifremi Unuttum?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Giriş Yap Butonu
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC3A5DE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Giriş Yap'),
            ),
            const SizedBox(height: 20),

            // Kayıt Ol Butonu
            TextButton(
              onPressed: _goToRegister,
              child: const Text(
                "Hesabın yok mu? Kayıt ol",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
