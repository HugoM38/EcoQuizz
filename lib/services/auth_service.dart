import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecoquizz/utils/shared_prefs_manager.dart';

class AuthService {
  Future<http.Response> login(String email, String password) async {
    final String api = "http://localhost:5001/api/auth";
    final Uri apiUrl = Uri.parse('$api/signin');

    final http.Response response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      final String sessionToken = responseData['session_token'];
      final String userId = responseData['user_id'];
      await SharedPreferencesManager.loginUser(userId, sessionToken);
    } else if (response.statusCode == 401) {
      throw "Email ou mot de passe incorrect";
    } else {
      throw "Erreur lors de la connexion: ${response.body}";
    }

    return response;
  }

  Future<http.Response> signup(String email, String password) async {
    final String api = "http://localhost:5001/api/auth";
    final Uri apiUrl = Uri.parse('$api/signup');

    final http.Response response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      final String sessionToken = responseData['session_token'];
      final String userId = responseData['user_id'];
      await SharedPreferencesManager.loginUser(userId, sessionToken);
    } else if (response.statusCode == 401) {
      throw "Email ou mot de passe incorrect";
    } else {
      throw "Erreur lors de l'inscription: ${response.body}";
    }

    return response;
  }
}
