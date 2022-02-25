// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/utility/my_constant.dart';

class ResultFlagraising extends StatefulWidget {
  const ResultFlagraising({Key? key}) : super(key: key);

  @override
  _ResultFlagraisingState createState() => _ResultFlagraisingState();
}

class _ResultFlagraisingState extends State<ResultFlagraising> {
  late String uid;
  List<int> times = [];
  List<ScoreModel> scoreModels = [];
  int score = 0, playTime = 0, grade = 0, brand = 0;

  Future<void> findUidUser_Main() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('scoreflag')
          .orderBy('playDate', descending: true)
          .limit(1)
          .get()
          .then((value) {
        int i = 0;
        for (var item in value.docs) {
          ScoreModel model = ScoreModel.fromMap(item.data());
          setState(() {
            scoreModels.add(model);
            times.add(i);
            i++;
            score = scoreModels[0].score;
            playTime = scoreModels[0].playTime;
          });
        }
        grade = score - (playTime ~/ 30);
        if (grade > 9) {
          brand = 5;
        } else if (grade > 8) {
          brand = 4;
        } else if (grade > 6) {
          brand = 3;
        } else if (grade > 3) {
          brand = 2;
        } else {
          brand = 1;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    findUidUser_Main();
    FlameAudio.playLongAudio('fn1.mp3');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สรุปผล'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.blue[400]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    brand == 5
                        ? Image.asset('asset/images/brand5.gif')
                        : brand == 4
                            ? Image.asset('asset/images/brand4.gif')
                            : brand == 3
                                ? Image.asset('asset/images/brand3.gif')
                                : brand == 2
                                    ? Image.asset('asset/images/brand2.gif')
                                    : Image.asset('asset/images/brand1.gif'),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[200]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${(score * 100) ~/ 15}%",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 220,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[200]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        playTime > 59
                            ? Text(
                                "${playTime ~/ 60} นาที ${playTime % 60} วินาที",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Text(
                                "$playTime วินาที",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          MyConstant.routeCountTimeFlagraising,
                          (route) => false);
                    },
                    child: Container(
                      height: 50.0,
                      width: 350,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "เล่นใหม่อีกครั้ง",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushNamedAndRemoveUntil(
                          context, MyConstant.routePagemenu, (route) => false);
                    },
                    child: Container(
                      height: 50.0,
                      width: 350,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "กลับหน้าหลัก",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
