import 'dart:convert';
import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;

class KanjiService {
  final String baseUrl = ApiConfig.baseUrl + "/kanji";

  // Fetch kanji by kategori dan level
  Future<List<dynamic>> fetchKanjiByKategori(String kategori, {int? levelId}) async {
    String url = '$baseUrl?kategori=$kategori';
    if (levelId != null) {
      url += '&level_id=$levelId';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data;
    } else {
      throw Exception('Failed to load kanji');
    }
  }

  Future<List<dynamic>> fetchLevels() async {
    final response = await http.get(Uri.parse(ApiConfig.baseUrl + "/levels"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data;
    } else {
      throw Exception('Failed to load levels');
    }
  }

  Future<List<dynamic>> fetchKanjiByKategoriAndLevel(String kategori, int levelId) async {
  final response = await http.get(
    Uri.parse('$baseUrl?kategori=$kategori&level_id=$levelId')
  );

  if (response.statusCode == 200) {
    return json.decode(response.body) as List;
  } else {
    throw Exception('Failed to load kanji');
  }
}
}