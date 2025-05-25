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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final currentLanguage = context.locale.languageCode == 'ru' ? 'Русский' : 'English';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('settings'.tr(),
        style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 26,
            color: Theme.of(context).colorScheme.onBackground,
            shadows: [
              const Shadow(blurRadius: 4, offset: Offset(1, 1), color: Colors.black45),
            ],
          ),
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 🔹 Фон на весь экран
          Positioned.fill(
            child: Image.asset(
              isDark ? 'assets/images/background_dark.jpg' : 'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 🔹 Затемнение
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(isDark ? 0.6 : 0.3),
            ),
          ),
          // 🔹 Контент
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(
                                'dark_mode'.tr(),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              value: isDarkMode,
                              onChanged: (value) => themeProvider.toggleTheme(value),
                              secondary: const Icon(Icons.dark_mode),
                            ),
                            const Divider(height: 0),
                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(
                                'language'.tr(),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(currentLanguage),
                              onTap: _showLanguageDialog,
                            ),
                            const Divider(height: 0),
                            ListTile(
                              leading: const Icon(Icons.info_outline),
                              title: Text(
                                'about_app'.tr(),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              onTap: () {
                context.setLocale(const Locale('ru'));
                Navigator.pop(context);
                setState(() {});
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
