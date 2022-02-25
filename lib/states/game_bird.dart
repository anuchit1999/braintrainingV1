import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/bird_model.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_image.dart';
import 'package:project_game/widgets/show_progress.dart';

class GameBird extends StatefulWidget {
  const GameBird({Key? key}) : super(key: key);

  @override
  _GameBirdState createState() => _GameBirdState();
}

class _GameBirdState extends State<GameBird> {
  int timebird = 0, myAnswer = 0, score = 0, playTime = 0, timeStop = 0;
  List<int> idQuestions = [];
  List<BirdModel> birdModels = [];
  late String userUid;

  @override
  void initState() {
    super.initState();
    randomQuestion();
    autoPlayTime();
    findUser();
    randomMusic();
  }

  Future<void> randomMusic() async {
    int sound = Random().nextInt(4);
    FlameAudio.bgm.play('sd$sound.mp3');
  }

  Future<void> findUser() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      userUid = event!.uid;
    });
  }

  Future<void> autoPlayTime() async {
    Duration duration = Duration(seconds: 1);
    // ignore: await_only_futures
    await Timer(duration, () {
      setState(() {
        playTime++;
      });
      autoPlayTime();
    });
  }

  Future<void> randomQuestion() async {
    for (var i = 0; i < 10; i++) {
      int i = Random().nextInt(15);
      idQuestions.add(i);

      await FirebaseFirestore.instance
          .collection('rabbit')
          .doc('doc$i')
          .get()
          .then((value) {
        BirdModel model = BirdModel.fromMap(
          value.data()!,
        );
        setState(() {
          birdModels.add(model);
        });
      });
    }
    print('## $idQuestions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rabbit Counting Game'),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: playTime > 59
                    ? Text('${playTime ~/ 60} นาที ${playTime % 60} วินาที')
                    : Text('$playTime วินาที'),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: buildFloating(),
      body: birdModels.isEmpty
          ? ShowProgress()
          : Center(
              child: Column(
                children: [
                  buildImage(),
                  buildMyAnswer(),
                  Spacer(),
                  buttonAnswer(),
                ],
              ),
            ),
    );
  }

  Padding buttonAnswer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: IconButton(
        onPressed: () {
          FlameAudio.playLongAudio('add.mp3');
          setState(() {
            myAnswer++;
          });
        },
        icon: Icon(
          Icons.add_circle,
          size: 60,
        ),
      ),
    );
  }

  ShowTitle buildMyAnswer() =>
      ShowTitle(title: myAnswer.toString(), textStyle: MyConstant().h0Style());

  Container buildImage() {
    return Container(
      width: 350,
      height: 350,
      child: ShowImage(partUrl: birdModels[timebird].path),
    );
  }

  Future<void> processCalculate() async {
    FlameAudio.playLongAudio('bt2.mp3');
    if (timebird == 9) {
      FlameAudio.bgm.pause();
      if (myAnswer == birdModels[timebird].answer) {
        score++;
      }
      print('## score ==> $score');
      timeStop = playTime;
      print('## timesStop => $timeStop');

      DateTime dateTime = DateTime.now();
      Timestamp playDate = Timestamp.fromDate(dateTime);

      ScoreModel model = ScoreModel(score, playTime, playDate);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('scorebird')
          .doc(
              '${dateTime.year}${dateTime.month < 10 ? '0' : ''}${dateTime.month}${dateTime.day < 10 ? '0' : ''}${dateTime.day}${dateTime.hour < 10 ? '0' : ''}${dateTime.hour}${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}')
          .set(model.toMap())
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeResultBird, (route) => false));
    } else {
      if (myAnswer == birdModels[timebird].answer) {
        score++;
      }
      print('## $score');
      setState(() {
        myAnswer = 0;
        timebird++;
      });
    }
  }

  FloatingActionButton buildFloating() {
    return FloatingActionButton(
      onPressed: () => processCalculate(),
      child: Text(
        (timebird + 1).toString(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
