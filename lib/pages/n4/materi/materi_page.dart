import 'package:bahasajepang/pages/n4/materi/detail_materi.dart';
import 'package:bahasajepang/pages/n4/materi/ujian.dart';
import 'package:bahasajepang/pages/n5/materi/materi_service.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class MateriN4Page extends StatefulWidget {
  const MateriN4Page({super.key});

  @override
  State<MateriN4Page> createState() => _MateriN4PageState();
}

class _MateriN4PageState extends State<MateriN4Page> {
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
    _materiFuture.catchError((error) {
      // Error sudah ditangani di _loadMateriData
    });
  }

  Future<List<dynamic>> _loadMateriData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final data = await _materiService.getMateriByLevel('N4');

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

      // Tampilkan snackbar error
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
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tidak ada materi tersedia',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildLatihanSoalCard(), // Tetap tampilkan latihan soal meski materi kosong
        ],
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
              builder: (context) => DetailMateriN4Page(materiId: materi['id']),
            ),
          );
        },
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
              builder: (context) => const UjianN4Page(),
            ),
          );
        },
      ),
    );
  }
}
