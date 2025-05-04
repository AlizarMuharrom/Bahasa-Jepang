import 'package:bahasajepang/pages/pemula/materi/model/hasil_ujian.dart';

class Ujian {
  final int id;
  final String judul;
  final int jumlahSoal;

  Ujian({
    required this.id,
    required this.judul,
    required this.jumlahSoal,
  });

  factory Ujian.fromJson(Map<String, dynamic> json) {
    return Ujian(
      id: HasilUjianModel.parseInt(json['id']),
      judul: json['judul'] as String,
      jumlahSoal: HasilUjianModel.parseInt(json['jumlah_soal']),
    );
  }
}
