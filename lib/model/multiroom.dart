import 'dart:convert';

class MultiRoom {
  String idClass;
  String adminid;
  MultiRoom({
    required this.idClass,
    required this.adminid,
  });

  Map<String, dynamic> toMap() {
    return {
      'idClass': idClass,
      'adminid': adminid,
    };
  }

  factory MultiRoom.fromMap(Map<String, dynamic> map) {
    return MultiRoom(
      idClass: map['idClass'] ?? '',
      adminid: map['adminid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MultiRoom.fromJson(String source) =>
      MultiRoom.fromMap(json.decode(source));
}
