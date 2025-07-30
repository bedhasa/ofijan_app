import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department.dart';

class ApiService {
  static Future<List<Department>> fetchDepartments() async {
    final response = await http.get(
      Uri.parse('https://serveme.hamsaplus.com/api/departments'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Department.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }
}
