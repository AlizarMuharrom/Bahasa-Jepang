import 'package:bahasajepang/pages/level_page.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20jukugo/kanji_jukugo.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20okurigana/detail_okurigana.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20okurigana/kanji_okurigana.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/detail_tandoku.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_tandoku.dart';
import 'package:bahasajepang/pages/n5/main_page.dart';
import 'package:bahasajepang/pages/pemula/materi/materi%201/materi_one.dart';
import 'package:bahasajepang/pages/pemula/materi/materi%201/pengenalan/pengenalan_hiragana.dart';
import 'package:bahasajepang/pages/sign_in_page.dart';
import 'package:bahasajepang/pages/sign_up_page.dart';
import 'package:bahasajepang/pages/pemula/main_page.dart';
import 'package:bahasajepang/pages/splash_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashPage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/level': (context) => LevelSelectionPage(),
        '/pemula': (context) => PemulaPage(),
        '/materi1pemula': (context) => MateriOnePemulaPage(),
        '/pengenalan-hiragana': (context) => PengenalanHiraganaPage(),
        '/n5': (context) => NlimaPage(),
        '/kanji-tandoku5': (context) => KanjiTandokuPage(),
        '/kanji-okurigana5': (context) => KanjiOkuriganaPage(),
        '/detail-okurigana': (context) => DetailOkuriganaPage(),
        '/detail-tandoku': (context) => DetailTandokuPage(),
        '/kanji-jukugo5': (context) => KanjiJukugoPage(),
      },
    );
  }
}
