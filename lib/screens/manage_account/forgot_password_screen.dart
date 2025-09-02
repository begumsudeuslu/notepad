// forgot_password.dart
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // E-posta giriş alanının kontrolcüsü
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // Şifre sıfırlama işlemini simüle eden fonksiyon
  void _handlePasswordReset() async {
    final String email = _emailController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthController>(
        context,
        listen: false,
      ).resetPassword(_emailController.text);

      // başarılı olursa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifre sıfırlama linki e-posta adresinize gönderildi!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("E-postanız veya şifreniz yanlış!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        title: const Text(
          'Şifremi Unuttum',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 166, 128, 199),
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
            const Icon(
              Icons.lock_reset_outlined,
              size: 100,
              color: Color(0xFFC3A5DE),
            ),
            const SizedBox(height: 10),

            const Text(
              'Şifrenizi Sıfırlayın',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC3A5DE),
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
              onPressed: _isLoading ? null : _handlePasswordReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 173, 134, 207),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Şifremi Sıfırla'),
            ),
          ],
        ),
      ),
    );
  }
}