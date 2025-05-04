import 'dart:async';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), checkLoginStatus);
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final isLevel = prefs.getInt("level_id");

    if (isLoggedIn) {
      switch (isLevel) {
        case 1:
          Navigator.pushNamedAndRemoveUntil(
              context, '/pemula', (route) => false);
          break;
        case 2:
          Navigator.pushNamedAndRemoveUntil(context, '/n5', (route) => false);
          break;
        case 3:
          Navigator.pushNamedAndRemoveUntil(context, '/n4', (route) => false);
          break;
        default:
          // print("level_page2");
          Navigator.pushNamedAndRemoveUntil(
              context, '/sign-in', (route) => false);
      }
      ;
      // print("splash_page");
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   '/level',
      //   (route) => false,
      // );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/sign-in',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor2,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image_splash.png'),
            ),
          ),
        ),
      ),
    );
  }
}
