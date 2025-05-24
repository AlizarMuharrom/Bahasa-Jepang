import 'package:bahasajepang/pages/pemula/materi/model/hasil_ujian.dart';
import 'package:bahasajepang/pages/pemula/setting/ujian_service.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatUjianPage extends StatefulWidget {
  const RiwayatUjianPage({super.key});

  @override
  State<RiwayatUjianPage> createState() => _RiwayatUjianPageState();
}

class _RiwayatUjianPageState extends State<RiwayatUjianPage> {
  Future<List<HasilUjianModel>>? _hasilUjian;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchData();
  }

  void _loadUserIdAndFetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId != null) {
      setState(() {
        _hasilUjian = fetchHasilUjian(userId);
      });
    } else {
      // Handle ketika userId tidak ditemukan
      setState(() {
        _hasilUjian = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Ujian',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 4,
        shadowColor: bgColor3.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: bgColor1,
      body: _hasilUjian == null
          ? Center(child: CircularProgressIndicator(color: bgColor2))
          : FutureBuilder<List<HasilUjianModel>>(
              future: _hasilUjian,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(color: bgColor2));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada riwayat ujian.'));
                }

                final data = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final hasil = data[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: bgColor2,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.description,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hasil.judulUjian,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '✅ Benar: ${hasil.jumlahBenar} | 📊 Skor: ${hasil.score.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 14, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      hasil.createdAt.split('T').first,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Selesai',
                                    style: GoogleFonts.poppins(
                                      color: bgColor2,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
