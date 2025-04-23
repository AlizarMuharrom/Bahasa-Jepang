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
  int? userId;
  int? levelId; // Tambahkan variabel levelId

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id');
      levelId = prefs.getInt('levelId'); // Ambil levelId dari SharedPreferences
    });

    // Jika levelId sudah ada, arahkan ke halaman level yang sesuai
    if (levelId != null && levelId != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (levelId) {
          case 1:
            Navigator.pushNamed(context, '/pemula');
            break;
          case 2:
            Navigator.pushNamed(context, '/n5');
            break;
          case 3:
            Navigator.pushNamed(context, '/n4');
            break;
          default:
            Navigator.pushNamed(context, '/level');
        }
      });
    }
  }

  Future<void> sendNumberToDatabase(int number) async {
    const endpoint = "/update-level";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      if (userId == null) {
        print('User ID tidak ditemukan');
        return;
      }

      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'level_id': number}),
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

  Future<void> updateUserLevel(int userId, int levelId) async {
    const endpoint = "/update-level";
    try {
      print('Sending data: user_id=$userId, level_id=$levelId');

      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'level_id': levelId}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Response: ${jsonResponse}');
      } else {
        print('Failed to update level. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendLevelToDatabase(int levelId) async {
    const endpoint = "/update-level";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      if (userId == null) {
        print('User ID tidak ditemukan');
        return;
      }

      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'level_id': levelId}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Response: ${jsonResponse}');

        // Simpan levelId ke SharedPreferences
        await prefs.setInt('levelId', levelId);

        // Arahkan ke halaman level yang sesuai
        switch (levelId) {
          case 1:
            Navigator.pushNamed(context, '/pemula');
            break;
          case 2:
            Navigator.pushNamed(context, '/n5');
            break;
          case 3:
            Navigator.pushNamed(context, '/n4');
            break;
          default:
            Navigator.pushNamed(context, '/level');
        }
      } else {
        print('Failed to send level. Status Code: ${response.statusCode}');
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
                int? userId = prefs.getInt('id');
                if (userId != null) {
                  await sendLevelToDatabase(1);
                } else {
                  print('User ID tidak ditemukan');
                }
              },
            ),
            const SizedBox(height: 10),
            _buildLevelButton(
              "N5 (Mengetahui huruf dasar bahasa Jepang)",
              const Color.fromRGBO(100, 181, 246, 1),
              () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int? userId = prefs.getInt('id');

                if (userId != null) {
                  await sendLevelToDatabase(2);
                } else {
                  print('User ID tidak ditemukan');
                }
              },
            ),
            const SizedBox(height: 10),
            _buildLevelButton(
              "N4 (Mengetahui lebih dari 100 kanji dan 800 kosakata)",
              Colors.blue.shade400,
              () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int? userId = prefs.getInt('id');

                if (userId != null) {
                  await sendLevelToDatabase(3);
                } else {
                  print('User ID tidak ditemukan');
                }
              },
            ),
            _buildLevelButton(
              "Pemula",
                Colors.blue.shade400, () {
              Navigator.pushNamed(context, '/pemula');
            }), 
            _buildLevelButton(
              "N5 (Mengetahui huruf dasar bahasa Jepang)",
                Colors.blue.shade400, () {
              Navigator.pushNamed(context, '/n5');
            }), 
            _buildLevelButton(
                "N4 (Mengetahui lebih dari 100 kanji dan 800 kosakata)",
                Colors.blue.shade400, () {
              Navigator.pushNamed(context, '/n4');
            }),
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
