import 'package:flutter/material.dart';
import '../models/exam_section.dart';
import '../screens/department_screen.dart'; // import this

class ExamCard extends StatelessWidget {
  final ExamSection section;

  const ExamCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to DepartmentScreen first
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DepartmentScreen(sectionTitle: section.title),
          ),
        );
      },
      child: Card(
        color: const Color(0xFF594FB6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(section.icon, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                section.title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
