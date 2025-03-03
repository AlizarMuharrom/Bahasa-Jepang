import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final List<dynamic> soal;

  const TestPage({super.key, required this.soal});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswered = false;
  late List<String> allAnswers; // Simpan daftar jawaban yang sudah diacak

  @override
  void initState() {
    super.initState();
    // Acak jawaban hanya sekali saat widget pertama kali dibangun
    _shuffleAnswers();
  }

  void _shuffleAnswers() {
    final currentQuestion = widget.soal[currentQuestionIndex];
    allAnswers = [
      currentQuestion['jawaban'],
      ...currentQuestion['jawabanSalah']
    ]..shuffle(); // Acak urutan jawaban
  }

  void _checkAnswer(String selectedAnswer, String correctAnswer) {
    setState(() {
      isAnswered = true;
      if (selectedAnswer == correctAnswer) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.soal.length - 1) {
        currentQuestionIndex++;
        isAnswered = false;
        _shuffleAnswers(); // Acak jawaban untuk pertanyaan berikutnya
      } else {
        // Tampilkan hasil akhir
        _showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hasil Test"),
          content: Text("Skor Anda: $score dari ${widget.soal.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text("Selesai"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.soal.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("Tidak ada soal yang tersedia."),
        ),
      );
    }

    final currentQuestion = widget.soal[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pertanyaan ${currentQuestionIndex + 1}/${widget.soal.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              currentQuestion['pertanyaan'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ...allAnswers.map((answer) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: isAnswered
                      ? null
                      : () => _checkAnswer(answer, currentQuestion['jawaban']),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: isAnswered
                        ? (answer == currentQuestion['jawaban']
                            ? Colors.green
                            : Colors.red)
                        : null,
                  ),
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 32),
            if (isAnswered)
              Center(
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    currentQuestionIndex < widget.soal.length - 1
                        ? "Pertanyaan Berikutnya"
                        : "Lihat Hasil",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
