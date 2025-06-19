import 'dart:convert';
import 'package:bahasajepang/pages/pretest_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
              Colors.blue.shade200,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image_splash.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Pilih Level Kemampuanmu",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silakan pilih level yang sesuai dengan kemampuan bahasa Jepang Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 30),
                _buildLevelCard(
                  title: "Tes Kemampuan",
                  subtitle: "Ikuti pretest untuk mengetahui level Anda",
                  color: Colors.blue.shade200,
                  icon: Icons.quiz,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PretestPage()),
                    );
                  },
                ),
                // const SizedBox(height: 16),
                // _buildLevelCard(
                //   title: "Pemula",
                //   subtitle: "Belum pernah belajar bahasa Jepang",
                //   color: Colors.blue.shade200,
                //   icon: Icons.school,
                //   onPressed: () async {
                //     SharedPreferences prefs =
                //         await SharedPreferences.getInstance();
                //     int? userId = prefs.getInt('id');
                //     if (userId != null) {
                //       await sendLevelToDatabase(1);
                //     } else {
                //       print('User ID tidak ditemukan');
                //     }
                //   },
                // ),
                // const SizedBox(height: 16),
                // _buildLevelCard(
                //   title: "N5",
                //   subtitle: "Mengetahui huruf dasar bahasa Jepang",
                //   color: const Color.fromRGBO(100, 181, 246, 1),
                //   icon: Icons.language,
                //   onPressed: () async {
                //     SharedPreferences prefs =
                //         await SharedPreferences.getInstance();
                //     int? userId = prefs.getInt('id');
                //     if (userId != null) {
                //       await sendLevelToDatabase(2);
                //     } else {
                //       print('User ID tidak ditemukan');
                //     }
                //   },
                // ),
                // const SizedBox(height: 16),
                // _buildLevelCard(
                //   title: "N4",
                //   subtitle: "Mengetahui lebih dari 100 kanji dan 800 kosakata",
                //   color: Colors.blue.shade400,
                //   icon: Icons.auto_awesome,
                //   onPressed: () async {
                //     SharedPreferences prefs =
                //         await SharedPreferences.getInstance();
                //     int? userId = prefs.getInt('id');
                //     if (userId != null) {
                //       await sendLevelToDatabase(3);
                //     } else {
                //       print('User ID tidak ditemukan');
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color.withOpacity(0.8), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.withOpacity(0.7)),
            ],
          ),
        ),
      ),
    );
  }
}
