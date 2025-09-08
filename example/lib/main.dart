import 'package:flutter/material.dart';
import 'package:modern_setting_ui/modern_setting_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Settings UI Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _language = 'English';
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ModernSettingsUI(
        sections: [
          SettingsSection(
            title: 'Appearance',
            items: [
              SettingsItem(
                id: 'dark_mode',
                type: SettingsItemType.switch_,
                title: 'Dark Mode',
                subtitle: 'Enable dark theme',
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'General',
            items: [
              SettingsItem(
                id: 'language',
                type: SettingsItemType.dropdown,
                title: 'Language',
                subtitle: 'Select your preferred language',
                value: _language,
                onChanged: (value) {
                  setState(() {
                    _language = value;
                  });
                },
              ),
              SettingsItem(
                id: 'notifications',
                type: SettingsItemType.switch_,
                title: 'Notifications',
                subtitle: 'Receive push notifications',
                value: _notifications,
                onChanged: (value) {
                  setState(() {
                    _notifications = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
