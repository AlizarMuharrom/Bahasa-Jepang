import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/model/detail_kanji.model.dart';
import 'package:flutter/material.dart';

class KanjiTandokuPage extends StatefulWidget {
  const KanjiTandokuPage({super.key});

  @override
  _KanjiTandokuPageState createState() => _KanjiTandokuPageState();
}

class _KanjiTandokuPageState extends State<KanjiTandokuPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredKanji = List.from(detailTandokuList);

  void _filterKanji(String query) {
    setState(() {
      _filteredKanji = detailTandokuList
          .where((kanji) =>
              kanji["judul"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kanji Tandoku",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
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

  Widget _kanjiButton(Map<String, dynamic> kanji, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail-tandoku',
          arguments: kanji,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            kanji["judul"]!,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
