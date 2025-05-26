import 'package:bahasajepang/pages/n5/materi/materi_service.dart';
import 'package:bahasajepang/pages/n5/materi/isi_materi.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class DetailMateriN5Page extends StatefulWidget {
  final int materiId;

  const DetailMateriN5Page({super.key, required this.materiId});

  @override
  State<DetailMateriN5Page> createState() => _DetailMateriN5PageState();
}

class _DetailMateriN5PageState extends State<DetailMateriN5Page>
    with SingleTickerProviderStateMixin {
  final MateriService _materiService = MateriService();
  late Future<dynamic> _materiDetailFuture;
  bool _isLoading = true;
  dynamic _materiData;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _materiDetailFuture = _loadMateriDetails();
  }

  Future<dynamic> _loadMateriDetails() async {
    try {
      final data = await _materiService.getMateriDetails(widget.materiId);
      if (data == null) {
        throw Exception('Data materi tidak ditemukan');
      }

      setState(() {
        _materiData = data;
        _isLoading = false;
      });
      return data;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Error',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Gagal memuat materi: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
              style: TextButton.styleFrom(
                foregroundColor: bgColor2,
              ),
            ),
          ],
        ),
      );

      throw e;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1.withValues(alpha:0.95),
      appBar: AppBar(
        title: Text(
          _isLoading ? 'Loading...' : _materiData['judul'] ?? 'Materi N5',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 4,
        shadowColor: bgColor2.withValues(alpha:0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(bgColor2),
              ),
            );
          }

          return RefreshIndicator(
            color: bgColor2,
            backgroundColor: bgColor1,
            onRefresh: _loadMateriDetails,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: bgColor2.withValues(alpha:0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header clickable
                        InkWell(
                          onTap: _toggleExpand,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Daftar Sub Materi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                RotationTransition(
                                  turns: _animation,
                                  child: Icon(
                                    Icons.expand_more,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Sub materi list
                        SizeTransition(
                          sizeFactor: _animation,
                          child: Column(
                            children: _materiData['details'] != null
                                ? _materiData['details']
                                    .asMap()
                                    .entries
                                    .map<Widget>((entry) {
                                    final index = entry.key;
                                    final detail = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 4.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    IsiMateriN5Page(
                                                  items: _materiData['details'],
                                                  initialIndex: index,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: bgColor1.withValues(alpha:0.8),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 28,
                                                  height: 28,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: bgColor2
                                                        .withValues(alpha:0.2),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: bgColor2
                                                          .withValues(alpha:0.5),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Text(
                                                    detail['judul'] ??
                                                        'Sub Materi',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  size: 16,
                                                  color: Colors.white
                                                      .withValues(alpha:0.7),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Informasi tambahan tentang level N5
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: bgColor2.withValues(alpha:0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white.withValues(alpha:0.9),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tentang JLPT N5',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'JLPT N5 adalah level paling dasar dalam ujian kemampuan bahasa Jepang. '
                          'Materi ini mencakup kosakata dasar, tata bahasa sederhana, dan kalimat pendek.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha:0.9),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol navigasi cepat
                  if (_materiData['details'] != null &&
                      _materiData['details'].isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor2.withValues(alpha:0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mulai Belajar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IsiMateriN5Page(
                                      items: _materiData['details'],
                                      initialIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: bgColor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Mulai dari Sub Materi Pertama',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
