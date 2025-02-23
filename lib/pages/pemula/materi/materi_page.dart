import 'package:bahasajepang/pages/pemula/materi/detail_materi.dart';
import 'package:bahasajepang/pages/pemula/materi/model/materi_model.dart';
import 'package:flutter/material.dart';

class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Materi'),
      ),
      body: ListView.builder(
        itemCount: detailMateri.length,
        itemBuilder: (context, index) {
          final materi = detailMateri[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(materi['judul']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMateriPage(materi: materi),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
