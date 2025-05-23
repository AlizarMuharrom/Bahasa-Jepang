import 'package:bahasajepang/pages/n5/kanji/kanji_service.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';

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
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchKanji();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchKanji() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      var kanjiList = await _kanjiService.fetchKanjiByKategori('tandoku');
      var filteredKanji = kanjiList
          .where((kanji) =>
              kanji["kategori"] == "tandoku" && kanji["level_id"] == 2)
          .toList();

      setState(() {
        _allKanji = filteredKanji;
        _filteredKanji = filteredKanji;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data kanji';
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _filteredKanji = _allKanji;
      });
      return;
    }

    setState(() {
      _filteredKanji = _allKanji.where((kanji) {
        final judul = kanji["judul"]?.toString().toLowerCase() ?? '';
        final nama = kanji["nama"]?.toString().toLowerCase() ?? '';
        final kunyomi = kanji["kunyomi"]?.toString().toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        return judul.contains(queryLower) ||
            nama.contains(queryLower) ||
            kunyomi.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1.withOpacity(0.95),
      appBar: AppBar(
        title: const Text(
          'Kanji Tandoku N5',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor2,
        elevation: 4,
        shadowColor: bgColor2.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Cari kanji...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _filteredKanji.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada kanji yang ditemukan',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                              itemCount: _filteredKanji.length,
                              itemBuilder: (context, index) {
                                return _kanjiCard(
                                    _filteredKanji[index], context);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _kanjiCard(dynamic kanji, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail-tandoku',
            arguments: kanji,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                bgColor2.withOpacity(0.7),
                bgColor2.withOpacity(0.9),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kanji["judul"] ?? '?',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kanji["nama"] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
