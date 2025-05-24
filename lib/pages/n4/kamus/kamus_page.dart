import 'package:bahasajepang/pages/n5/kamus/kamus_service.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';
import 'package:bahasajepang/pages/n4/kamus/detail_kamus.dart';

class Kamus4Page extends StatefulWidget {
  const Kamus4Page({super.key});

  @override
  State<Kamus4Page> createState() => _Kamus4PageState();
}

class _Kamus4PageState extends State<Kamus4Page> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> _kamusesFuture;
  List<dynamic> _filteredKamus = [];
  List<dynamic> _allKamus = [];
  final KamusService _kamusService = KamusService();
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadKamusData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadKamusData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final kamuses = await _kamusService.fetchKamusesByLevel(3); // Level N5
      setState(() {
        _allKamus = kamuses;
        _filteredKamus = kamuses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _filteredKamus = _allKamus;
      });
      return;
    }

    setState(() {
      _filteredKamus = _allKamus.where((kamus) {
        final nama = kamus["nama"]?.toString().toLowerCase() ?? '';
        final judul = kamus["judul"]?.toString().toLowerCase() ?? '';
        final queryLower = query.toLowerCase();

        return nama.contains(queryLower) || judul.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1.withOpacity(0.95),
      appBar: AppBar(
        title: const Text(
          'Kamus N4',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 4,
        shadowColor: bgColor2.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.9)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
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
                  hintText: "Cari kamus...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: bgColor2,
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

            // List Kamus
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
                      : _filteredKamus.isEmpty
                          ? const Center(
                              child: Text('Tidak ada hasil yang ditemukan'),
                            )
                          : ListView.builder(
                              itemCount: _filteredKamus.length,
                              itemBuilder: (context, index) {
                                final item = _filteredKamus[index];
                                return Card(
                                  color: bgColor2,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailKamus4Page(
                                                  kamusId: item["id"]),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item["judul"] ??
                                                      'Tidak ada judul',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item["nama"] ??
                                                      'Tidak ada nama',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: bgColor1,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
