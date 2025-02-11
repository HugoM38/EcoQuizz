import 'dart:convert';
import 'package:ecoquizz/utils/shared_prefs_manager.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "http://localhost:5001/api/userHistory";

  Future<List<dynamic>> fetchUserQuizHistory() async {
    final String? token = await SharedPreferencesManager.getSessionToken();
    if (token == null) {
      throw Exception("Token manquant");
    }
    final Uri url = Uri.parse("$baseUrl/quiz-history");
    final http.Response response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // On attend { "quiz_history": [...] }
      return data["quiz_history"];
    } else {
      throw Exception("Erreur lors de la récupération de l'historique des quiz");
    }
  }

  Future<List<dynamic>> fetchUserDefiHistory() async {
    final String? token = await SharedPreferencesManager.getSessionToken();
    if (token == null) {
      throw Exception("Token manquant");
    }
    final Uri url = Uri.parse("$baseUrl/defi-history");
    final http.Response response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // On attend { "defi_history": [...] }
      return data["defi_history"];
    } else {
      throw Exception("Erreur lors de la récupération de l'historique des défis");
    }
  }
}
