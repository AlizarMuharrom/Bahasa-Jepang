import 'package:flutter/material.dart';

class IsiMateriPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int initialIndex;

  const IsiMateriPage({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  @override
  State<IsiMateriPage> createState() => _IsiMateriPageState();
}

class _IsiMateriPageState extends State<IsiMateriPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void goToPreviousPage() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void goToNextPage(BuildContext context) {
    if (currentIndex < widget.items.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.items[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentItem['judul'] ?? 'Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  currentItem['isi'] ?? 'Tidak ada konten',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? goToPreviousPage : null,
                  child: const Text('Prev'),
                ),
                ElevatedButton(
                  onPressed: () => goToNextPage(context),
                  child: Text(
                    currentIndex < widget.items.length - 1 ? 'Next' : 'Kembali',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
