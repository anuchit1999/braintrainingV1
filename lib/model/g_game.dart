import 'dart:convert';

class Qgame {
  List<num> questions;
  String idClass;
  Qgame({
    required this.questions,
    required this.idClass,
  });

  Map<String, dynamic> toMap() {
    return {
      'questions': questions,
      'idClass': idClass,
    };
  }

  factory Qgame.fromMap(Map<String, dynamic> map) {
    return Qgame(
      questions: List<num>.from(map['questions']),
      idClass: map['idClass'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Qgame.fromJson(String source) => Qgame.fromMap(json.decode(source));
}
