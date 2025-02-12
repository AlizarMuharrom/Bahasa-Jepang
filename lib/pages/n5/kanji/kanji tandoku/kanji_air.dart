import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/model/kanji_air.model.dart';
import 'package:flutter/material.dart';

class DetailAirPage extends StatefulWidget {
  DetailAirPage({super.key});

  @override
  State<DetailAirPage> createState() => _DetailAirPageState();
}

class _DetailAirPageState extends State<DetailAirPage> {
  final Map<String, dynamic> kanjiData = detailAirList[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        backgroundColor: Colors.blue.shade300,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    kanjiData["judul"],
                    style: const TextStyle(
                        fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    kanjiData["nama"],
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _readingWidget("Kunyomi", kanjiData["kunyomi"]),
                _readingWidget("Onyomi", kanjiData["onyomi"]),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: kanjiData["kanjiGabungan"].map<Widget>((kanji) {
                  return ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () {},
                    ),
                    title: Row(
                      children: [
                        Text(
                          kanji["kanji"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          kanji["furigana"],
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    subtitle: Text(kanji["arti"]),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _readingWidget(String title, List<String> readings) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$title : ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(readings.join("  ")),
        ],
      ),
    );
  }
}
