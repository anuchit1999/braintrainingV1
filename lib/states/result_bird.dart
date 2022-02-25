// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/utility/my_constant.dart';

class ResultBird extends StatefulWidget {
  const ResultBird({Key? key}) : super(key: key);

  @override
  _ResultBirdState createState() => _ResultBirdState();
}

class _ResultBirdState extends State<ResultBird> {
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
          .collection('scorebird')
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
          grade = score - (playTime ~/ 30);
          if (grade > 9) {
            brand = 20;
          } else if (grade > 8) {
            brand = 30;
          } else if (grade > 6) {
            brand = 40;
          } else if (grade > 3) {
            brand = 50;
          } else {
            brand = 60;
          }
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
              playTime > 59
                  ? Text(
                      'คะแนน $score เวลาเล่น ${playTime ~/ 60} นาที ${playTime % 60} วินาที',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      'คะแนน $score เวลาเล่น $playTime วินาที',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('asset/images/123.png'),
                  Center(
                      child: Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        '$brand',
                        style: TextStyle(
                          fontSize: 90,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.indigo[900]!,
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        '$brand',
                        style: TextStyle(
                          fontSize: 90,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushNamedAndRemoveUntil(context,
                          MyConstant.routeCountTimeBird, (route) => false);
                    },
                    child: Container(
                      height: 50.0,
                      width: 180,
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
                      width: 180,
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
