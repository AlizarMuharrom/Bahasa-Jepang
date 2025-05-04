import 'dart:convert';
import 'package:bahasajepang/pages/pemula/materi/model/hasil_ujian.dart';
import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<HasilUjianModel>> fetchHasilUjian(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/hasil-ujian/user/$userId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List data = json.decode(response.body)['data'];
    return data.map((e) => HasilUjianModel.fromJson(e)).toList();
  } else {
    throw Exception(
        'Gagal memuat data hasil ujian (Status: ${response.statusCode})');
  }
}
