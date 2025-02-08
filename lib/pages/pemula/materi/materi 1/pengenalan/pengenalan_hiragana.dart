import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class PengenalanHiraganaPage extends StatefulWidget {
  const PengenalanHiraganaPage({super.key});

  @override
  State<PengenalanHiraganaPage> createState() => _PengenalanHiraganaPageState();
}

class _PengenalanHiraganaPageState extends State<PengenalanHiraganaPage> {
  int currentPage = 1;

  void nextPage() {
    if (currentPage < 3) {
      setState(() {
        currentPage++;
      });
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1, // Background penuh
      appBar: AppBar(
        backgroundColor: bgColor2,
        title: Text("Pengenalan Hiragana", style: primaryTextStyle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Halaman $currentPage",
                style: primaryTextStyle.copyWith(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage >
                    1)
                  ElevatedButton(
                    onPressed: prevPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: Text("Prev", style: primaryTextStyle),
                  ),
                if (currentPage <
                    3)
                  ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: Text("Next", style: primaryTextStyle),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
