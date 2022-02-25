import 'dart:convert';

class UserModel {
  num age;
  String name;
  String urlProfile;
  String uid;
  UserModel({
    required this.age,
    required this.name,
    required this.urlProfile,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'name': name,
      'urlProfile': urlProfile,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      age: map['age'] ?? 0,
      name: map['name'] ?? '',
      urlProfile: map['urlProfile'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
