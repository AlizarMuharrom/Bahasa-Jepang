import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/model/kanji_tandoku.model.dart';
import 'package:flutter/material.dart';

class KanjiTandokuPage extends StatefulWidget {
  const KanjiTandokuPage({super.key});

  @override
  _KanjiTandokuPageState createState() => _KanjiTandokuPageState();
}

class _KanjiTandokuPageState extends State<KanjiTandokuPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredKanji =
      List.from(kanjiList); // ✅ Inisialisasi langsung dengan model

  void _filterKanji(String query) {
    setState(() {
      _filteredKanji = kanjiList
          .where((kanji) =>
              kanji["title"]!.contains(query)) // ✅ Akses 'title' dari Map
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kanji Tandoku"),
        backgroundColor: Colors.blue.shade300,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.blue.shade100,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: _filterKanji,
              decoration: InputDecoration(
                hintText: "Cari kanji...",
                filled: true,
                fillColor: Colors.blue.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 kolom sesuai gambar
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _filteredKanji.length,
                itemBuilder: (context, index) {
                  return _kanjiButton(_filteredKanji[index], context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kanjiButton(Map<String, String> kanji, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, kanji["route"]!);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            kanji["title"]!,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
