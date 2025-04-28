import 'dart:convert';
import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;

class UjianService {
  final String baseUrl = ApiConfig.baseUrl;

  // Get daftar ujian berdasarkan level
  Future<List<dynamic>> getUjianByLevel(int levelId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ujian/level/$levelId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ujian');
    }
  }

  // Get soal ujian
  Future<List<dynamic>> getSoalUjian(int ujianId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ujian/$ujianId/soal'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load soal');
    }
  }

  // Submit jawaban ujian
  Future<Map<String, dynamic>> submitUjian(
    int ujianId, 
    List<Map<String, dynamic>> jawaban,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ujian/$ujianId/submit'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'jawaban': jawaban}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit ujian');
    }
  }
}