import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';

class IsiMateriN5Page extends StatefulWidget {
  final List<dynamic> items;
  final int initialIndex;
  final String level;

  const IsiMateriN5Page({
    super.key,
    required this.items,
    required this.initialIndex,
    this.level = 'N5',
  });

  @override
  State<IsiMateriN5Page> createState() => _IsiMateriN5PageState();
}

class _IsiMateriN5PageState extends State<IsiMateriN5Page> {
  late int currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (currentIndex < widget.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: Text(
          'Materi JLPT ${widget.level}',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
          ),
        ),
        backgroundColor: bgColor2,
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentIndex + 1) / widget.items.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            minHeight: 4,
          ),
          
          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul materi
                      Text(
                        item['judul'] ?? 'Judul Materi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Konten materi
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['isi'] ?? 'Tidak ada konten',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      
                      // Contoh penggunaan untuk materi bahasa Jepang
                      if (item['contoh'] != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Contoh:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.shade100,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item['contoh'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue.shade800,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Navigation buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor2,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _goToPrevious : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentIndex > 0 
                        ? primaryColor 
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20, 
                      vertical: 12
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, size: 18),
                      SizedBox(width: 8),
                      Text('Sebelumnya'),
                    ],
                  ),
                ),
                
                // Page indicator
                Text(
                  '${currentIndex + 1}/${widget.items.length}',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                
                // Next button
                ElevatedButton(
                  onPressed: () => _goToNext(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20, 
                      vertical: 12
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentIndex < widget.items.length - 1 
                            ? 'Selanjutnya' 
                            : 'Selesai',
                      ),
                      if (currentIndex < widget.items.length - 1) 
                        const SizedBox(width: 8),
                      if (currentIndex < widget.items.length - 1)
                        const Icon(Icons.arrow_forward, size: 18),
                    ],
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