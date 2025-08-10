import 'package:flutter/material.dart';
import 'exam_list_screen.dart';

class YearSelectionScreen extends StatelessWidget {
  final String sectionTitle;
  final String department;

  const YearSelectionScreen({
    super.key,
    required this.sectionTitle,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> years = ['Year 2015 ', 'Year 2016', 'Year 2017'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$sectionTitle - $department'),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          return Card(
            child: ListTile(
              title: Text(year),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamListScreen(
                      year: year,
                      department: department,
                      departmentId: 1,
                      examType: sectionTitle,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
