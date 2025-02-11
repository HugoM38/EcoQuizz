import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecoquizz/models/defi_model.dart';

class DefiService {
  final String _baseUrl = "http://localhost:5001/api/defi";

  Future<List<Defi>> fetchAllDefis() async {
    final uri = Uri.parse("$_baseUrl/");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Defi.fromJson(item)).toList().cast<Defi>();
    } else {
      throw "Erreur fetchAllDefis : ${response.body}";
    }
  }

  Future<List<Defi>> fetchLastTimeDone(String userId) async {
    final uri = Uri.parse("$_baseUrl/lastTimeDone");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userId": userId}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Defi.fromJson(item)).toList().cast<Defi>();
    } else {
      throw "Erreur fetchLastTimeDone : ${response.body}";
    }
  }

  Future<void> updateHistory(String userId, String defiId) async {
    final uri = Uri.parse("$_baseUrl/");
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userId": userId, "defiId": defiId}),
    );
    if (response.statusCode != 200) {
      throw "Erreur updateHistory : ${response.body}";
    }
  }
}
