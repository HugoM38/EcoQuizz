import 'package:ecoquizz/models/question.dart';
import 'package:ecoquizz/ui/home/result_page.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;

  const QuizPage({super.key, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  bool isValidated = false;
  int totalImpact = 0;

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentQuestion.ordre}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.answers.length, // Ajout de itemCount
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    title: Text(currentQuestion.answers[index].answer),
                    value: index,
                    groupValue: selectedAnswerIndex,
                    onChanged: isValidated
                        ? null
                        : (value) {
                            setState(() {
                              selectedAnswerIndex = value;
                            });
                          },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (selectedAnswerIndex != null && !isValidated)
                      ? () {
                          setState(() {
                            isValidated = true;
                            totalImpact += currentQuestion
                                .answers[selectedAnswerIndex!].impact;
                          });
                        }
                      : null,
                  child: Text('Valider'),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: isValidated
                      ? () {
                          if (currentQuestionIndex <
                              widget.questions.length - 1) {
                            setState(() {
                              currentQuestionIndex++;
                              selectedAnswerIndex = null;
                              isValidated = false;
                            });
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResultPage(totalImpact: totalImpact)),
                            );
                          }
                        }
                      : null,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
