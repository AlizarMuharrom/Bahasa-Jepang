import 'package:bahasajepang/pages/pemula/setting/user_service.dart';
import 'package:flutter/material.dart';
import 'package:bahasajepang/theme.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final int userId;
  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _currentUsername;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _loadCurrentUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString('username');
      _usernameController.text = _currentUsername ?? '';
    });
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await UserService.updateProfile(
        widget.userId,
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _usernameController.text.trim());

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );

        Navigator.pop(context, true);
      } else if (response.statusCode == 422) {
        // Handle validation errors
        final errors = responseData['errors'] ?? {};
        final errorMsg = errors.isNotEmpty
            ? errors.values.first.join(', ')
            : 'Data tidak valid';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData['message'] ?? 'Gagal memperbarui profil')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Error: ${e.toString().replaceAll('Exception:', '').trim()}")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 4,
        shadowColor: bgColor3.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: bgColor2,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: bgColor2.withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Ubah Informasi Profil",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Pastikan data yang kamu masukkan benar",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form dalam Card agar lebih rapi
            Card(
              color: bgColor2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username Field tanpa labelText, border warna bgColor1
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: bgColor1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: bgColor1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: bgColor1, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username tidak boleh kosong";
                          }
                          if (value.length < 3) {
                            return "Minimal 3 karakter";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field tanpa labelText, border warna bgColor1
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Password Baru",
                          prefixIcon: const Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: bgColor1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: bgColor1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: bgColor1, width: 2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() =>
                                  _isPasswordVisible = !_isPasswordVisible);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 6) {
                            return "Password minimal 6 karakter";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgColor1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: bgColor2,
                                  ),
                                )
                              : Text(
                                  "Simpan Perubahan",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: bgColor2,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
