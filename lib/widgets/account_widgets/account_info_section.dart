import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

class AccountInfoSection extends StatelessWidget{
  const AccountInfoSection ({super.key});

  @override
  Widget build(BuildContext context)  {
    final auth = Provider.of<AuthController>(context);

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
              subtitle: Text(auth.username),
              horizontalTitleGap: 10.0,
            ),

            ListTile(
              leading: const Icon(
                Icons.email_outlined,
                color: Color.fromARGB(255, 166, 128, 199),
              ),
              title: const Text("E-posta adresi"),
              subtitle: Text(auth.email),
              horizontalTitleGap: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}