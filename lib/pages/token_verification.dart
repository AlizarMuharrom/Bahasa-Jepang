import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class TokenVerificationPage extends StatefulWidget {
  @override
  _TokenVerificationPageState createState() => _TokenVerificationPageState();
}

class _TokenVerificationPageState extends State<TokenVerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();

    // Setup listener untuk setiap controller
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() => _onTextChanged(i));
    }

    // Fokus otomatis ke kotak pertama setelah widget selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  void _onTextChanged(int index) {
    if (_controllers[index].text.isNotEmpty) {
      // Jika ada input dan bukan kotak terakhir, pindah ke kotak berikutnya
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        // Jika kotak terakhir, hilangkan keyboard
        _focusNodes[index].unfocus();
      }
    } else if (_controllers[index].text.isEmpty && index > 0) {
      // Jika menghapus dan kotak kosong, kembali ke kotak sebelumnya
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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
            const Text('Masukkan 4 digit kode yang dikirim ke email Anda'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 3) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        } else {
                          _focusNodes[index].unfocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodes[index - 1]);
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String token = _controllers.map((c) => c.text).join();
                if (token == '1234') {
                  Navigator.pushNamed(context, '/reset-password');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token tidak valid')),
                  );
                }
              },
              child: const Text('Verifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}
