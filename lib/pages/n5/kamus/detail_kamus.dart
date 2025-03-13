import 'package:bahasajepang/service/API_config.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';
import 'kamus_service.dart';
import 'package:audioplayers/audioplayers.dart';

class DetailKamus5Page extends StatefulWidget {
  final int kamusId;
  final AudioPlayer audioPlayer =
      AudioPlayer();

  DetailKamus5Page({super.key, required this.kamusId});

  @override
  State<DetailKamus5Page> createState() => _DetailKamus5PageState();
}

class _DetailKamus5PageState extends State<DetailKamus5Page> {
  late Future<dynamic> _kamusFuture;
  final KamusService _kamusService = KamusService();

  @override
  void initState() {
    super.initState();
    _kamusFuture = _kamusService.fetchKamusById(widget.kamusId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        backgroundColor: bgColor2,
        title: Text(
          "Detail Kamus",
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: _kamusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          var item = snapshot.data;

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: primaryTextColor.withOpacity(0.2)),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  color: bgColor2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Judul:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item["judul"],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Divider(color: primaryTextColor.withOpacity(0.3)),
                        Text(
                          'Nama:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item["nama"],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Divider(color: primaryTextColor.withOpacity(0.3)),
                        Text(
                          'Baca:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item["baca"],
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor2,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: primaryTextColor.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contoh Penggunaan:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      Column(
                        children: (item["contoh_penggunaan"] as List)
                            .map<Widget>((contoh) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        contoh["kanji"],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.volume_up,
                                          color: primaryTextColor),
                                      // onPressed: () {
                                      //   print(ApiConfig.url +
                                      //       "/" +
                                      //       contoh["voice_record"]);
                                      // },
                                      onPressed: () async {
                                        await widget.audioPlayer.play(UrlSource(
                                            ApiConfig.url +
                                                "/" +
                                                contoh["voice_record"]));
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  contoh["arti"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
