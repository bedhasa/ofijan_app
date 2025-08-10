import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exam.dart';
import '../models/question.dart';
import '../models/department.dart';

class ApiService {
  static const String baseUrl = 'https://serveme.hamsaplus.com/api';

  // 1. Fetch departments
  static Future<List<Department>> fetchDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departments'));

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((json) => Department.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  // 2. Fetch exams for a department
  static Future<List<Exam>> fetchExamsFront(int departmentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/examsfront/$departmentId'),
    );
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((json) => Exam.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exams');
    }
  }

  // 3. Fetch questions for a selected exam
  // 🟢 CORRECTED: The API link you provided only takes a single ID (the examId).
  // This method has been updated to reflect that.
  static Future<List<Question>> fetchQuestionsFront(int examId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/questionfront/$examId'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List questions = decoded['questions'] ?? [];
      return questions.map((json) => Question.fromJson(json)).toList();
    } else {
      // It's good practice to print the response body for debugging
      print('Failed to load questions. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load questions');
    }
  }
}
