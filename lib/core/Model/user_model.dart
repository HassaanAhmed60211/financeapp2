class UserModel {
  final String userid;
  final String name;
  final String email;

  UserModel({
    required this.userid,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
    };
  }
}
