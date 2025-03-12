import 'dart:convert';
import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;

class KamusService {
  // Gunakan baseUrl dari ApiConfig
  final String baseUrl = ApiConfig.baseUrl + "/kamuses";

  Future<List<dynamic>> fetchKamuses() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load kamuses');
    }
  }

  Future<dynamic> fetchKamusById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data['contoh_penggunaan'] is String) {
        data['contoh_penggunaan'] = json.decode(data['contoh_penggunaan']);
      }
      return data;
    } else {
      throw Exception('Failed to load kamus');
    }
  }
}
