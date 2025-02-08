import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign Up',
              style:
                  primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
            ),
            SizedBox(height: 2),
            Text(
              'Register and Learn',
              style: secondaryTextStyle.copyWith(
                  fontSize: 14, fontWeight: regular),
            ),
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name',
              style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            ),
            SizedBox(height: 12),
            Container(
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: bgColor2, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Row(
                  children: [
                    Image.asset('assets/profile.png', width: 17),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Full Name',
                          hintStyle: primaryTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget usernameInput() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username',
              style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            ),
            SizedBox(height: 12),
            Container(
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: bgColor2, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Row(
                  children: [
                    Image.asset('assets/user.png', width: 17),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Username',
                          hintStyle: primaryTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return Container(
        margin: EdgeInsets.only(top: 20),
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: bgColor2, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Row(
                  children: [
                    Image.asset('assets/email.png', width: 17),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
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
                      ),
                    ),
                  ],
                ),
              ),
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: bgColor2, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Row(
                  children: [
                    Image.asset('assets/padlock.png', width: 17),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                        obscureText: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Password',
                          hintStyle: primaryTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget signUpButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            'Sign Up',
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
              'Already have an account?',
              style: primaryTextStyle.copyWith(
                fontSize: 12,
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Sign In',
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
      backgroundColor: bgColor1,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                nameInput(),
                usernameInput(),
                emailInput(),
                passwordInput(),
                signUpButton(),
                SizedBox(height: 30), // Ganti Spacer() agar tetap ada jarak
                footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
