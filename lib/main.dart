import 'package:flutter/material.dart';
import 'package:ofijan_app/screens/splash_screen.dart'; // Import your splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ofijan App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(), // 👈 Set the splash screen here
    );
  }
}
