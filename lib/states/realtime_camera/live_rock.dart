import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/bird_model.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/states/realtime_camera/bounding_box.dart';
import 'package:project_game/states/realtime_camera/camera.dart';
import 'package:project_game/utility/my_constant.dart';
import 'dart:math' as math;
import 'package:tflite/tflite.dart';

class LiveFeedRock extends StatefulWidget {
  final List<CameraDescription> cameras;
  LiveFeedRock(this.cameras);
  @override
  _LiveFeedRockState createState() => _LiveFeedRockState();
}

class _LiveFeedRockState extends State<LiveFeedRock> {
  List<dynamic>? _recognitions;
  int timeFinger = 0, playTime = 0, myAnswer = 0, score = 0;
  int _imageHeight = 0;
  int _imageWidth = 0;
  List<int> idQuestions = [];
  List<BirdModel> fingerModels = [];
  late String userUid;
  initCameras() async {}
  loadTfModel() async {
    await Tflite.loadModel(
      model: "asset/models/Rock-final.tflite",
      labels: "asset/models/label.txt",
    );
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
      int i = Random().nextInt(6);
      idQuestions.add(i);

      await FirebaseFirestore.instance
          .collection('rock')
          .doc('doc$i')
          .get()
          .then((value) {
        BirdModel model = BirdModel.fromMap(
          value.data()!,
        );
        setState(() {
          fingerModels.add(model);
        });
      });
    }
    print('## $idQuestions');
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    randomQuestion();
    autoPlayTime();
    loadTfModel();
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

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    var detec;
    try {
      setState(() {
        detec = _recognitions![0]["detectedClass"];
      });
    } catch (e) {}
    if (detec == "Rock") {
      setState(() {
        myAnswer = 1;
      });
    } else if (detec == "Scissor") {
      setState(() {
        myAnswer = 2;
      });
    } else if (detec == "Paper") {
      setState(() {
        myAnswer = 3;
      });
    } else {
      setState(() {
        myAnswer = -1;
      });
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // here the desired height
        child: AppBar(
          title: fingerModels.isEmpty
              ? Text("กรุณารอสักครู่...")
              : Text(
                  "${timeFinger + 1}: ${fingerModels[timeFinger].path}",
                  style: TextStyle(fontSize: 32),
                ),
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
      ),
      floatingActionButton: buildFloating(),
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions),
          BoundingBox(
            _recognitions == null ? [] : _recognitions!,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
        ],
      ),
    );
  }

  Future<void> processCalculate() async {
    FlameAudio.playLongAudio('bt2.mp3');
    if (timeFinger == 9) {
      FlameAudio.bgm.pause();
      if (myAnswer == fingerModels[timeFinger].answer) {
        setState(() {
          score++;
        });
      }
      print('## $score');

      DateTime dateTime = DateTime.now();
      Timestamp playDate = Timestamp.fromDate(dateTime);

      ScoreModel model = ScoreModel(score, playTime, playDate);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('scorerock')
          .doc(
              '${dateTime.year}${dateTime.month < 10 ? '0' : ''}${dateTime.month}${dateTime.day < 10 ? '0' : ''}${dateTime.day}${dateTime.hour < 10 ? '0' : ''}${dateTime.hour}${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}')
          .set(model.toMap())
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeResultRock, (route) => false));
    } else {
      if (myAnswer == fingerModels[timeFinger].answer) {
        setState(() {
          score++;
        });
      }
      print('## $score');
      setState(() {
        myAnswer = 0;
        timeFinger++;
      });
    }
  }

  FloatingActionButton buildFloating() {
    return FloatingActionButton(
      onPressed: () => processCalculate(),
      child: Text(
        (timeFinger + 1).toString(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
