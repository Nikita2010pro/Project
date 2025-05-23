import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/account/settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser;

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('confirm_sign_out'.tr()),
          content: Text('are_you_sure_sign_out'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Закрыть диалог
                final navigator = Navigator.of(context);
                await FirebaseAuth.instance.signOut();
                navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              },
              child: Text('yes'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showEditNameDialog() {
    final TextEditingController _nameController =
        TextEditingController(text: user?.displayName ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('edit_name'.tr()),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'enter_new_name'.tr()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () async {
                final newName = _nameController.text.trim();
                if (newName.isNotEmpty && newName != user?.displayName) {
                  await user?.updateDisplayName(newName);
                  await user?.reload();
                  setState(() {});
                }
                Navigator.of(context).pop();
              },
              child: Text('save'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('account'.tr()),
        // Удалена кнопка выхода сверху
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                user?.photoURL ??
                    'https://avatars.mds.yandex.net/i?id=12aa7b40c6e542d0c72501d0bb3ad79839a39fc1-9099609-images-thumbs&n=13',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user?.displayName ?? 'no_name'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: 'edit_name'.tr(),
                  onPressed: () => _showEditNameDialog(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? 'unknown_email'.tr(),
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: Text('my_bookings'.tr()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(context, '/my_bookings');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text('settings'.tr()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text('registration_date'.tr()),
                    subtitle: Text(
                      user?.metadata.creationTime?.toLocal().toString().split(' ').first ??
                          'unknown'.tr(),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _confirmSignOut(),
              icon: const Icon(Icons.logout),
              label: Text('sign_out'.tr()),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
