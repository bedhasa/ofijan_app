class Question {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final int examId;
  final int departmentId;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.examId,
    required this.departmentId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Extract options list and map them
    List<dynamic> optionList = json['options'] ?? [];
    List<String> optionsText = optionList
        .map((o) => o['option'] as String)
        .toList();

    // Find correct answer index
    int correctIndex = optionList.indexWhere((o) => o['correct'] == "1");

    return Question(
      id: json['id'],
      question: _stripHtml(json['question_text'] ?? ''),
      options: optionsText,
      correctAnswerIndex: correctIndex >= 0 ? correctIndex : 0,
      examId: int.tryParse(json['exam_id'].toString()) ?? 0,
      departmentId: int.tryParse(json['department_id'].toString()) ?? 0,
    );
  }

  // Optional helper to remove <p></p> tags if needed
  static String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
