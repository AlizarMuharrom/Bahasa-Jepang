import 'package:bahasajepang/pages/n5/materi/detail_materi.dart';
import 'package:bahasajepang/pages/n5/materi/materi_service.dart';
import 'package:bahasajepang/pages/n5/materi/ujian.dart';
import 'package:bahasajepang/service/ujian_service.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class MateriN5Page extends StatefulWidget {
  const MateriN5Page({super.key});

  @override
  State<MateriN5Page> createState() => _MateriN5PageState();
}

class _MateriN5PageState extends State<MateriN5Page> {
  final MateriService _materiService = MateriService();
  late Future<List<dynamic>> _materiFuture;
  bool _isLoading = true;
  List<dynamic> _materiList = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _materiFuture = _loadMateriData();
    _materiFuture.catchError((error) {});
  }

  Future<List<dynamic>> _loadMateriData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final data = await _materiService.getMateriByLevel('N5');

      setState(() {
        _materiList = data;
        _isLoading = false;
      });

      return data;
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');

      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }

      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: const Text('Materi N5'),
        backgroundColor: bgColor2,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadMateriData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_materiList.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada materi tersedia',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMateriData,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _materiList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final materi = _materiList[index];
                  return _buildMateriCard(materi);
                },
              ),
            ),
            _buildLatihanSoalCard(), // Widget latihan soal di bawah list materi
          ],
        ),
      ),
    );
  }

  Widget _buildMateriCard(Map<String, dynamic> materi) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      color: bgColor2,
      child: ListTile(
        title: Text(
          materi['judul'] ?? 'Judul tidak tersedia',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailMateriN5Page(materiId: materi['id']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLatihanSoalCard() {
    final UjianService ujianService = UjianService();

    return FutureBuilder<List<dynamic>>(
      future: ujianService.getUjianByLevel(2), // Level pemula
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final ujianList = snapshot.data ?? [];

        if (ujianList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Tidak ada ujian tersedia'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ujianList.length,
          itemBuilder: (context, index) {
            final ujian = ujianList[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              color: bgColor2,
              child: ListTile(
                leading: Icon(Icons.quiz, color: bgColor1),
                title: Text(
                  ujian['judul'] ?? 'Latihan Soal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  ujian['deskripsi'] ?? 'Jumlah soal: ${ujian['jumlah_soal']}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UjianN5Page(ujianId: ujian['id']),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
