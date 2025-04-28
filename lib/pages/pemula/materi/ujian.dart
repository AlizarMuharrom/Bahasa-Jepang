import 'package:flutter/material.dart';
import 'package:bahasajepang/service/ujian_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UjianPemulaPage extends StatefulWidget {
  const UjianPemulaPage({super.key});

  @override
  State<UjianPemulaPage> createState() => _UjianPemulaPageState();
}

class _UjianPemulaPageState extends State<UjianPemulaPage> {
  final UjianService _ujianService = UjianService();
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<dynamic> _soalList = [];
  List<Map<String, dynamic>> _jawabanUser = [];
  Map<String, dynamic>? _hasilUjian;
  String? _token;
  String? _errorMessage;
  int? _ujianId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // 1. Ambil token
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');

      if (_token == null) {
        throw Exception('Silakan login kembali');
      }

      // 2. Ambil daftar ujian untuk level pemula (ID 1)
      final ujianList = await _ujianService.getUjianByLevel(1);
      if (ujianList.isEmpty) {
        throw Exception('Tidak ada ujian tersedia untuk level pemula');
      }

      // 3. Simpan ID ujian pertama
      _ujianId = ujianList[0]['id'];

      // 4. Ambil soal ujian
      _soalList = await _ujianService.getSoalUjian(_ujianId!, _token!);
      if (_soalList.isEmpty) {
        throw Exception('Tidak ada soal tersedia untuk ujian ini');
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      _showErrorSnackbar(_errorMessage!);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleAnswerSelection(String answer) {
    setState(() => _selectedAnswer = answer);
  }

  Future<void> _submitAnswer() async {
    if (_selectedAnswer == null) {
      _showErrorSnackbar('Pilih jawaban terlebih dahulu');
      return;
    }

    try {
      // Simpan jawaban sementara
      _jawabanUser.add({
        'soal_id': _soalList[_currentQuestionIndex]['id'],
        'jawaban_user': _selectedAnswer!,
      });

      // Jika ini soal terakhir
      if (_currentQuestionIndex == _soalList.length - 1) {
        setState(() => _isSubmitting = true);

        // Submit semua jawaban ke backend
        _hasilUjian = await _ujianService.submitUjian(
          _ujianId!,
          _jawabanUser,
          _token!,
        );

        setState(() => _isSubmitting = false);
      } else {
        // Lanjut ke soal berikutnya
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = null;
        });
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showErrorSnackbar(
          'Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Memuat soal...'),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(
            _errorMessage ?? 'Terjadi kesalahan',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadInitialData,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    final currentQuestion = _soalList[_currentQuestionIndex];
    final pilihanJawaban =
        currentQuestion['pilihan_jawaban'] as Map<String, dynamic>? ?? {};

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _soalList.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          const SizedBox(height: 20),
          Text(
            'Soal ${_currentQuestionIndex + 1}/${_soalList.length}',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                currentQuestion['soal'] ?? 'Pertanyaan tidak tersedia',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: pilihanJawaban.length,
              itemBuilder: (context, index) {
                final optionKey = pilihanJawaban.keys.elementAt(index);
                final optionText = pilihanJawaban[optionKey];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  color:
                      _selectedAnswer == optionKey ? Colors.orange[100] : null,
                  child: ListTile(
                    title: Text(optionText ?? 'Opsi tidak tersedia'),
                    onTap: () => _handleAnswerSelection(optionKey),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    _currentQuestionIndex == _soalList.length - 1
                        ? 'Selesai'
                        : 'Lanjut',
                    style: const TextStyle(fontSize: 18),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_turned_in,
                color: Colors.green, size: 60),
            const SizedBox(height: 20),
            Text(
              'Ujian Selesai!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              'Skor Anda: ${_hasilUjian?['score'] ?? '0'}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            Text(
              'Jawaban benar: ${_hasilUjian?['jumlah_benar'] ?? '0'} dari ${_soalList.length} soal',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Kembali ke Materi'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Soal Pemula'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? _buildLoading()
          : _errorMessage != null
              ? _buildError()
              : _hasilUjian != null
                  ? _buildResult()
                  : _buildQuestion(),
    );
  }
}
