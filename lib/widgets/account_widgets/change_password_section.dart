import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class ChangePasswordSection extends StatelessWidget{
  final AuthController auth;
  final void Function(BuildContext, AuthController) onChangePassword;

  const ChangePasswordSection({
    super.key,
    required this.auth,
    required this.onChangePassword,
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
              "Şifre Yönetimi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),

            const Divider(height: 20, thickness: 1),

            ListTile(
              leading: const Icon(
                Icons.vpn_key_off_outlined,
                color: Colors.orange,
              ),
              title: const Text("Şifreyi değiştir"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => onChangePassword(context, auth),
              horizontalTitleGap: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}