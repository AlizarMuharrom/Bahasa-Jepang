import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class KanjiPage extends StatefulWidget {
  const KanjiPage({super.key});

  @override
  _KanjiPageState createState() => _KanjiPageState();
}

class _KanjiPageState extends State<KanjiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image_splash.png',
              width: 200,
            ),
            _buildKanjiButton(
                "Kanji Tandoku", Colors.blue.shade200, '/kanji-tandoku4'),
            const SizedBox(height: 10),
            _buildKanjiButton("Kanji Okurigana",
                const Color.fromRGBO(100, 181, 246, 1), '/kanji-okurigana4'),
            const SizedBox(height: 10),
            _buildKanjiButton(
                "Kanji Jukugo", Colors.blue.shade400, '/kanji-jukugo4'),
          ],
        ),
      ),
    );
  }

  Widget _buildKanjiButton(String text, Color color, String route) {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: primaryTextColor, fontSize: 16),
        ),
      ),
    );
  }
}
