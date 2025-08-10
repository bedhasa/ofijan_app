import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final int examId;
  final String examTitle;
  final int departmentId; // ✅ NEW

  const QuizScreen({
    super.key,
    required this.examId,
    required this.examTitle,
    required this.departmentId, // ✅ NEW
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> questionsFuture;
  List<Question> questions = [];
  int currentIndex = 0;
  int score = 0;
  List<int?> selectedAnswers = [];
  bool showResult = false;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    // ✅ Pass departmentId to API
    questionsFuture = ApiService.fetchQuestionsFront(widget.examId);
  }

  void selectAnswer(int? answerIndex) {
    if (selectedAnswers.length <= currentIndex) {
      selectedAnswers.add(answerIndex);
    } else {
      selectedAnswers[currentIndex] = answerIndex;
    }

    if (answerIndex == questions[currentIndex].correctAnswerIndex) {
      score++;
    }

    setState(() {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
      } else {
        showResult = true;
      }
    });
  }

  void restartQuiz() {
    setState(() {
      currentIndex = 0;
      score = 0;
      selectedAnswers = [];
      showResult = false;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.examTitle),
        backgroundColor: const Color(0xFF594FB6),
        actions: [
          if (showResult || showAnswer)
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: restartQuiz,
            ),
        ],
      ),
      body: FutureBuilder<List<Question>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            questions = snapshot.data!;

            if (questions.isEmpty) {
              return const Center(child: Text('No questions available.'));
            }

            if (showResult) {
              return buildResultScreen();
            }

            return buildQuestionView();
          }
        },
      ),
    );
  }

  Widget buildQuestionView() {
    final question = questions[currentIndex];
    final selected = selectedAnswers.length > currentIndex
        ? selectedAnswers[currentIndex]
        : null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: (currentIndex + 1) / questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation(Color(0xFF594FB6)),
          ),
          const SizedBox(height: 16),
          Text(
            'Question ${currentIndex + 1}/${questions.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(question.question, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          for (int i = 0; i < question.options.length; i++)
            GestureDetector(
              onTap: selected == null ? () => selectAnswer(i) : null,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected == i
                      ? Colors.deepPurple[100]
                      : Colors.grey[100],
                  border: Border.all(
                    color: selected == i
                        ? Colors.deepPurple
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(question.options[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildResultScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            'Your Score: $score / ${questions.length}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF594FB6),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() => showAnswer = true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 116, 87, 167),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('View Answers'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: restartQuiz,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text('Retake Quiz'),
          ),
        ],
      ),
    );
  }
}
