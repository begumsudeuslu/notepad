import 'package:flutter/material.dart';
import '../../controllers/account_controller.dart';

class AppSettingsSection extends StatelessWidget {
  final AccountController account;
  final void Function(BuildContext, AccountController) onOpenAppSettings;

  const AppSettingsSection({
    super.key,
    required this.account,
    required this.onOpenAppSettings,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Uygulama Ayarları",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),

            const Divider(height: 20, thickness: 1),

            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: Colors.purple,
              ),
              title: const Text("Genel Ayarlar"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => onOpenAppSettings(context, account),
              horizontalTitleGap: 10.0,
            ),
            // buraya bildirim ayarları, tema vs vs eklenecek
          ],
        ),
      ),
    );
  }
}