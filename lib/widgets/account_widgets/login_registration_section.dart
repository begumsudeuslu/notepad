import 'package:flutter/material.dart';

class LoginRegistrationSection extends StatelessWidget {
  final void Function() onHandleLoginRegistration;

  const LoginRegistrationSection({
    super.key,
    required this.onHandleLoginRegistration,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: onHandleLoginRegistration,
              icon: const Icon(Icons.login),
              label: const Text("Giriş Yap/ Kayıt Ol"),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 170, 76, 201),
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
}
