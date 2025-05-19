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
  int? level_id; // Tambahkan variabel levelId

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      print("$key : ${prefs.get(key)}");
    });

    setState(() {
      userId = prefs.getInt('id');
      level_id = prefs.getInt('level_id');
    });

    // Hanya arahkan jika levelId memiliki nilai yang valid (1, 2, atau 3)
    if (level_id != null && level_id! > 0 && level_id! <= 3) {
      print("LEVEL ID :  $level_id");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (level_id) {
          case 1:
            Navigator.pushNamedAndRemoveUntil(
                context, '/pemula', (route) => false);
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(context, '/n5', (route) => false);
            break;
          case 3:
            Navigator.pushNamedAndRemoveUntil(context, '/n4', (route) => false);
            break;
        }
      });
    } else {
      // Jika levelId null, 0, atau tidak valid, tetap di halaman level selection
      print("Level ID belum dipilih atau tidak valid: $level_id");
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

  Future<void> updateUserLevel(int userId, int level_id) async {
    const endpoint = "/update-level";
    try {
      print('Sending data: user_id=$userId, level_id=$level_id');

      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'level_id': level_id}),
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

  Future<void> sendLevelToDatabase(int level_id) async {
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
        body: jsonEncode({'user_id': userId, 'level_id': level_id}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Response: ${jsonResponse}');

        // Simpan levelId ke SharedPreferences
        await prefs.setInt('levelId', level_id);

        // Arahkan ke halaman level yang sesuai
        switch (level_id) {
          case 1:
            Navigator.pushNamedAndRemoveUntil(
                context, '/pemula', (route) => false);
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(context, '/n5', (route) => false);
            break;
          case 3:
            Navigator.pushNamedAndRemoveUntil(context, '/n4', (route) => false);
            break;
          default:
            print("level_page2");
            Navigator.pushNamedAndRemoveUntil(
                context, '/level', (route) => false);
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
