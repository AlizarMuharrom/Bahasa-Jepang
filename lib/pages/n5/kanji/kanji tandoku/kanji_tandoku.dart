import 'package:bahasajepang/pages/n5/kanji/kanji_service.dart';
import 'package:flutter/material.dart';

class KanjiTandokuPage extends StatefulWidget {
  const KanjiTandokuPage({super.key});

  @override
  _KanjiTandokuPageState createState() => _KanjiTandokuPageState();
}

class _KanjiTandokuPageState extends State<KanjiTandokuPage> {
  final TextEditingController _searchController = TextEditingController();
  final KanjiService _kanjiService = KanjiService();
  List<dynamic> _filteredKanji = [];
  List<dynamic> _allKanji = [];

  @override
  void initState() {
    super.initState();
    _fetchKanji();
  }

  Future<void> _fetchKanji() async {
    try {
      var kanjiList = await _kanjiService.fetchKanjiByKategori('tandoku');
      var filteredKanji =
          kanjiList.where((kanji) => kanji["kategori"] == "tandoku").toList();
      setState(() {
        _allKanji = filteredKanji;
        _filteredKanji = filteredKanji;
      });
    } catch (e) {
      print('Error fetching kanji: $e');
    }
  }

  void _filterKanji(String query) {
    setState(() {
      _filteredKanji = _allKanji
          .where((kanji) =>
              kanji["judul"].toLowerCase().contains(query.toLowerCase()))
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

  Widget _kanjiButton(dynamic kanji, BuildContext context) {
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
            kanji["judul"],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
