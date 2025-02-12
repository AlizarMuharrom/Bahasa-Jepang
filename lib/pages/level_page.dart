import 'dart:convert';

import 'package:bahasajepang/service/API_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LevelSelectionPage extends StatefulWidget {
  const LevelSelectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LevelSelectionPageState createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  @override
  Future<void> sendNumberToDatabase(int number) async {
    const endpoint = "/level";
    try {
      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'number': number}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Response: ${jsonResponse}');
      } else {
        print('Failed to send number. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image_splash.png',
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Pilih level kemampuanmu",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLevelButton(
              "Pemula (Belum pernah belajar bahasa Jepang)",
              Colors.blue.shade200,
              () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userId = prefs.getString('userId');

                if (userId != null) {
                  print('User ID: $userId');
                  print('Level: 1');

                  await sendNumberToDatabase(1);

                  Navigator.pushNamed(context, '/pemula');
                } else {
                  print('User ID tidak ditemukan');
                }
              },
            ),
            const SizedBox(height: 10),
            _buildLevelButton(
              "N5 (Mengetahui huruf dasar bahasa Jepang)",
              const Color.fromRGBO(100, 181, 246, 1),
              () {
                Navigator.pushNamed(context, '/n5');
              },
            ),
            const SizedBox(height: 10),
            _buildLevelButton(
              "N4 (Mengetahui lebih dari 100 kanji dan 800 kosakata)",
              Colors.blue.shade400,
              () {
                Navigator.pushNamed(context, '/n4');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
