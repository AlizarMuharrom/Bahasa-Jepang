import 'package:bahasajepang/pages/pemula/setting/edit_page.dart';
import 'package:bahasajepang/pages/pemula/setting/riwayat_ujian.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  print("SEMUA ISI PREFS LOGOUT:");
  prefs.getKeys().forEach((key) {
    print("$key : ${prefs.get(key)}");
  });
  await prefs.clear();

  // Pindah ke halaman login dan hapus semua halaman sebelumnya
  Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false);
}

class _SettingPageState extends State<SettingPage> {
  bool _isKetentuanExpanded = false;
  String? username;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Panggil fungsi untuk memuat data user
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id');
      username =
          prefs.getString('username'); // Ambil username dari SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: bgColor2,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Bagian Atas (Header)
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade300,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Halo, ${username ?? 'Pengguna'}", // Tampilkan username atau 'Pengguna' jika null
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (userId != null) {
                                            // Tambahkan null check
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfilePage(
                                                        userId: userId!),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "User ID tidak ditemukan")),
                                            );
                                          }
                                        },
                                        child: Text("Edit",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _logout(context);
                                    },
                                    child: Text("Keluar",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      // Bagian Ketentuan dengan Dropdown
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isKetentuanExpanded = !_isKetentuanExpanded;
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ketentuan",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    _isKetentuanExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedCrossFade(
                              firstChild: Container(),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "Pada tahapan tes atau latihan, terdapat batasan nilai supaya bisa lanjut ke level berikutnya, yaitu minimal 100% jawaban benar.\n\nPada halaman kanji, terdapat voice record dan button untuk mencoba menulis kanji pada layar handphone.\n\nMateri dari aplikasi ini, semuanya berreferensi dari buku Minna no Nihongo 1 dan Minna no Nihongo 2, Untuk level N5 dan N4.\n\nMohon maaf jika terdapat banyak kekurangan, karena aplikasi ini merupakan aplikasi yang dikerjakan oleh tim kecil dan masih kurang pengalaman.",
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              crossFadeState: _isKetentuanExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 300),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      riwayatButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget riwayatButton() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.only(top: 30),
      child: TextButton(
        onPressed: () {
          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const RiwayatUjianPage()),
);
        },
        style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text(
          'Riwayat Latihan',
          style: primaryTextStyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
      ),
    );
  }
}
