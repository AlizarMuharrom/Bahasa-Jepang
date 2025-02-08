import 'package:flutter/material.dart';

class KanjiPage extends StatefulWidget {
  const KanjiPage({super.key});

  @override
  State<KanjiPage> createState() => _KanjiPageState();
}

class _KanjiPageState extends State<KanjiPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Kanji Page'),
    );
  }
}
