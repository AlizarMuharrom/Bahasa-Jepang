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
        backgroundColor: bgColor3,
        title: Text(
          "Riwayat Latihan",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: bgColor1,
      body: _hasilUjian == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<HasilUjianModel>>(
              future: _hasilUjian,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'));
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
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: bgColor2,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.description,
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
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Benar: ${hasil.jumlahBenar} | Skor: ${hasil.score.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hasil.createdAt.split('T').first,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
