import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';
import 'package:bahasajepang/service/API_config.dart';

class DetailTandoku4Page extends StatefulWidget {
  final AudioPlayer audioPlayer = AudioPlayer();

  DetailTandoku4Page({super.key});

  @override
  State<DetailTandoku4Page> createState() => _DetailTandoku4PageState();
}

class _DetailTandoku4PageState extends State<DetailTandoku4Page> {
  late Map<String, dynamic> kanjiData;
  bool _isPlaying = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    kanjiData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }

  void _showWritingModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WritingModal();
      },
    );
  }

  Future<void> _playVoice(String? voiceRecordPath) async {
    if (voiceRecordPath == null || voiceRecordPath.isEmpty) return;

    try {
      String fullUrl = ApiConfig.url + "/" + voiceRecordPath;
      await widget.audioPlayer.play(UrlSource(fullUrl));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio Tidak Tersedia'),
          backgroundColor: bgColor3,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1.withOpacity(0.95),
      appBar: AppBar(
        title: const Text(
          'Detail Kanji Tandoku',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Kanji Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgColor2.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kanji Display
                  Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      color: bgColor1,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          kanjiData["judul"] ?? '?',
                          style: const TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          kanjiData["nama"] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Kanji Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReadingCard('Kunyomi', kanjiData["kunyomi"]),
                        const SizedBox(height: 8),
                        _buildReadingCard('Onyomi', kanjiData["onyomi"]),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.volume_up,
                                color: bgColor2,
                              ),
                              onPressed: () {
                                _playVoice(kanjiData["voice_record"]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Contoh Penggunaan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor2,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                        Icons.format_quote,
                        color: bgColor1,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Contoh Penggunaan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (kanjiData["detail_kanji"] != null &&
                      (kanjiData["detail_kanji"] as List).isNotEmpty)
                    ...(kanjiData["detail_kanji"] as List).map<Widget>((kanji) {
                      return _buildExampleUsage(kanji);
                    }).toList()
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Tidak ada contoh penggunaan',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showWritingModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor2,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Coba Menulis Kanji",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingCard(String title, String? reading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor1,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            reading ?? '-',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleUsage(Map<String, dynamic> kanji) {
    return Card(
      color: bgColor1,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Warna bayangan
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // Posisi bayangan (x, y)
                    ),
                  ],
                  color: Colors.white),
              child: IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: bgColor2,
                ),
                onPressed: () {
                  _playVoice(kanji["voice_record"]);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kanji["kanji"] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kanji["romaji"] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                kanji["arti"] ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WritingModal extends StatefulWidget {
  @override
  _WritingModalState createState() => _WritingModalState();
}

class _WritingModalState extends State<WritingModal> {
  List<Offset> points = [];
  final GlobalKey _paintKey = GlobalKey();
  Rect? _drawingArea;

  void _clearDrawing() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Latihan Menulis Kanji",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Simpan ukuran area gambar setelah layout selesai
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final renderBox = _paintKey.currentContext?.findRenderObject()
                      as RenderBox?;
                  if (renderBox != null) {
                    final offset = renderBox.localToGlobal(Offset.zero);
                    setState(() {
                      _drawingArea = Rect.fromLTWH(
                        offset.dx,
                        offset.dy,
                        renderBox.size.width,
                        renderBox.size.height,
                      );
                    });
                  }
                });

                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (_drawingArea?.contains(details.globalPosition) ??
                          false) {
                        setState(() {
                          final localPosition =
                              _globalToLocal(details.globalPosition);
                          points.add(localPosition);
                        });
                      }
                    },
                    onPanUpdate: (details) {
                      if (_drawingArea?.contains(details.globalPosition) ??
                          false) {
                        setState(() {
                          final localPosition =
                              _globalToLocal(details.globalPosition);
                          points.add(localPosition);
                        });
                      } else {
                        // Tambahkan titik kosong ketika keluar area
                        setState(() {
                          points.add(Offset.zero);
                        });
                      }
                    },
                    onPanEnd: (details) {
                      setState(() {
                        points.add(Offset.zero);
                      });
                    },
                    child: CustomPaint(
                      key: _paintKey,
                      size: Size.infinite,
                      painter: DrawingPainter(points),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _clearDrawing,
                  child: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 4),
                      Text("Hapus", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor2,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Selesai"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Offset _globalToLocal(Offset global) {
    if (_drawingArea == null) return Offset.zero;
    return Offset(
      global.dx - _drawingArea!.left,
      global.dy - _drawingArea!.top,
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
