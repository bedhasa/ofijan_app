// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/department.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../models/user.dart'; // ✅ Add this model

class ApiService {
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
  static Future<List<Question>> fetchQuestionsFront({
    required int departmentId,
    required int examId,
  }) async {
    // Fetch all questions for the department
    final resp = await http.get(
      Uri.parse('$baseUrl/questionfront/$departmentId'),
    );

    if (resp.statusCode == 200) {
      final Map body = json.decode(resp.body);
      final List q = body['questions'] ?? [];
      final allQuestions = q.map((e) => Question.fromJson(e)).toList();

      // Filter only questions for the selected exam
      final filtered = allQuestions
          .where((que) => que.examId == examId)
          .toList();
      return filtered;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // ---------- Auth ----------
  static Future<String> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    final body = json.decode(resp.body);
    if (resp.statusCode == 200) {
      final token = body['token'] ?? body['access_token'] ?? '';
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
      Uri.parse('$baseUrl/registeruser'),
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

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // ---------- User Profile ----------
  static Future<User> fetchUserInfo() async {
    final token = await getToken();
    final resp = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      return User.fromJson(body['user'] ?? body);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  static Future<void> updateUserInfo({
    required String fname,
    required String lname,
    required String phone,
  }) async {
    final token = await getToken();
    final resp = await http.put(
      Uri.parse('$baseUrl/user/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'fname': fname, 'lname': lname, 'phone': phone}),
    );

    if (resp.statusCode != 200) {
      final body = json.decode(resp.body);
      throw Exception(body['message'] ?? 'Failed to update user info');
    }
  }

  static Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await getToken();
    final resp = await http.post(
      Uri.parse('$baseUrl/user/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (resp.statusCode != 200) {
      final body = json.decode(resp.body);
      throw Exception(body['message'] ?? 'Failed to change password');
    }
  }
}
