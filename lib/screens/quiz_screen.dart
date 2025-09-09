import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final int examId;
  final int departmentId;
  final String examTitle;

  const QuizScreen({
    super.key,
    required this.examId,
    required this.departmentId,
    required this.examTitle,
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
    questionsFuture = ApiService.fetchQuestionsFront(
      departmentId: widget.departmentId,
      examId: widget.examId,
    );
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
      calculateResult();
    }
  }

  void prevQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void skipQuestion() {
    if (selectedAnswers.length <= currentIndex) {
      selectedAnswers.add(null);
    }
    nextQuestion();
  }

  void calculateResult() {
    // make sure selectedAnswers has an entry for every question
    while (selectedAnswers.length < questions.length) {
      selectedAnswers.add(null);
    }

    setState(() {
      showResult = true;
      showAnswer = false;
      score = 0;
      for (int i = 0; i < questions.length; i++) {
        if (selectedAnswers[i] != null &&
            selectedAnswers[i] == questions[i].correctAnswerIndex) {
          score++;
        }
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
            questions = snapshot.data ?? [];

            if (questions.isEmpty) {
              return const Center(child: Text('No questions available.'));
            }

            // show review view first if requested
            if (showAnswer) {
              return buildAnswerReview();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous
              ElevatedButton(
                onPressed: currentIndex > 0 ? prevQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Previous"),
              ),

              // Skip
              ElevatedButton(
                onPressed: () => skipQuestion(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text("Skip"),
              ),

              // Next / Finish
              ElevatedButton(
                onPressed:
                    (selected != null || currentIndex == questions.length - 1)
                    ? nextQuestion
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Text(
                  currentIndex == questions.length - 1 ? "Finish" : "Next",
                ),
              ),
            ],
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
            // open review: hide result and show review screen
            onPressed: () {
              setState(() {
                showResult = false;
                showAnswer = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
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

                    Color? leadingColor;
                    IconData leadingIcon;
                    if (isCorrect) {
                      leadingColor = Colors.green;
                      leadingIcon = Icons.check_circle;
                    } else if (isSelected && !isCorrect) {
                      leadingColor = Colors.red;
                      leadingIcon = Icons.cancel;
                    } else {
                      leadingColor = Colors.grey;
                      leadingIcon = Icons.radio_button_unchecked;
                    }

                    return ListTile(
                      leading: Icon(leadingIcon, color: leadingColor),
                      title: Text(
                        q.options[i],
                        style: TextStyle(
                          fontWeight: isCorrect
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                // Optionally show what the user selected (or 'Not answered')
                Text(
                  selected == null
                      ? 'Your answer: Not answered'
                      : 'Your answer: ${q.options[selected]}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
