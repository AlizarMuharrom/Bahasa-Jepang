import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/pages/n4/kamus/model/detail_kamus.model.dart';
import 'package:bahasajepang/pages/n4/kamus/detail_kamus.dart';

class Kamus4Page extends StatefulWidget {
  const Kamus4Page({super.key});

  @override
  State<Kamus4Page> createState() => _Kamus4PageState();
}

class _Kamus4PageState extends State<Kamus4Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: detailKamusList.length,
          itemBuilder: (context, index) {
            var item = detailKamusList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKamusPage(item: item),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8.0),
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
        ),
      ),
    );
  }
}
