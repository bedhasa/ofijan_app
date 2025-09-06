// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/department.dart';
import '../models/exam.dart';
import '../models/question.dart';

class ApiService {
  // change base if needed
  static const String baseUrl = 'https://serveme.hamsaplus.com/api';

  // ---------- Departments ----------
  static Future<List<Department>> fetchDepartments() async {
    final resp = await http.get(Uri.parse('$baseUrl/departments'));
    if (resp.statusCode == 200) {
      final List decoded = json.decode(resp.body);
      return decoded.map((e) => Department.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  // ---------- Exams ----------
  static Future<List<Exam>> fetchExamsFront(int departmentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/examsfront/$departmentId'),
    );
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((j) => Exam.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load exams');
    }
  }

  // ---------- Questions ----------
  static Future<List<Question>> fetchQuestionsFront(int examId) async {
    final resp = await http.get(Uri.parse('$baseUrl/questionfront/$examId'));
    if (resp.statusCode == 200) {
      final Map body = json.decode(resp.body);
      final List q = body['questions'] ?? [];
      return q.map((e) => Question.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // ---------- Auth ----------
  // NOTE: change endpoints and fields to match your backend exactly.
  static Future<String> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/login'), // <-- change to your login endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final body = json.decode(resp.body);
    if (resp.statusCode == 200) {
      // expected to get token or user object
      final token = body['token'] ?? body['access_token'] ?? '';
      // persist token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      return token;
    } else {
      final message = body['message'] ?? 'Login failed';
      throw Exception(message);
    }
  }

  static Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required int departmentId,
  }) async {
    final resp = await http.post(
      Uri.parse(
        '$baseUrl/registeruser',
      ), // <-- change to your register endpoint
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'password': password,
        'department_id': departmentId,
      }),
    );

    final body = json.decode(resp.body);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      // success - maybe returns token
      final token = body['token'] ?? body['access_token'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }
      return true;
    } else {
      final message = body['message'] ?? body.toString();
      throw Exception(message);
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // helper to get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
