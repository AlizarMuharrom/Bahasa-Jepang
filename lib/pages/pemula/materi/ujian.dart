import 'dart:async';
import 'package:bahasajepang/theme.dart';
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

  late Duration _duration;
  late Timer _timer;
  bool _timeUp = false;

  @override
  void initState() {
    super.initState();
    _duration = const Duration(minutes: 1);
    _loadInitialData();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_duration.inSeconds == 0) {
        _timer.cancel();
        setState(() {
          _timeUp = true;
        });
        _autoSubmitAnswers();
      } else {
        setState(() {
          _duration = _duration - oneSecond;
        });
      }
    });
  }

  Future<void> _autoSubmitAnswers() async {
    try {
      setState(() => _isSubmitting = true);

      _hasilUjian = await _ujianService.submitUjian(
        _ujianId!,
        _jawabanUser,
        _token!,
      );

      setState(() => _isSubmitting = false);
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showErrorSnackbar(
          'Error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');

      if (_token == null) {
        throw Exception('Silakan login kembali');
      }

      final ujianList = await _ujianService.getUjianByLevel(1);
      if (ujianList.isEmpty) {
        throw Exception('Tidak ada ujian tersedia untuk level pemula');
      }

      // 3. Save first exam ID
      _ujianId = ujianList[0]['id'];

      // 4. Get exam questions
      _soalList = await _ujianService.getSoalUjian(_ujianId!, _token!);
      if (_soalList.isEmpty) {
        throw Exception('Tidak ada soal tersedia untuk ujian ini');
      }

      // Start the timer after questions are loaded
      _startTimer();

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
      // Save temporary answer
      _jawabanUser.add({
        'soal_id': _soalList[_currentQuestionIndex]['id'],
        'jawaban_user': _selectedAnswer!,
      });

      // If this is the last question or time is up
      if (_currentQuestionIndex == _soalList.length - 1 || _timeUp) {
        setState(() => _isSubmitting = true);

        // Submit all answers to backend
        _hasilUjian = await _ujianService.submitUjian(
          _ujianId!,
          _jawabanUser,
          _token!,
        );

        setState(() => _isSubmitting = false);
      } else {
        // Move to next question
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
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
          // Timer display
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _duration.inSeconds <= 30 ? bgColor1 : bgColor2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(_duration),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        _duration.inSeconds <= 30 ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _soalList.length,
            backgroundColor: bgColor1,
            valueColor: AlwaysStoppedAnimation<Color>(bgColor1),
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
                  color: _selectedAnswer == optionKey ? bgColor1 : null,
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
              backgroundColor: bgColor1,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isSubmitting
                ? CircularProgressIndicator(color: bgColor2)
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
              _timeUp ? 'Waktu Habis!' : 'Ujian Selesai!',
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
            if (_timeUp) ...[
              const SizedBox(height: 15),
              const Text(
                'Waktu ujian telah habis, jawaban otomatis dikirim',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor2,
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
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: const Text('Latihan Soal Pemula'),
        backgroundColor: bgColor2,
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
