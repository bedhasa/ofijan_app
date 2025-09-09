// lib/screens/exam_description_screen.dart

import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'quiz_screen.dart'; // adjust the path if necessary
import '../services/api_service.dart';

class ExamDescriptionScreen extends StatelessWidget {
  final int departmentId;
  final String departmentTitle;

  const ExamDescriptionScreen({
    super.key,
    required this.departmentId,
    required this.departmentTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exams - $departmentTitle'),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: FutureBuilder<List<Exam>>(
        future: ApiService.fetchExamsFront(departmentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final exams = snapshot.data ?? [];

          if (exams.isEmpty) {
            return const Center(child: Text('No exams found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        examId: exam.id,
                        departmentId:
                            exam.departmentId, // ✅ pass department id too
                        examTitle: exam.examName,
                      ),
                    ),
                  );
                },

                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.examName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF594FB6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (exam.description != null &&
                            exam.description!.isNotEmpty)
                          Text(
                            exam.description!,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(
                              icon: Icons.timer,
                              label: '${exam.examDuration} min',
                            ),
                            _buildInfoChip(
                              icon: Icons.assignment_turned_in,
                              label: '${exam.questionsCount} questions',
                            ),
                            _buildInfoChip(
                              icon: Icons.star,
                              label: '${exam.examGrade} grade',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper widget to build the information chips
  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF594FB6)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
