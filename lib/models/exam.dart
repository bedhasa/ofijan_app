// lib/models/exam.dart

class Exam {
  final int id;
  final int departmentId;
  final String examName;
  final String? description;
  final int examDuration;
  final int examGrade;
  final int questionsCount;

  Exam({
    required this.id,
    required this.departmentId,
    required this.examName,
    this.description,
    required this.examDuration,
    required this.examGrade,
    required this.questionsCount,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: int.parse(json['id'].toString()),
      departmentId: int.parse(json['department_id'].toString()),
      examName: json['exam_name'] as String,
      description: json['description'] as String?,
      examDuration: int.parse(json['exam_duration'].toString()),
      examGrade: int.parse(json['exam_grade'].toString()),
      questionsCount: int.parse(json['questions_count'].toString()),
    );
  }
}
