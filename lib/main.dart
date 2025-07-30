import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ofijan_app/screens/settings_screen.dart';
import 'screens/home_screen.dart';
import 'package:ofijan_app/providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Ofijan',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // Replace with your home
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
