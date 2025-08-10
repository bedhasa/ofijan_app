import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExamListScreen extends StatefulWidget {
  final int departmentId;
  final String department;
  final String year;
  final String examType;

  const ExamListScreen({
    super.key,
    required this.departmentId,
    required this.year,
    required this.department,
    required this.examType,
  });

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  late Future<List<dynamic>> exams;

  Future<List<dynamic>> fetchExams() async {
    final url = Uri.parse(
      'https://serveme.hamsaplus.com/api/examsfront/${widget.departmentId}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exams');
    }
  }

  @override
  void initState() {
    super.initState();
    exams = fetchExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.examType} — ${widget.department} — ${widget.year}",
        ),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: exams,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text("No exams found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final exam = data[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    exam['exam_name'] ?? "No Name",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Date: ${exam['exam_date'] ?? '-'} | Questions: ${exam['questions_count'] ?? '0'}",
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF594FB6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Navigate to quiz screen
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(examId: exam['id'])));
                    },
                    child: const Text("Take Exam"),
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
