import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final int examId;
  final String examTitle;

  const QuizScreen({super.key, required this.examId, required this.examTitle});

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
    questionsFuture = ApiService.fetchQuestionsFront(widget.examId);
  }

  void nextQuestion() {
    if (selectedAnswers.length <= currentIndex) {
      selectedAnswers.add(null);
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      setState(() {
        showResult = true;
        score = 0;
        for (int i = 0; i < questions.length; i++) {
          if (selectedAnswers.length > i &&
              selectedAnswers[i] == questions[i].correctAnswerIndex) {
            score++;
          }
        }
      });
    }
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

            if (showAnswer) {
              return buildAnswerReview();
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
            'Question ${currentIndex + 1} of ${questions.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                question.question,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, i) => RadioListTile<int>(
                value: i,
                groupValue: selected,
                onChanged: (val) {
                  setState(() {
                    if (selectedAnswers.length <= currentIndex) {
                      selectedAnswers.add(val);
                    } else {
                      selectedAnswers[currentIndex] = val;
                    }
                  });
                },
                activeColor: const Color(0xFF594FB6),
                title: Text(question.options[i]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: selected != null ? nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF594FB6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                currentIndex == questions.length - 1 ? "Finish" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Score',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$score / ${questions.length}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF594FB6),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => setState(() => showAnswer = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF594FB6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Review Answers"),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: restartQuiz,
            child: const Text("Retake Quiz"),
          ),
        ],
      ),
    );
  }

  Widget buildAnswerReview() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        final selected = selectedAnswers.length > index
            ? selectedAnswers[index]
            : null;
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Q${index + 1}. ${q.question}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(q.options.length, (i) {
                    final isCorrect = i == q.correctAnswerIndex;
                    final isSelected = i == selected;
                    return ListTile(
                      leading: Icon(
                        isCorrect
                            ? Icons.check_circle
                            : isSelected
                            ? Icons.cancel
                            : Icons.radio_button_unchecked,
                        color: isCorrect
                            ? Colors.green
                            : isSelected
                            ? Colors.red
                            : Colors.grey,
                      ),
                      title: Text(q.options[i]),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
