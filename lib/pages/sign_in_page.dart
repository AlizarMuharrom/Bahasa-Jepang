import 'dart:convert';

import 'package:bahasajepang/models/user_model.dart';
import 'package:bahasajepang/service/API_config.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Future<void> functionLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      print("$key : ${prefs.get(key)}");
    });
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      const endpoint = "/login";
      var response = await http.post(
        Uri.parse(ApiConfig.baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var token = jsonResponse['token'];
        print('Token: $token');
        print("Cek JSON Response: $jsonResponse");

        if (jsonResponse['status'] == 'success') {
          if (jsonResponse.containsKey('user') &&
              jsonResponse['user'] != null) {
            print("Cek JSON user: ${jsonResponse['user']}");

            UserModel user = UserModel.fromJson(jsonResponse['user']);
            print(
                'User data dari model: ${user.id}, ${user.fullname}, ${user.username}, ${user.email}, ${user.level_id}, ${token}');

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('id', user.id);
            await prefs.setString('fullname', user.fullname ?? "");
            await prefs.setString('username', user.username ?? "");
            await prefs.setString('email', user.email ?? "");
            await prefs.setString('password', user.password ?? "");
            await prefs.setString('token', token ?? "");
            await prefs.setBool('isLoggedIn', true); // Tambahkan ini
            await prefs.setInt(
                'level_id', user.level_id ?? 0); // Simpan level_id

            if (user.level_id == null || user.level_id == 0) {
              // print("sign_in_page");
              Navigator.pushNamedAndRemoveUntil(
                  context, '/level', (route) => false);
            } else {
              switch (user.level_id) {
                case 1:
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/pemula', (route) => false);
                  break;
                case 2:
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/n5', (route) => false);
                  break;
                case 3:
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/n4', (route) => false);
                  break;
                default:
                  // print("sign_in_page2");
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/level', (route) => false);
              }
            }
          } else {
            print("Error: Key 'user' tidak ditemukan dalam JSON response");
          }
        } else {
          print("Login gagal: ${jsonResponse['message']}");
        }
      } else {
        print("Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style:
                  primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'Sign In to Continue',
              style: secondaryTextStyle.copyWith(
                  fontSize: 14, fontWeight: regular),
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            ),
            SizedBox(height: 12),
            Container(
              height: 45,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(12)),
              child: Center(
                  child: Row(
                children: [
                  Image.asset('assets/email.png', width: 17),
                  SizedBox(width: 16),
                  Expanded(
                      child: TextFormField(
                    controller: _emailController,
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Your Email Address',
                      hintStyle: primaryTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                  )),
                ],
              )),
            ),
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            ),
            SizedBox(height: 12),
            Container(
              height: 45,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(12)),
              child: Center(
                  child: Row(
                children: [
                  Image.asset('assets/padlock.png', width: 17),
                  SizedBox(width: 16),
                  Expanded(
                      child: TextFormField(
                    controller: _passwordController,
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Your Password',
                      hintStyle: primaryTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  )),
                ],
              )),
            ),
          ],
        ),
      );
    }

    Widget forgotPasswordButton() {
      return Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/forgot-password');
          },
          child: Text(
            'Forgot Password?',
            style: purpleTextStyle.copyWith(
              fontSize: 12,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget signInButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: () {
            functionLogin();
          },
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            'Sign In',
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account?',
              style: primaryTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: Text(
                'Sign Up',
                style: purpleTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              emailInput(),
              passwordInput(),
              forgotPasswordButton(),
              signInButton(),
              Spacer(),
              footer(),
            ],
          ),
        ),
      ),
    );
  }
}
