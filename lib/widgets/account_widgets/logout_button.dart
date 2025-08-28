import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class LogoutButton extends StatelessWidget {
  final AuthController auth;

  const LogoutButton({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => auth.logout(),
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
}
