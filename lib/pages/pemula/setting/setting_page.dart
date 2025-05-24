import 'package:bahasajepang/pages/pemula/setting/edit_page.dart';
import 'package:bahasajepang/pages/pemula/setting/riwayat_ujian.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isKetentuanExpanded = false;
  String? username;
  int? userId;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id');
      username = prefs.getString('username');
    });
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: TextStyle(color: bgColor2),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    // Jika pengguna mengonfirmasi logout
    if (confirm == true) {
      await _logout(context);
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushNamedAndRemoveUntil('/sign-in', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: bgColor3,
        elevation: 4,
        shadowColor: bgColor2.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.9)),
      ),
      backgroundColor: bgColor1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Kartu Profil
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgColor2,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [bgColor2, bgColor2!],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: bgColor1.withOpacity(0.3),
                        width: 2,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          bgColor1.withOpacity(0.5),
                          bgColor1.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: profileImageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 40,
                                  color: bgColor1,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 40,
                            color: bgColor1,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, ${username ?? 'Pengguna'}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  if (userId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfilePage(userId: userId!),
                                      ),
                                    ).then((_) => _loadUserData());
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white, // warna ikon
                                ),
                                label: Text(
                                  'Edit Profil',
                                  style: TextStyle(
                                      color: Colors.white), // warna teks
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Colors
                                          .white), // border warna bgColor2
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _showLogoutConfirmation(context),
                                icon: const Icon(
                                  Icons.logout,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Keluar',
                                  style: TextStyle(color: Colors.red),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Opsi Pengaturan
            _buildSettingsCard(
              title: 'Riwayat Belajar',
              icon: Icons.history,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiwayatUjianPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildSettingsCard(
              title: 'Ketentuan Aplikasi',
              icon: Icons.info_outline,
              isExpandable: true,
              expanded: _isKetentuanExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isKetentuanExpanded = expanded;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "Pada tahapan tes atau latihan, terdapat batasan nilai supaya bisa lanjut ke level berikutnya, yaitu minimal 100% jawaban benar.\n\nPada halaman kanji, terdapat voice record dan button untuk mencoba menulis kanji pada layar handphone.\n\nMateri dari aplikasi ini, semuanya berreferensi dari buku Minna no Nihongo 1 dan Minna no Nihongo 2, Untuk level N5 dan N4.\n\nMohon maaf jika terdapat banyak kekurangan, karena aplikasi ini merupakan aplikasi yang dikerjakan oleh tim kecil dan masih kurang pengalaman.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildSettingsCard(
              title: 'Beri Rating',
              icon: Icons.star_border,
              onTap: () {
                // Implementasi fungsi rating
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur rating akan segera tersedia'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildSettingsCard(
              title: 'Bantuan & Dukungan',
              icon: Icons.help_outline,
              onTap: () {
                // Implementasi fungsi bantuan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur bantuan akan segera tersedia'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    Widget? child,
    bool isExpandable = false,
    bool expanded = false,
    Function(bool)? onExpansionChanged,
    Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor2,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isExpandable
          ? ExpansionTile(
              title: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              initiallyExpanded: expanded,
              onExpansionChanged: onExpansionChanged,
              children: [child!],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                  bottom: Radius.circular(16),
                ),
              ),
            )
          : ListTile(
              onTap: onTap,
              leading: Icon(
                icon,
                color: bgColor2,
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
    );
  }
}
