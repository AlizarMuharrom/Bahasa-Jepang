import 'package:bahasajepang/pages/pemula/materi/materi%201/model/materi_one.model.dart';
import 'package:bahasajepang/theme.dart';
import 'package:flutter/material.dart';

class MateriOnePemulaPage extends StatefulWidget {
  const MateriOnePemulaPage({super.key});

  @override
  State<MateriOnePemulaPage> createState() => _MateriOnePemulaPageState();
}

class _MateriOnePemulaPageState extends State<MateriOnePemulaPage> {
  Map<String, bool> isExpanded = {
    "Pembukaan": false,
    "Huruf Hiragana": false,
    "Penutup": false,
  };

  void toggleExpansion(String section) {
    setState(() {
      isExpanded[section] = !(isExpanded[section] ?? false);
    });
  }

  void navigateToPage(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1, // Full background bgColor1
      appBar: AppBar(
        backgroundColor: bgColor2, 
        title: Text("Materi 1", style: primaryTextStyle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Supaya bisa discroll
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Modul", style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                buildDropdown("Pembukaan", pembukaan),
                buildDropdown("Huruf Hiragana", hurufHiragana),
                buildDropdown("Penutup", penutup),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title, style: primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
          trailing: Icon(
            isExpanded[title]! ? Icons.expand_less : Icons.expand_more,
            color: primaryTextColor,
          ),
          onTap: () => toggleExpansion(title),
        ),
        if (isExpanded[title]!)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => GestureDetector(
                onTap: () => navigateToPage(item["route"]!), // Navigasi sesuai route
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    item["title"]!,
                    style: primaryTextStyle.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
      ],
    );
  }
}
