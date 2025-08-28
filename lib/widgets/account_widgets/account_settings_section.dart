import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class AccountSettingsSection extends StatelessWidget {
  final AuthController auth;
  final void Function(BuildContext, AuthController) onUpdateAccountInfo;

  const AccountSettingsSection({
    super.key,
    required this.auth,
    required this.onUpdateAccountInfo,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: () => onUpdateAccountInfo(context, auth),
              horizontalTitleGap: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
