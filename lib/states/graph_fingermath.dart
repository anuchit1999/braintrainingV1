// ignore_for_file: non_constant_identifier_names

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/score_model.dart';
import 'package:project_game/widgets/show_progress.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GraphFingermath extends StatefulWidget {
  GraphFingermath({Key? key}) : super(key: key);

  @override
  _GraphFingermathState createState() => _GraphFingermathState();
}

class _GraphFingermathState extends State<GraphFingermath> {
  String dayM = DateTime.now().day.toString(),
      monthM = DateTime.now().month.toString(),
      yearM = DateTime.now().year.toString();
  List<ScoreModel> scoreModels = [];
  late String uid;
  var series;
  List<int> times = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    findUidUser_Main();
  }

  Future<void> findUidUser_Main() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('scorefingermath')
          .orderBy('score', descending: true)
          .limit(3)
          .get()
          .then((value) {
        int i = 0;
        for (var item in value.docs) {
          ScoreModel model = ScoreModel.fromMap(item.data());
          setState(() {
            scoreModels.add(model);
            times.add(i);
            i++;
          });
        }

        series = Series(
          id: 'id',
          data: scoreModels,
          domainFn: (ScoreModel scoreModel, index) =>
              scoreModel.playDate.toDate().hour +
              (scoreModel.playDate.toDate().minute / 100),
          measureFn: (ScoreModel scoreModel, index) => scoreModel.score,
        );
        // listSeries.add(series);
      });
    });
  }

  Future<void> findUidUser() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('scorefingermath')
          .where('playDate',
              isGreaterThan: Timestamp.fromDate(DateTime.parse(
                  "$yearM-${int.tryParse(monthM)! < 10 ? '0' : ''}$monthM-${int.tryParse(dayM)! < 10 ? '0' : ''}$dayM 00:00:00")))
          .where('playDate',
              isLessThan: Timestamp.fromDate(DateTime.parse(
                  "$yearM-${int.tryParse(monthM)! < 10 ? '0' : ''}$monthM-${(int.tryParse(dayM)! + 1) < 10 ? '0' : ''}${(int.tryParse(dayM)! + 1)} 00:00:00")))
          .get()
          .then((value) {
        int i = 0;
        for (var item in value.docs) {
          ScoreModel model = ScoreModel.fromMap(item.data());
          setState(() {
            scoreModels.add(model);
            times.add(i);
            i++;
          });
        }

        series = Series(
          id: 'id',
          data: scoreModels,
          domainFn: (ScoreModel scoreModel, index) =>
              scoreModel.playDate.toDate().hour +
              (scoreModel.playDate.toDate().minute / 100),
          measureFn: (ScoreModel scoreModel, index) => scoreModel.score,
        );
        // listSeries.add(series);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph Gamefingermath'),
      ),
      body: scoreModels.isEmpty
          ? ShowProgress()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกวัน';
                                  } else if (int.tryParse(value)! > 32) {
                                    return 'กรอกวันผิดพลาด';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (String? day) {
                                  dayM = day!;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 15, 20, 15),
                                    hintText: "วัน",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 100,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกเดือน';
                                  } else if (int.tryParse(value)! > 13) {
                                    return 'กรอกเดือนผิดพลาด';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (String? month) {
                                  monthM = month!;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 15, 20, 15),
                                    hintText: "เดือน",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 100,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'กรุณากรอกปี';
                                  } else if (int.tryParse(value)! >
                                      DateTime.now().year + 1) {
                                    return 'กรอกปีผิดพลาด';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (String? year) {
                                  yearM = year!;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 15, 20, 15),
                                    hintText: "ปี",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.graphic_eq),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(320, 45),
                          ),
                          label: Text(
                            "แสดงกราฟ",
                          ),
                          onPressed: () async {
                            FlameAudio.playLongAudio('bt1.mp3');
                            if (formKey.currentState!.validate()) {
                              formKey.currentState?.save();
                              try {
                                scoreModels.clear();
                                findUidUser();
                              } catch (e) {}
                            }
                          },
                        ),
                        Container(
                            height: 500,
                            width: 400,
                            child: LineChart([series])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
