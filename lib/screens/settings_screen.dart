import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const ListTile(
            title: Text("Language"),
            subtitle: Text("Coming soon..."),
          ),
        ],
      ),
    );
  }
}
