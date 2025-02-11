import 'dart:convert';
import 'package:ecoquizz/models/question.dart';
import 'package:ecoquizz/ui/home/result_page.dart';
import 'package:ecoquizz/ui/widgets/ecoquizz_appbar.dart';
import 'package:ecoquizz/ui/widgets/ecoquizz_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  String? _equivalentsData;

  @override
  void initState() {
    super.initState();
    _loadEquivalentsJson();
  }

  Future<void> _loadEquivalentsJson() async {
    String jsonString =
        await rootBundle.loadString('assets/data/co2_equivalents.json');
    setState(() {
      _equivalentsData = jsonString;
    });
  }

  String getEquivalentMessage() {
    if (_equivalentsData == null) {
      return "Chargement des équivalences…";
    }
    final Map<String, dynamic> data = json.decode(_equivalentsData!);
    final List<dynamic> equivalents = data["co2_equivalents"];
    for (var item in equivalents) {
      int min = item['min'];
      int max = item['max'];
      if (totalImpact >= min && totalImpact <= max) {
        return item['message'];
      }
    }
    return "aucun équivalent trouvé !";
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: EcoQuizzAppBar(
        title: "Question ${currentQuestion.ordre}",
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                currentQuestion.question,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Column(
                children: currentQuestion.answers.asMap().entries.map((entry) {
                  int index = entry.key;
                  var answer = entry.value;
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: selectedAnswerIndex == index
                          ? Colors.green.shade100
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: selectedAnswerIndex == index
                            ? Colors.green
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: RadioListTile<int>(
                      title: Text(
                        answer.answer,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      value: index,
                      groupValue: selectedAnswerIndex,
                      activeColor: Colors.green,
                      onChanged: isValidated
                          ? null
                          : (value) {
                              setState(() {
                                selectedAnswerIndex = value;
                              });
                            },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              EcoQuizzButton(
                title: "Valider",
                isEnable: selectedAnswerIndex != null && !isValidated,
                onPressed: () {
                  setState(() {
                    isValidated = true;
                    totalImpact +=
                        currentQuestion.answers[selectedAnswerIndex!].impact;
                  });
                },
              ),
              SizedBox(height: 20),
              if (isValidated)
                Text(
                  "Tu génères $totalImpact kg de CO₂ par mois, ${getEquivalentMessage()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: isValidated
          ? FloatingActionButton(
              onPressed: () {
                if (currentQuestionIndex < widget.questions.length - 1) {
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
                          ResultPage(totalImpact: totalImpact),
                    ),
                  );
                }
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.arrow_forward,
                size: 30,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / widget.questions.length,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
