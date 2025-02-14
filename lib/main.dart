import 'package:bahasajepang/pages/level_page.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20jukugo/kanji_jukugo.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20okurigana/kanji_okurigana.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_air.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_angin.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_api.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_buku.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_gunung.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_hari.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_hutan.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_ibu.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_mata.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_negara.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_pohon.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_sapi.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_tandoku.dart';
import 'package:bahasajepang/pages/n5/kanji/kanji%20tandoku/kanji_tangan.dart';
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
        '/kanji-pohon': (context) => DetailPohonPage(),
        '/kanji-ibu': (context) => DetailIbuPage(),
        '/kanji-buku': (context) => DetailBukuPage(),
        '/kanji-air': (context) => DetailAirPage(),
        '/kanji-api': (context) => DetailApiPage(),
        '/kanji-angin': (context) => DetailAnginPage(),
        '/kanji-mata': (context) => DetailMataPage(),
        '/kanji-hari': (context) => DetailHariPage(),
        '/kanji-gunung': (context) => DetailGunungPage(),
        '/kanji-sapi': (context) => DetailSapiPage(),
        '/kanji-negara': (context) => DetailNegaraPage(),
        '/kanji-hutan': (context) => DetailHutanPage(),
        '/kanji-tangan': (context) => DetailTanganPage(),
      },
    );
  }
}
