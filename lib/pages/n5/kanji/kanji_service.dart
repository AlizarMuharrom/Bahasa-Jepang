import 'dart:convert';
import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;

class KanjiService {
  final String baseUrl = ApiConfig.baseUrl + "/kanji";

  Future<List<dynamic>> fetchKanjiByKategori(String kategori) async {
    final response = await http.get(Uri.parse('$baseUrl?kategori=$kategori'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data;
    } else {
      throw Exception('Failed to load kanji');
    }
  }
}
