import 'package:bahasajepang/pages/pemula/materi/detail_materi.dart';
import 'package:bahasajepang/pages/pemula/materi/materi_service.dart';
import 'package:bahasajepang/pages/pemula/materi/ujian.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  final MateriService _materiService = MateriService();
  late Future<List<dynamic>> _materiFuture;
  bool _isLoading = true;
  List<dynamic> _materiList = [];

  @override
  void initState() {
    super.initState();
    _materiFuture = _loadMateriData();
  }

  Future<List<dynamic>> _loadMateriData() async {
    try {
      final data = await _materiService.fetchAllMateri();
      setState(() {
        _materiList = data;
        _isLoading = false;
      });
      print("MATERI : $data");
      return data;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: const Text('Daftar Materi'),
        backgroundColor: bgColor2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMateriData,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                            bottom: _materiList.isEmpty ? 0 : 16),
                        itemCount: _materiList.length,
                        itemBuilder: (context, index) {
                          final materi = _materiList[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            color: bgColor2,
                            child: ListTile(
                              title: Text(
                                materi['judul'],
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailMateriPage(
                                      materiId: materi['id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    _buildLatihanSoalCard(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLatihanSoalCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: bgColor2,
      child: ListTile(
        leading: Icon(Icons.quiz, color: bgColor1),
        title: const Text(
          'Latihan Soal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: const Text('Uji pemahaman Anda dengan latihan soal'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UjianPemulaPage(),
            ),
          );
        },
      ),
    );
  }
}
