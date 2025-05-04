class HasilUjianModel {
  final int id;
  final int ujianId;
  final int jumlahBenar;
  final double score;
  final String createdAt;
  final String judulUjian;

  HasilUjianModel({
    required this.id,
    required this.ujianId,
    required this.jumlahBenar,
    required this.score,
    required this.createdAt,
    required this.judulUjian,
  });

  static int parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory HasilUjianModel.fromJson(Map<String, dynamic> json) {
    return HasilUjianModel(
      id: json['id'],
      ujianId: json['ujian_id'],
      jumlahBenar: json['jumlah_benar'],
      score: double.parse(json['score'].toString()),
      createdAt: json['created_at'],
      judulUjian: json['ujian']['judul'],
    );
  }
}
