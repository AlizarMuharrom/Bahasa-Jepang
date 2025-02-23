import 'package:flutter/material.dart';

class DetailMateriPage extends StatefulWidget {
  final Map<String, dynamic> materi;

  const DetailMateriPage({super.key, required this.materi});

  @override
  State<DetailMateriPage> createState() => _DetailMateriPageState();
}

class _DetailMateriPageState extends State<DetailMateriPage> {
  // State untuk mengontrol expand/collapse dropdown
  bool isPembukaanExpanded = false;
  bool isMateriExpanded = false;
  bool isPenutupExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materi['judul']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown untuk Pembukaan
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
                      // Navigasi ke IsiMateriPage dengan membawa data item
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IsiMateriPage(item: item),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Dropdown untuk Materi
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
                          builder: (context) => IsiMateriPage(item: item),
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
                children: (widget.materi['penutup'] as List).map((item) {
                  return ListTile(
                    title: Text(item['judul'] ?? 'Test'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IsiMateriPage(item: item),
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

// Placeholder untuk IsiMateriPage (akan diimplementasikan nanti)
class IsiMateriPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const IsiMateriPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['judul'] ?? 'Detail'),
      ),
      body: Center(
        child: Text('Isi Materi: ${item['judul']}'),
      ),
    );
  }
}