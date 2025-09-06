import 'package:flutter/material.dart';
import '../widgets/exam_card.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/exam_section.dart'; // adjust path

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<ExamSection> sections = [
    ExamSection(title: 'Model Exam', icon: Icons.book),
    ExamSection(title: 'MoE Exit Exam', icon: Icons.school),
    ExamSection(title: 'EuEE', icon: Icons.edit_document),
    ExamSection(title: 'Blueprint', icon: Icons.book),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("Ofijan"),
        centerTitle: true,
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: sections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return ExamCard(section: sections[index]);
          },
        ),
      ),
    );
  }
}
