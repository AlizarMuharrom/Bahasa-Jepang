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
          title: const Text('Error'),
          content: Text('Gagal memuat materi: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: Text(
          _isLoading ? 'Loading...' : _materiData['judul'] ?? 'Materi N5',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor2,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMateriDetails,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header materi dengan expand/collapse
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: bgColor2,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Daftar Sub Materi',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ),
                                  RotationTransition(
                                    turns: _animation,
                                    child: Icon(
                                      Icons.expand_more,
                                      color: primaryTextColor,
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
                                                BorderRadius.circular(8),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      IsiMateriN5Page(
                                                    items:
                                                        _materiData['details'],
                                                    initialIndex: index,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    width: 1,
                                                  ),
                                                ),
                                                color: bgColor1,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: primaryColor
                                                          .withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      detail['judul'] ??
                                                          'Sub Materi',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: primaryTextColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 14,
                                                    color: Colors.grey
                                                        .withOpacity(0.6),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tentang JLPT N5',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'JLPT N5 adalah level paling dasar dalam ujian kemampuan bahasa Jepang. '
                            'Materi ini mencakup kosakata dasar, tata bahasa sederhana, dan kalimat pendek.',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
