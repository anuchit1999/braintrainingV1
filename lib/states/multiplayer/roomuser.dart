// ignore_for_file: camel_case_types, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/multimodel.dart';
import 'package:project_game/model/multiroom.dart';
import 'package:project_game/utility/my_constant.dart';

class roomUser extends StatefulWidget {
  roomUser({Key? key}) : super(key: key);

  @override
  State<roomUser> createState() => _roomUserState();
}

class _roomUserState extends State<roomUser> {
  MultiModel? model;
  MultiRoom? multiRoom;
  String? uid;
  bool _running = true;
  bool isActive = true;

  Future finduid() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('multiroom')
          .where('idClass', isNotEqualTo: 'A')
          .get()
          .then((value) {
        setState(() {
          multiRoom = MultiRoom.fromMap(value.docs[0].data());
        });
      });
    });
  }

  Future movePage() async {
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));
      await FirebaseFirestore.instance
          .collection('multiplayer')
          .doc(multiRoom!.idClass)
          .get()
          .then((value) {
        setState(() {
          model = MultiModel.fromMap(value.data()!);
        });
      });

      if (model!.playgame) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .collection('q_game')
            .doc('doc1')
            .set({
          'idClass': model!.idClass,
          'questions': model!.questions,
        });
        _running = false;
        if (model!.nameGame == 'Rabbit Counting') {
          Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routePreBird, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routePreBox, (route) => false);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    finduid();
    movePage();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("เตรียมพร้อม", style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: isActive
                ? () async {
                    FlameAudio.playLongAudio('bt1.mp3');
                    setState(() {
                      isActive = false;
                    });
                    await FirebaseFirestore.instance
                        .collection('multiplayer')
                        .doc(multiRoom!.idClass)
                        .update({
                      'readyplayer': true,
                    });
                  }
                : null,
          ),
        ),
      )),
    );
  }
}
