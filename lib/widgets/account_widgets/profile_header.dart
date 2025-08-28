import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    return Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 230, 254),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color.fromARGB(255, 233, 192, 245),
            child: const Icon(
              Icons.person,
              size: 40,
              color:  Color.fromARGB(255, 149, 21, 192),
            ),
            //daha sonrasında profil iconu yerine fotoğraf konulabilir
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auth.isLoggedIn
                    ? "Merhaba, ${auth.username}!"
                    : "Hoş Geldiniz!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ), // FontWeight bir enum değeri o yüzden const olur
              ),

              if (auth.isLoggedIn)
                Text(
                  auth.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
