import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MateriService {
  // Method untuk mendapatkan materi berdasarkan level
  Future<List<dynamic>> getMateriByLevel(String levelName) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/materi/level/$levelName'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // Method baru untuk mendapatkan detail materi
  Future<dynamic> getMateriDetails(int materiId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/materi/$materiId'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // Headers yang digunakan secara umum
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true'
  };

  // Fungsi untuk menangani response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to load data. Status: ${response.statusCode}. '
        'Response: ${response.body}'
      );
    }
  }
}