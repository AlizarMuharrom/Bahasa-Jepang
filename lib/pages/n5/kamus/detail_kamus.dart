import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';

class DetailKamus5Page extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailKamus5Page({super.key, required this.item});

  @override
  State<DetailKamus5Page> createState() => _DetailKamus5PageState();
}

class _DetailKamus5PageState extends State<DetailKamus5Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        backgroundColor: bgColor2,
        title: Text(
          "Detail Kamus",
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Scroll terasa lebih smooth
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card untuk Judul, Nama, dan Baca
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: primaryTextColor.withOpacity(0.2)),
              ),
              elevation: 4,
              shadowColor: Colors.black26,
              color: bgColor2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Judul:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.item["judul"],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    Divider(color: primaryTextColor.withOpacity(0.3)),
                    Text(
                      'Nama:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.item["nama"],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    Divider(color: primaryTextColor.withOpacity(0.3)),
                    Text(
                      'Baca:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.item["baca"],
                      style: TextStyle(
                        fontSize: 18,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Container untuk semua contoh penggunaan
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryTextColor.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contoh Penggunaan:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    children:
                        widget.item["contohPenggunaan"].map<Widget>((contoh) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row untuk teks dan ikon speaker
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    contoh["kanji"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor.withOpacity(0.1),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.volume_up,
                                        color: primaryTextColor),
                                    onPressed: () {
                                      // Tambahkan fungsi untuk memutar audio di sini
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              contoh["arti"],
                              style: TextStyle(
                                fontSize: 16,
                                color: secondaryTextColor,
                              ),
                            ),
                            if (contoh != widget.item["contohPenggunaan"].last)
                              Divider(color: Colors.grey.withOpacity(0.3)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
