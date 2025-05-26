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
      backgroundColor: bgColor1.withOpacity(0.95),
      appBar: AppBar(
        title: Text(
          widget.items[currentIndex]['judul'] ?? 'Detail Materi',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress indicator with percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            color: bgColor1.withOpacity(0.2),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress: ${((currentIndex + 1) / widget.items.length * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${currentIndex + 1}/${widget.items.length}',
                      style: TextStyle(
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / widget.items.length,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(bgColor2),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),

          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Konten materi
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          item['isi'] ?? 'Tidak ada konten',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),

                      // Contoh penggunaan jika ada
                      if (item['contoh'] != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor2.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: bgColor2.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: bgColor2,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Contoh Penggunaan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: bgColor2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: bgColor2.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: bgColor2.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  item['contoh'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: bgColor2,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _goToPrevious : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        currentIndex > 0 ? bgColor1 : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: bgColor2,
                      ),
                      const SizedBox(width: 8),
                      const Text('Sebelumnya'),
                    ],
                  ),
                ),

                // Next button
                ElevatedButton(
                  onPressed: _goToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor1,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    elevation: 2,
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
                        Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: bgColor2,
                        ),
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
