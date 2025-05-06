import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';
import 'package:bahasajepang/service/API_config.dart';

class DetailOkuriganaPage extends StatefulWidget {
  final AudioPlayer audioPlayer = AudioPlayer();

  DetailOkuriganaPage({super.key});

  @override
  State<DetailOkuriganaPage> createState() => _DetailOkuriganaPageState();
}

class _DetailOkuriganaPageState extends State<DetailOkuriganaPage> {
  late Map<String, dynamic> kanjiData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    kanjiData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  void _showWritingModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WritingModal();
      },
    );
  }

  // Fungsi untuk memutar suara dari URL
  void _playVoice(String voiceRecordPath) async {
    try {
      String fullUrl = ApiConfig.url + "/" + voiceRecordPath;
      await widget.audioPlayer.play(UrlSource(fullUrl));
    } catch (e) {
      print("Error playing voice: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail",
          style: TextStyle(fontSize: 18),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kotak Kanji
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 130,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          kanjiData["judul"],
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          kanjiData["nama"],
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kunyomi
                        _readingWidget("Kunyomi", kanjiData["kunyomi"]),
                        const SizedBox(height: 5),
                        // Onyomi
                        _readingWidget("Onyomi", kanjiData["onyomi"]),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.volume_up),
                                onPressed: () {
                                  // Memutar voice record dari judul kanji
                                  _playVoice(kanjiData["voice_record"]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children:
                    (kanjiData["detail_kanji"] as List).map<Widget>((kanji) {
                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          // Memutar voice record dari kanji gabungan
                          _playVoice(kanji["voice_record"]);
                        },
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kanji["romaji"],
                              style: TextStyle(
                                  fontSize: 14, color: secondaryTextColor),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              kanji["kanji"],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          kanji["arti"],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Membuat lebar button full width
              child: ElevatedButton(
                onPressed: () => _showWritingModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade200,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15), // Hanya vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Coba",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _readingWidget(String title, String reading) {
    return Container(
      width: double.infinity, // Lebar container sama
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$title : ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(reading),
        ],
      ),
    );
  }
}

// Modal untuk menulis (tidak diubah)
class WritingModal extends StatefulWidget {
  @override
  _WritingModalState createState() => _WritingModalState();
}

class _WritingModalState extends State<WritingModal> {
  List<Offset> points = [];
  final GlobalKey _paintKey = GlobalKey();

  void _clearDrawing() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      RenderBox renderBox = _paintKey.currentContext!
                          .findRenderObject() as RenderBox;
                      Offset localPosition =
                          renderBox.globalToLocal(details.globalPosition);
                      points = List.from(points)..add(localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    points.add(Offset.zero);
                  },
                  child: CustomPaint(
                    key: _paintKey,
                    size: Size.infinite,
                    painter: DrawingPainter(points),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: _clearDrawing,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Kembali"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
