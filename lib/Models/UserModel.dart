import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
    UserModel({
      this.username,
      this.password,
      this.isAdmin,
    });

    String username;
    String password;
    bool isAdmin;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json["username"],
        password: json["password"],
        isAdmin: json["isAdmin"],
    );

}