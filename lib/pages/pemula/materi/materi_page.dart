import 'package:bahasajepang/pages/pemula/materi/detail_materi.dart';
import 'package:bahasajepang/pages/pemula/materi/model/materi_model.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: ListView.builder(
          itemCount: detailMateri.length,
          itemBuilder: (context, index) {
            final materi = detailMateri[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              color: bgColor2,
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
      ),
    );
  }
}
