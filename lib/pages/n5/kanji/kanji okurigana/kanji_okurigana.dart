import 'package:bahasajepang/pages/n5/kanji/kanji%20okurigana/model/kanji_okurigana.model.dart';
import 'package:flutter/material.dart';

class KanjiOkuriganaPage extends StatefulWidget {
  const KanjiOkuriganaPage({super.key});

  @override
  _KanjiOkuriganaPageState createState() => _KanjiOkuriganaPageState();
}

class _KanjiOkuriganaPageState extends State<KanjiOkuriganaPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredKanji = List.from(kanjiOkuriganaList);

  void _filterKanji(String query) {
    setState(() {
      _filteredKanji = kanjiOkuriganaList
          .where((kanji) => kanji["title"]!.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kanji Okurigana"),
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
                  crossAxisCount: 4,
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
