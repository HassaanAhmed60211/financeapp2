class UserModel {
  final String userid;
  final String name;
  final String email;
  final String imageUrl;

  UserModel({
    required this.userid,
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}
