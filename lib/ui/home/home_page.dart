import 'package:flutter/material.dart';
import 'package:ecoquizz/models/question.dart';
import 'package:ecoquizz/services/quiz_service.dart';
import 'package:ecoquizz/ui/quiz/quiz_page.dart';
import 'package:ecoquizz/ui/widgets/EcoQuizz_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuizService quizService = QuizService();
  bool _isQuizLaunching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EcoQuizzAppBar(title: "EcoQuizz"),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.35,
                  vertical: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Text(
                  "Page d'accueil de EcoQuizz",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isQuizLaunching
            ? null
            : () async {
                setState(() {
                  _isQuizLaunching = true;
                });
                List<Question> questions = await quizService.fetchQuestions();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(questions: questions),
                  ),
                );
                setState(() {
                  _isQuizLaunching = false;
                });
              },
        child: Text("Lancer le quizz"),
      ),
    );
  }
}
