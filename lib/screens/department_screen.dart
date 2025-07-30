import 'package:flutter/material.dart';
import 'year_selection_screen.dart';

class DepartmentScreen extends StatelessWidget {
  final String sectionTitle;

  const DepartmentScreen({required this.sectionTitle, super.key});

  @override
  Widget build(BuildContext context) {
    final departments = ['CSE', 'IT', 'ECE', 'Mechanical'];

    return Scaffold(
      appBar: AppBar(
        title: Text(sectionTitle),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final department = departments[index];
          return ListTile(
            title: Text(department),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YearSelectionScreen(
                    sectionTitle: sectionTitle,
                    department: department,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
