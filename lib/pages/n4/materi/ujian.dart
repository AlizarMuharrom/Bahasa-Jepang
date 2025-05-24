import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bahasajepang/service/ujian_service.dart';
import 'package:bahasajepang/service/API_config.dart';
import 'package:bahasajepang/theme.dart';

class UjianN4Page extends StatefulWidget {
  final int ujianId;

  const UjianN4Page({Key? key, required this.ujianId}) : super(key: key);

  @override
  State<UjianN4Page> createState() => _UjianN4PageState();
}

class _UjianN4PageState extends State<UjianN4Page> {
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

  late Duration _duration;
  late Timer _timer;
  bool _timeUp = false;

  @override
  void initState() {
    super.initState();
    _duration = const Duration(minutes: 2);
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
        widget.ujianId,
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

      _soalList = await _ujianService.getSoalUjian(widget.ujianId, _token!);
      if (_soalList.isEmpty) {
        throw Exception('Tidak ada soal tersedia untuk ujian ini');
      }

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

  Future<void> sendLevelToDatabase(int level_id) async {
    const endpoint = "/update-level";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      if (userId == null) {
        throw Exception('User ID tidak ditemukan');
      }

      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'level_id': level_id}),
      );

      if (response.statusCode == 200) {
        await prefs.setInt('levelId', level_id);
        Navigator.pushNamedAndRemoveUntil(
            context, level_id == 3 ? '/n4' : '/level', (route) => false);
      } else {
        throw Exception('Failed to update level: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Error: ${e.toString()}');
    }
  }

  Future<void> _submitAnswer() async {
    if (_selectedAnswer == null) {
      _showErrorSnackbar('Pilih jawaban terlebih dahulu');
      return;
    }

    try {
      _jawabanUser.add({
        'soal_id': _soalList[_currentQuestionIndex]['id'],
        'jawaban_user': _selectedAnswer!,
      });

      if (_currentQuestionIndex == _soalList.length - 1 || _timeUp) {
        setState(() => _isSubmitting = true);
        _hasilUjian = await _ujianService.submitUjian(
          widget.ujianId,
          _jawabanUser,
          _token!,
        );
        setState(() => _isSubmitting = false);
      } else {
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(bgColor2,),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Memuat soal...',
            style: TextStyle(
              color: Colors.blue.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[400],
            size: 50,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _errorMessage ?? 'Terjadi kesalahan',
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadInitialData,
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
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
          // Timer and progress
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 20,
                          color:
                              _duration.inSeconds <= 30 ? Colors.red : bgColor2,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDuration(_duration),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _duration.inSeconds <= 30
                                ? Colors.red
                                : bgColor2,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Soal ${_currentQuestionIndex + 1}/${_soalList.length}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _soalList.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(bgColor2),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Question card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                currentQuestion['soal'] ?? 'Pertanyaan tidak tersedia',
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Answer options
          Expanded(
            child: ListView.separated(
              itemCount: pilihanJawaban.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final optionKey = pilihanJawaban.keys.elementAt(index);
                final optionText = pilihanJawaban[optionKey];

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _handleAnswerSelection(optionKey),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedAnswer == optionKey
                            ? bgColor2.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedAnswer == optionKey
                              ? bgColor2
                              : Colors.grey.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedAnswer == optionKey
                                  ? bgColor2
                                  : Colors.grey.withOpacity(0.2),
                              border: Border.all(
                                color: _selectedAnswer == optionKey
                                    ? bgColor2
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            child: _selectedAnswer == optionKey
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              optionText ?? 'Opsi tidak tersedia',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Submit button
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor3,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _currentQuestionIndex == _soalList.length - 1
                        ? 'Selesai Ujian'
                        : 'Lanjut ke Soal Berikutnya',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    final score = _hasilUjian?['score'] ?? 0;
    final isPerfectScore = score == 100;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bgColor1.withOpacity(0.1),
            bgColor1.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      isPerfectScore
                          ? Icons.star
                          : _timeUp
                              ? Icons.timer_off
                              : Icons.assignment_turned_in,
                      color: isPerfectScore
                          ? Colors.amber
                          : _timeUp
                              ? Colors.orange
                              : Colors.green,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isPerfectScore
                          ? 'Sempurna!'
                          : _timeUp
                              ? 'Waktu Habis!'
                              : 'Ujian Selesai!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Skor Anda',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: bgColor2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${_hasilUjian?['jumlah_benar'] ?? '0'} dari ${_soalList.length} soal benar',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    if (_timeUp) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Waktu ujian telah habis, jawaban otomatis dikirim',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 30),
                    if (isPerfectScore)
                      _buildLevelButton(
                        "Lanjut ke Level N4",
                        Colors.blueAccent,
                        () => sendLevelToDatabase(3),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bgColor2,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Kembali ke Materi'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1.withOpacity(0.95),
      appBar: AppBar(
        title: const Text(
          'Latihan Soal N4',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 4,
        shadowColor: bgColor2.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
