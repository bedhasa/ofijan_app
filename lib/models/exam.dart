class Exam {
  final int id; // exam id
  final String examName;
  final String? description;
  final int examDuration;
  final int questionsCount;
  final int examGrade;
  final int departmentId; // ✅ new field

  Exam({
    required this.id,
    required this.examName,
    this.description,
    required this.examDuration,
    required this.questionsCount,
    required this.examGrade,
    required this.departmentId,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      //id: json['id'],
      id: int.tryParse(json['id'].toString()) ?? 0,
      examName: json['exam_name'],
      description: json['description'],
      examDuration: int.tryParse(json['exam_duration'].toString()) ?? 0,
      questionsCount: int.tryParse(json['questions_count'].toString()) ?? 0,
      examGrade: int.tryParse(json['exam_grade'].toString()) ?? 0,
      departmentId: int.tryParse(json['department_id'].toString()) ?? 0, // ✅
    );
  }
}
