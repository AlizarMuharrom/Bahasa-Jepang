import 'package:bahasajepang/pages/pretest.model.dart';
import 'package:bahasajepang/service/API_config.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class PretestPage extends StatefulWidget {
  const PretestPage({super.key});

  @override
  _PretestPageState createState() => _PretestPageState();
}

class _PretestPageState extends State<PretestPage> {
  int currentQuestionIndex = 0;
  List<int?> userAnswers = List.filled(pretestQuestions.length, null);
  int? userId;
  late Timer _timer;
  int _remainingTime = 120; // 2 menit dalam detik

  @override
  void initState() {
    super.initState();
    loadUserId();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_remainingTime == 0) {
          timer.cancel();
          _timeUp();
        } else {
          setState(() {
            _remainingTime--;
          });
        }
      },
    );
  }

  void _timeUp() {
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == null) {
        userAnswers[i] = -1;
      }
    }
    final result = calculateTestResult();
    _handleTestResult(result);
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id');
    });
  }

  void answerQuestion(int answerIndex) {
    setState(() {
      userAnswers[currentQuestionIndex] = answerIndex;
    });

    if (currentQuestionIndex < pretestQuestions.length - 1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentQuestionIndex++;
        });
      });
    } else {
      _timer.cancel();
      final result = calculateTestResult();
      _handleTestResult(result);
    }
  }

  Map<String, dynamic> calculateTestResult() {
    int pemulaCorrect = 0;
    int n5Correct = 0;

    for (int i = 0; i < pretestQuestions.length; i++) {
      if (userAnswers[i] == pretestQuestions[i]["correctAnswer"]) {
        if (pretestQuestions[i]["level"] == "pemula") {
          pemulaCorrect++;
        } else {
          n5Correct++;
        }
      }
    }

    int totalScore =
        ((pemulaCorrect + n5Correct) / pretestQuestions.length * 100).round();

    int recommendedLevel;
    if (totalScore < 30) {
      recommendedLevel = 1;
    } else if (totalScore < 60) {
      recommendedLevel = 2;
    } else {
      recommendedLevel = 3;
    }

    return {
      "totalScore": totalScore,
      "pemulaCorrect": pemulaCorrect,
      "n5Correct": n5Correct,
      "recommendedLevel": recommendedLevel,
      "totalQuestions": pretestQuestions.length,
    };
  }

  Future<void> _handleTestResult(Map<String, dynamic> result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level_id', result["recommendedLevel"]);
    await sendLevelToDatabase(result["recommendedLevel"]);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hasil Pretest"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Skor Anda: ${result["totalScore"]}%"),
              const SizedBox(height: 8),
              Text("Benar (Pemula): ${result["pemulaCorrect"]}/10"),
              Text("Benar (N5): ${result["n5Correct"]}/10"),
              const SizedBox(height: 16),
              Text(
                "Level yang direkomendasikan: ${_getLevelName(result["recommendedLevel"])}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToLevel(result["recommendedLevel"]);
              },
              child: const Text("LANJUT"),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendLevelToDatabase(int level_id) async {
    const endpoint = "/update-level";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      if (userId == null) {
        print('User ID tidak ditemukan');
        return;
      }

      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'level_id': level_id}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Response: ${jsonResponse}');
      } else {
        print('Failed to send level. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return "Pemula";
      case 2:
        return "N5";
      case 3:
        return "N4";
      default:
        return "-";
    }
  }

  void _navigateToLevel(int level) {
    final routes = {
      1: '/pemula',
      2: '/n5',
      3: '/n4',
    };

    if (routes.containsKey(level)) {
      Navigator.pushNamedAndRemoveUntil(
          context, routes[level]!, (route) => false);
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final question = pretestQuestions[currentQuestionIndex];
    final bool isTimeCritical = _remainingTime <= 30;

    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: const Text(
          'Tes Penempatan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Header Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor2.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: bgColor3.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Timer with animated background
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isTimeCritical
                            ? Colors.red.withOpacity(0.2)
                            : bgColor3.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer,
                            color: isTimeCritical ? Colors.red : bgColor3,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(_remainingTime),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isTimeCritical ? Colors.red : bgColor3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress indicator with label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Soal ${currentQuestionIndex + 1}/${pretestQuestions.length}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: (currentQuestionIndex + 1) /
                              pretestQuestions.length,
                          backgroundColor: bgColor1,
                          color: bgColor3,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Question Card
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                question["question"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: bgColor3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Pilih jawaban yang benar:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Options List
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: question["options"].length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final option = question["options"][index];
                          final isSelected =
                              userAnswers[currentQuestionIndex] == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected ? bgColor3 : Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => answerQuestion(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.white
                                                : bgColor3,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
