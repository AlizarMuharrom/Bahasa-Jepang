class UserModel {
  int id;
  String fullname;
  String username;
  String email;
  String password;
  String role;

  UserModel(
      {required this.id,
      required this.fullname,
      required this.username,
      required this.email,
      required this.password,
      required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }
}
