// ignore_for_file: unused_import, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/multimodel.dart';
import 'package:project_game/model/multiroom.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_progress.dart';

class ResultMultiGame extends StatefulWidget {
  ResultMultiGame({Key? key}) : super(key: key);

  @override
  State<ResultMultiGame> createState() => _ResultMultiGameState();
}

class _ResultMultiGameState extends State<ResultMultiGame> {
  String? uid, nameresult;
  MultiRoom? multiRoom;
  MultiModel? model;
  int result = 0;
  bool _running = true;

  Future findRoom() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('q_game')
          .doc('doc1')
          .get()
          .then((value) async {
        setState(() {
          multiRoom = MultiRoom.fromMap(value.data()!);
        });
        await FirebaseFirestore.instance
            .collection('multiplayer')
            .doc(multiRoom!.idClass)
            .get()
            .then((value) {
          setState(() {
            model = MultiModel.fromMap(value.data()!);
          });
        });
      });
    });
  }

  Future movePage() async {
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));
      findRoom();
      if (model != null) {
        if (model!.scoreplayer1 > model!.scoreplayer2) {
          setState(() {
            result = 1;
            nameresult = model!.nameplayer1;
          });
        } else if (model!.scoreplayer1 < model!.scoreplayer2) {
          setState(() {
            result = 2;
            nameresult = model!.nameplayer2;
          });
        } else if (model!.scoreplayer1 == model!.scoreplayer2) {
          setState(() {
            result = 3;
          });
        }
        if (model!.scoreplayer1 != -1 && model!.scoreplayer2 != -1) {
          FlameAudio.playLongAudio('fn1.mp3');
          _running = false;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    movePage();
  }

  Widget build(BuildContext context) {
    if (model != null) {
      if (model!.scoreplayer1 > model!.scoreplayer2) {
        setState(() {
          result = 1;
          nameresult = model!.nameplayer1;
        });
      } else if (model!.scoreplayer1 < model!.scoreplayer2) {
        setState(() {
          result = 2;
          nameresult = model!.nameplayer2;
        });
      } else if (model!.scoreplayer1 == model!.scoreplayer2) {
        setState(() {
          result = 3;
        });
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('สรุปผล'),
        ),
        body: model != null &&
                model!.scoreplayer1 != -1 &&
                model!.scoreplayer2 != -1
            ? result == 3
                ? Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ทั้งคู่เสมอกัน"),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                                child: Text("กลับสู่หน้าหลัก",
                                    style: TextStyle(fontSize: 15)),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('multiplayer')
                                      .doc(multiRoom!.idClass)
                                      .delete();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MyConstant.routePagemenu,
                                      (route) => false);
                                }),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ผู้ชนะคือ ผู้เล่น$result: $nameresult"),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 250,
                            child: ElevatedButton(
                                child: Text("กลับสู่หน้าหลัก",
                                    style: TextStyle(fontSize: 15)),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('multiplayer')
                                      .doc(multiRoom!.idClass)
                                      .delete();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MyConstant.routePagemenu,
                                      (route) => false);
                                }),
                          ),
                        ],
                      ),
                    ),
                  )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("กรุณารอผู้เล่นฝ่ายตรงข้าม")],
                  ),
                ),
              ));
  }
}
