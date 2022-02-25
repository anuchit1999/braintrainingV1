import 'dart:convert';

class MultiModel {
  String adminid;
  String idClass;
  String nameClass;
  String nameplayer1;
  String nameplayer2;
  bool playgame;
  bool readyplayer;
  List<num> questions;
  num scoreplayer1;
  num scoreplayer2;
  String userid;
  String nameGame;
  MultiModel({
    required this.adminid,
    required this.idClass,
    required this.nameClass,
    required this.nameplayer1,
    required this.nameplayer2,
    required this.playgame,
    required this.readyplayer,
    required this.questions,
    required this.scoreplayer1,
    required this.scoreplayer2,
    required this.userid,
    required this.nameGame,
  });

  Map<String, dynamic> toMap() {
    return {
      'adminid': adminid,
      'idClass': idClass,
      'nameClass': nameClass,
      'nameplayer1': nameplayer1,
      'nameplayer2': nameplayer2,
      'playgame': playgame,
      'readyplayer': readyplayer,
      'questions': questions,
      'scoreplayer1': scoreplayer1,
      'scoreplayer2': scoreplayer2,
      'userid': userid,
      'nameGame': nameGame,
    };
  }

  factory MultiModel.fromMap(Map<String, dynamic> map) {
    return MultiModel(
      adminid: map['adminid'] ?? '',
      idClass: map['idClass'] ?? '',
      nameClass: map['nameClass'] ?? '',
      nameplayer1: map['nameplayer1'] ?? '',
      nameplayer2: map['nameplayer2'] ?? '',
      playgame: map['playgame'] ?? false,
      readyplayer: map['readyplayer'] ?? false,
      questions: List<num>.from(map['questions']),
      scoreplayer1: map['scoreplayer1'] ?? 0,
      scoreplayer2: map['scoreplayer2'] ?? 0,
      userid: map['userid'] ?? '',
      nameGame: map['nameGame'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MultiModel.fromJson(String source) =>
      MultiModel.fromMap(json.decode(source));
}
