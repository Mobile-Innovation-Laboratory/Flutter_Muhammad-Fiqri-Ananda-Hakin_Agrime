import 'dart:convert';

class UserModel {
  String? token;
  UserData? userData;

  UserModel({
    this.token,
    this.userData,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"],
        userData: json["userData"] != null
            ? UserData.fromJson(json["userData"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userData": userData?.toJson(),
      };
}

class UserData {
  String? email;
  String? username;
  String? firstname;
  String? lastname;
  bool? isAdmin;
  String? role;
  bool? isVerified;
  CreatedAt? createdAt;

  UserData({
    this.email,
    this.username,
    this.firstname,
    this.lastname,
    this.isAdmin,
    this.role,
    this.isVerified,
    this.createdAt,
  });

  factory UserData.fromRawJson(String str) =>
      UserData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        email: json["email"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        isAdmin: json["isAdmin"],
        role: json["role"],
        isVerified: json["isVerified"],
        createdAt: json["createdAt"] != null
            ? CreatedAt.fromJson(json["createdAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "isAdmin": isAdmin,
        "role": role,
        "isVerified": isVerified,
        "createdAt": createdAt?.toJson(),
      };
}

class CreatedAt {
  int? seconds;
  int? nanoseconds;

  CreatedAt({
    this.seconds,
    this.nanoseconds,
  });

  factory CreatedAt.fromRawJson(String str) =>
      CreatedAt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toJson() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };
}
