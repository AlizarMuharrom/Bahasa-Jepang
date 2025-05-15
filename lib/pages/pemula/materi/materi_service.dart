import 'dart:convert';
import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;

class MateriService {
  final String baseUrl = '${ApiConfig.baseUrl}/materis';

  Future<List<dynamic>> fetchAllMateri() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load materi');
    }
  }

  Future<dynamic> fetchMateriWithDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load materi details');
    }
  }
}
