import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/department.dart';
import 'exam_description_screen.dart';

class DepartmentScreen extends StatefulWidget {
  final String sectionTitle;

  const DepartmentScreen({super.key, required this.sectionTitle});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  late Future<List<Department>> departments;

  @override
  void initState() {
    super.initState();
    departments = ApiService.fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sectionTitle),
        backgroundColor: const Color(0xFF594FB6),
      ),
      body: FutureBuilder<List<Department>>(
        future: departments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final departments = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final dept = departments[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamDescriptionScreen(
                        departmentId: departments[index].id, // correct ID
                        departmentTitle:
                            departments[index].title, // correct title
                      ),
                    ),
                  );
                },

                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('images/ofijan_logo.png'),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          dept.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
