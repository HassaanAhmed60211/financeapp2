class ProfileModel {
  String? name;
  String? email;
  String? imaegUrl;

  ProfileModel({
    this.name,
    this.email,
    this.imaegUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        name: json["name"],
        email: json["email"],
        imaegUrl: json["imaegUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "imaegUrl": imaegUrl,
      };
}
