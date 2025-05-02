import 'package:bahasajepang/pages/n5/kamus/kamus_service.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/pages/n4/kamus/detail_kamus.dart';

class Kamus4Page extends StatefulWidget {
  const Kamus4Page({super.key});

  @override
  State<Kamus4Page> createState() => _Kamus4PageState();
}

class _Kamus4PageState extends State<Kamus4Page> {
  late Future<List<dynamic>> _kamusesFuture;
  final KamusService _kamusService = KamusService();

  @override
  void initState() {
    super.initState();
    // level_id = 3 diasumsikan untuk N4
    _kamusesFuture = _kamusService.fetchKamusesByLevel(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _kamusesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            var kamuses = snapshot.data!;

            return ListView.builder(
              itemCount: kamuses.length,
              itemBuilder: (context, index) {
                var item = kamuses[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailKamus4Page(kamusId: item["id"]),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    color: bgColor2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item["judul"],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            item["nama"],
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
