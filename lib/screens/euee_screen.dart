import 'package:flutter/material.dart';

class EuEEScreen extends StatelessWidget {
  const EuEEScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final years = ['2020', '2021', '2022'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("EuEE Exams"),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: ListView.builder(
        itemCount: years.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Year ${years[index]}"),
            onTap: () {
              // Navigate to subjects under selected year
            },
          );
        },
      ),
    );
  }
}
