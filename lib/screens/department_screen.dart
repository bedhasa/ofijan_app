import 'package:flutter/material.dart';

class DepartmentScreen extends StatelessWidget {
  final String sectionTitle;

  const DepartmentScreen({required this.sectionTitle, super.key});

  @override
  Widget build(BuildContext context) {
    // Later you'll fetch real departments based on sectionTitle
    final departments = ['CSE', 'IT', 'ECE', 'Mechanical'];

    return Scaffold(
      appBar: AppBar(
        title: Text(sectionTitle),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(departments[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Here you can navigate to Year screen next
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Selected ${departments[index]}")),
              );
            },
          );
        },
      ),
    );
  }
}
