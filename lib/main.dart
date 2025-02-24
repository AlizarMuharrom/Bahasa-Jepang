import 'package:bahasajepang/pages/level_page.dart';
import 'package:bahasajepang/pages/n4/kanji/kanji%20jukugo/detail_jukugo.dart';
import 'package:bahasajepang/pages/n4/kanji/kanji%20jukugo/kanji_jukugo.dart';
import 'package:bahasajepang/pages/n4/kanji/kanji%20okurigana/detail_okurigana.dart';
import 'package:bahasajepang/pages/n4/kanji/kanji%20okurigana/kanji_okurigana.dart';
import 'package:bahasajepang/pages/n4/kanji/kanji%20tandoku/detail_tandoku.dart';
import 'package:bahasajepang/pages/n4/kanji/kanji%20tandoku/kanji_tandoku.dart';
import 'package:bahasajepang/pages/n4/main_page.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20jukugo/detail_jukugo.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20jukugo/kanji_jukugo.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20okurigana/detail_okurigana.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20okurigana/kanji_okurigana.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/detail_tandoku.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_tandoku.dart';
import 'package:bahasajepang/pages/n5/main_page.dart';
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
        '/n5': (context) => NlimaPage(),
        '/n4': (context) => NEmpatPage(),
        '/kanji-tandoku5': (context) => KanjiTandokuPage(),
        '/kanji-okurigana5': (context) => KanjiOkuriganaPage(),
        '/kanji-jukugo5': (context) => KanjiJukugoPage(),
        '/detail-okurigana': (context) => DetailOkuriganaPage(),
        '/detail-tandoku': (context) => DetailTandokuPage(),
        '/detail-jukugo': (context) => DetailJukugoPage(),
        '/kanji-tandoku4': (context) => KanjiTandoku4Page(),
        '/kanji-okurigana4': (context) => KanjiOkurigana4Page(),
        '/kanji-jukugo4': (context) => KanjiJukugo4Page(),
        '/detail-tandoku4': (context) => DetailTandoku4Page(),
        '/detail-okurigana4': (context) => DetailOkurigana4Page(),
        '/detail-jukugo4': (context) => DetailJukugo4Page(),
      },
    );
  }
}
