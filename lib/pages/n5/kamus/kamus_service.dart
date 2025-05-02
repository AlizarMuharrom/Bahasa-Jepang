import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bahasajepang/service/API_config.dart';

class KamusService {
  // Gunakan baseUrl dari ApiConfig
  final String baseUrl = ApiConfig.baseUrl + "/kamuses";

  // Ambil semua kamus tanpa filter
  Future<List<dynamic>> fetchKamuses() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load kamuses');
    }
  }

  // Ambil kamus berdasarkan ID
  Future<dynamic> fetchKamusById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load kamus');
    }
  }

  // Ambil kamus berdasarkan level_id
  Future<List<dynamic>> fetchKamusesByLevel(int levelId) async {
    final response = await http.get(Uri.parse('$baseUrl?level_id=$levelId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load kamuses by level');
    }
  }
}
