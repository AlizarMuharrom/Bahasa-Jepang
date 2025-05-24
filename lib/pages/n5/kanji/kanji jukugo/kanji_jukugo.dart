import 'package:bahasajepang/pages/n5/kanji/kanji_service.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';

class KanjiJukugoPage extends StatefulWidget {
  const KanjiJukugoPage({super.key});

  @override
  _KanjiJukugoPageState createState() => _KanjiJukugoPageState();
}

class _KanjiJukugoPageState extends State<KanjiJukugoPage> {
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

      var kanjiList = await _kanjiService.fetchKanjiByKategori('jukugo');
      var filteredKanji = kanjiList
          .where((kanji) =>
              kanji["kategori"] == "jukugo" && kanji["level_id"] == 2)
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
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize =
        screenWidth / 3.5; // Menyesuaikan ukuran card berdasarkan lebar layar

    return Scaffold(
      backgroundColor: bgColor1.withOpacity(0.95),
      appBar: AppBar(
        title: const Text(
          'Kanji Jukugo N5',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 4,
        shadowColor: bgColor3.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
                  fillColor: bgColor2.withOpacity(0.7),
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
                ? Center(
                    child: CircularProgressIndicator(
                      color: bgColor2,
                    ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio:
                                    0.85, // Nilai yang lebih optimal
                                mainAxisExtent:
                                    cardSize, // Gunakan ukuran dinamis
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
            '/detail-jukugo',
            arguments: kanji,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8), // Padding yang lebih kecil
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    kanji["judul"] ?? '?',
                    style: const TextStyle(
                      fontSize: 30, // Ukuran font yang lebih moderat
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    kanji["nama"] ?? '',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.9),
                    ),
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
