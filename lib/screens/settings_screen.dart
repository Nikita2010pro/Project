import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    String currentLanguage = context.locale.languageCode == 'ru' ? 'Русский' : 'English';

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
    body: ListView(
      children: [
        SwitchListTile(
          title: Text('dark_mode'.tr()),
          value: isDarkMode,
          onChanged: (value) => themeProvider.toggleTheme(value),
          secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('language'.tr()),
            subtitle: Text(currentLanguage),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('about_app'.tr()),
            subtitle: Text('version'.tr(args: ['1.0.0'])),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Travel App',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 ' + 'all_rights_reserved'.tr(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              onTap: () {
                context.setLocale(const Locale('ru'));
                Navigator.pop(context);
                setState(() {}); // обновить UI
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
