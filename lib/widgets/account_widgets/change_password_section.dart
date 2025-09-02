import 'package:flutter/material.dart';
import 'package:notepad/controllers/account_controller.dart';

class ChangePasswordSection extends StatelessWidget{
  final AccountController account;
  final void Function(BuildContext, AccountController) onChangePassword;

  const ChangePasswordSection({
    super.key,
    required this.account,
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
              onTap: () => onChangePassword(context, account),
              horizontalTitleGap: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}