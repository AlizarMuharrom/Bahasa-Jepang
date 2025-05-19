import 'package:bahasajepang/service/API_config.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenVerificationPage extends StatefulWidget {
  final String email;

  const TokenVerificationPage({Key? key, required this.email})
      : super(key: key);

  @override
  _TokenVerificationPageState createState() => _TokenVerificationPageState();
}

class _TokenVerificationPageState extends State<TokenVerificationPage> {
  final TextEditingController _tokenController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyToken() async {
    final token = _tokenController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/verify-token');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true'
        },
        body: json.encode({
          'email': widget.email,
          'token': token,
        }),
      );

      final responseData = json.decode(response.body);

      print(response.body);

      if (response.statusCode == 200) {
        Navigator.pushNamed(
          context,
          '/reset-password',
          arguments: {
            'email': widget.email,
            'token': token,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'] ?? 'Token tidak valid')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal verifikasi token: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Token'),
        backgroundColor: bgColor2,
      ),
      backgroundColor: bgColor1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Masukkan 4 digit kode yang dikirim ke ${widget.email}'),
            const SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              keyboardType: TextInputType.text,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Token',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryColor,
                ),
                onPressed: _isLoading ? null : _verifyToken,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Verifikasi',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      // Logika kirim ulang token
                    },
              child: const Text('Kirim ulang token'),
            ),
          ],
        ),
      ),
    );
  }
}
