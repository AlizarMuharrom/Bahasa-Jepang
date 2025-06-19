import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bahasajepang/service/API_config.dart';

class UserService {
  static Future<http.Response> updateProfile(
      int userId, String username, String password) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/update-profile/$userId');

    print('Sending to: $url'); // Debug URL
    print(
        'Payload: {"username": "$username", "password": "$password"}'); // Debug payload

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true' // Jika pakai ngrok
        },
        body: jsonEncode({
          'username': username,
          'password': password.isNotEmpty
              ? password
              : null, // Kirim null jika password kosong
        }),
      );

      print('Response Status: ${response.statusCode}'); // Debug status
      print('Response Body: ${response.body}'); // Debug response

      return response;
    } catch (e) {
      print('Error in updateProfile: $e'); // Debug error
      rethrow;
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
