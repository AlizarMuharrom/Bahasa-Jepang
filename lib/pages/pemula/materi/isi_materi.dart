import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';

class IsiMateriPage extends StatefulWidget {
  final List<dynamic> items;
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

  void _goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  void _goToNext(BuildContext context) {
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
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: Text(
          currentItem['judul'] ?? 'Detail Materi',
          style: TextStyle(color: primaryTextColor),
        ),
        backgroundColor: bgColor3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                currentItem['isi'] ?? 'Tidak ada konten',
                style: TextStyle(
                  fontSize: 16,
                  color: secondaryTextColor,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: bgColor2,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _goToPrevious : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentIndex > 0 
                        ? Colors.blue.shade300 
                        : Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Sebelumnya',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _goToNext(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    currentIndex < widget.items.length - 1 
                        ? 'Selanjutnya' 
                        : 'Selesai',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}