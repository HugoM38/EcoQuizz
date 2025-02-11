import 'dart:convert';
import 'package:ecoquizz/models/question.dart';
import 'package:ecoquizz/utils/shared_prefs_manager.dart';
import 'package:http/http.dart' as http;

class QuizService {
  final String baseUrl = "http://localhost:5001/api/quiz";

  Future<List<Question>> fetchQuestions() async {
    final String? token = await SharedPreferencesManager.getSessionToken();
    if (token == null) {
      throw Exception("Token manquant pour l'authentification");
    }
    
    final Uri url = Uri.parse("$baseUrl/questions");
    final http.Response response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> questionsJson = data["questions"];
      List<Question> questions = questionsJson
          .map((json) => Question.fromJson(json))
          .toList();
      questions.sort((a, b) => a.ordre.compareTo(b.ordre));
      return questions;
    } else {
      throw Exception("Erreur lors de la récupération des questions");
    }
  }

  Future<String> saveQuizResult(int impact) async {
    final String? userId = await SharedPreferencesManager.getUser();
    if (userId == null) {
      throw Exception("Erreur lors de la sauvegarde du résultat du quiz : userId manquant");
    }

    final String? token = await SharedPreferencesManager.getSessionToken();
    if (token == null) {
      throw Exception("Token manquant pour l'authentification");
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final Map<String, dynamic> result = {
      "impact": impact,
      "date": timestamp,
    };

    final Uri url = Uri.parse("$baseUrl/result");

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(result),
      );

      if (response.statusCode == 200) {
        return "Résultat du quiz sauvegardé avec succès";
      } else {
        print(response.body);
        throw Exception("Erreur lors de la sauvegarde du résultat du quiz");
      }
    } catch (e) {
      throw Exception("Erreur lors de la sauvegarde du résultat du quiz: $e");
    }
  }
}
