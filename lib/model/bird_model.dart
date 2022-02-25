import 'dart:convert';

class BirdModel {
  final int answer;
  final String path;
  BirdModel({
    required this.answer,
    required this.path,
  });

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'path': path,
    };
  }

  factory BirdModel.fromMap(Map<String, dynamic> map) {
    return BirdModel(
      answer: map['answer'],
      path: map['path'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BirdModel.fromJson(String source) => BirdModel.fromMap(json.decode(source));
}
