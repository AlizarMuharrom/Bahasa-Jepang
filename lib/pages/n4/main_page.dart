import 'package:bahasajepang/pages/n4/kamus/kamus_page.dart';
import 'package:bahasajepang/pages/n4/kanji/kanji_page.dart';
import 'package:bahasajepang/pages/n4/materi/materi_page.dart';
import 'package:bahasajepang/pages/pemula/setting/setting_page.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class NEmpatPage extends StatefulWidget {
  const NEmpatPage({super.key});

  @override
  State<NEmpatPage> createState() => _NEmpatPageState();
}

class _NEmpatPageState extends State<NEmpatPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          backgroundColor: bgColor3,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.book,
                  size: 35,
                  color: currentIndex == 0 ? bgColor2 : bgColor1,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.menu_book,
                  size: 35,
                  color: currentIndex == 1 ? bgColor2 : bgColor1,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.translate,
                  size: 35,
                  color: currentIndex == 2 ? bgColor2 : bgColor1,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.settings,
                  size: 35,
                  color: currentIndex == 3 ? bgColor2 : bgColor1,
                ),
              ),
              label: '',
            ),
          ],
        ),
      );
    }

    Widget body() {
      switch (currentIndex) {
        case 0:
          return MateriN4Page();
        case 1:
          return Kamus4Page();
        case 2:
          return KanjiPage();
        case 3:
          return SettingPage();
        default:
          return MateriN4Page();
      }
    }

    return Scaffold(
      backgroundColor: bgColor1,
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}
