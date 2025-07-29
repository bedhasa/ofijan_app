import 'package:flutter/material.dart';

class ExamListScreen extends StatelessWidget {
  final String year;
  final String department;
  final String examType;

  const ExamListScreen({
    super.key,
    required this.year,
    required this.department,
    required this.examType,
  });

  @override
  Widget build(BuildContext context) {
    final exams = ['Exam 1', 'Exam 2', 'Exam 3'];

    return Scaffold(
      appBar: AppBar(
        title: Text("$examType - $department - $year"),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: ListView.builder(
        itemCount: exams.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(exams[index]),
            trailing: const Icon(Icons.download),
            onTap: () {
              // Download logic or open PDF here
            },
          );
        },
      ),
    );
  }
}
