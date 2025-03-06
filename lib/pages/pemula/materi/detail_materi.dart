import 'package:bahasajepang/pages/pemula/materi/isi_materi.dart';
import 'package:bahasajepang/pages/pemula/materi/test_page.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class DetailMateriPage extends StatefulWidget {
  final Map<String, dynamic> materi;

  const DetailMateriPage({super.key, required this.materi});

  @override
  State<DetailMateriPage> createState() => _DetailMateriPageState();
}

class _DetailMateriPageState extends State<DetailMateriPage> {
  bool isPembukaanExpanded = false;
  bool isMateriExpanded = false;
  bool isPenutupExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: Text(
          widget.materi['judul'],
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        backgroundColor: bgColor3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                title: const Text('Pembukaan'),
                initiallyExpanded: isPembukaanExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    isPembukaanExpanded = expanded;
                  });
                },
                children: (widget.materi['pembukaan'] as List).map((item) {
                  return ListTile(
                    title: Text(item['judul']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IsiMateriPage(
                            items: widget.materi['pembukaan'],
                            initialIndex:
                                widget.materi['pembukaan'].indexOf(item),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Materi'),
                initiallyExpanded: isMateriExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    isMateriExpanded = expanded;
                  });
                },
                children: (widget.materi['materi'] as List).map((item) {
                  return ListTile(
                    title: Text(item['judul']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IsiMateriPage(
                            items: widget.materi['materi'],
                            initialIndex: widget.materi['materi'].indexOf(item),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Penutup'),
                initiallyExpanded: isPenutupExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    isPenutupExpanded = expanded;
                  });
                },
                children: (widget.materi['penutup'] as List)
                    .where((item) => item.containsKey('judul'))
                    .map((item) {
                  return ListTile(
                    title: Text(item['judul']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPage(
                            soal: widget.materi['penutup'][1]['soal'] ?? [],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
