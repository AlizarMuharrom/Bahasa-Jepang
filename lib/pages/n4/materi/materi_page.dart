import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class MateriPage extends StatefulWidget {
  const MateriPage({super.key});

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  String username = "User";

  void navigateToMateri(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 35, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $username',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildMateriContainer(context, "Materi 1", "/materi1pemula"),
            const SizedBox(height: 10),
            _buildMateriContainer(context, "Materi 2", "/materi2"),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriContainer(
      BuildContext context, String title, String routeName) {
    return GestureDetector(
      onTap: () => navigateToMateri(context, routeName),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
      ),
    );
  }
}
