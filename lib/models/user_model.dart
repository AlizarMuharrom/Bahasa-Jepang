class UserModel {
  final int id;
  final String fullname;
  final String username;
  final String email;
  final String password;
  final int? level_id;

  UserModel({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    required this.password,
    this.level_id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0, // Berikan nilai default jika null
      fullname: json['fullname'] ?? "", // Berikan nilai default jika null
      username: json['username'] ?? "", // Berikan nilai default jika null
      email: json['email'] ?? "", // Berikan nilai default jika null
      password: json['password'] ?? "", // Berikan nilai default jika null
      level_id: json['level_id'], // Biarkan null jika tidak ada
    );
  }
}