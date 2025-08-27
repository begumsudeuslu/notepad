import 'package:flutter/material.dart';
import 'package:notepad/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // kontrolcüler
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // simüle eden function
  void _handleRegister() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthController>(context, listen: false).register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt işlemi başarılı (simülasyon)"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kayıt Ol ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // AppBar rengini tatlı mor yapıyoruz
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.person_add_alt_1_outlined,
              size: 100,
              color: Color(0xFFC3A5DE),
            ),
            const SizedBox(height: 10),

            const Text(
              'Yeni Hesap Oluştur',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC3A5DE),
              ),
            ),

            const SizedBox(height: 20),

            // Kullanıcı Adı Girişi
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Kullanıcı Adı',
                hintText: 'örn: mustafa_2024',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 173, 134, 207),
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 173, 134, 207),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // E-posta Girişi
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                hintText: 'ornek@mail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 173, 134, 207),
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 173, 134, 207),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 15),

            // Şifre Girişi
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 173, 134, 207),
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 173, 134, 207),
                ),
              ),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            // Kayıt Ol Butonu
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
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
                  : const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
