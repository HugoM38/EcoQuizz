import 'package:ecoquizz/models/question.dart';

class QuizService {
  Future<List<Question>> fetchQuestions() async {
    await Future.delayed(Duration(seconds: 1));
    List<Map<String, dynamic>> data = [
      {
        "id": 1,
        "ordre": 1,
        "question": "Quel mode de transport utilises-tu le plus souvent ?",
        "answers": [
          {"answer": "Voiture", "impact": "0"},
          {"answer": "Vélo", "impact": "1"},
          {"answer": "Transports en commun", "impact": "2"}
        ]
      },
      {
        "id": 2,
        "ordre": 2,
        "question": "Combien de kilomètres parcourez-vous par semaine ?",
        "answers": [
          {"answer": "Moins de 10 km", "impact": "0"},
          {"answer": "Entre 10 et 50 km", "impact": "1"},
          {"answer": "Plus de 50 km", "impact": "2"}
        ]
      },
    ];

    List<Question> questions =
        data.map((json) => Question.fromJson(json)).toList();
    questions.sort((a, b) => a.ordre.compareTo(b.ordre));
    return questions;
  }
}