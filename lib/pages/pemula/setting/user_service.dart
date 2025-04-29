import 'dart:convert';
import 'package:bahasajepang/service/API_config.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<http.Response> updateProfile(
      int userId, String username, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/update-profile/$userId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    return response;
  }
}
