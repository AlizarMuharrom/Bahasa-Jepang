import 'package:flutter/material.dart';

class KamusPage extends StatefulWidget {
  const KamusPage({super.key});

  @override
  State<KamusPage> createState() => _KamusPageState();
}

class _KamusPageState extends State<KamusPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Kamus Belum Tersedia Di Level Anda'),
    );
  }
}