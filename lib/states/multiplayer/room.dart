// ignore_for_file: camel_case_types, await_only_futures, unused_local_variable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/multimodel.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/pageAuth/pageMenu.dart';
import 'package:project_game/utility/my_constant.dart';

class roomGame extends StatefulWidget {
  roomGame({Key? key}) : super(key: key);

  @override
  State<roomGame> createState() => _roomGameState();
}

class _roomGameState extends State<roomGame> {
  String? uid;
  bool _running = true, isActive = false;
  UserModel? userModel;
  List<UserModel> modelFriends = [];
  MultiModel? model;

  void initState() {
    super.initState();
    findRoom();
    findFriends();
    movePage();
  }

  Future findRoom() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((value) {
        setState(() {
          userModel = UserModel.fromMap(value.data()!);
        });
      });
      await FirebaseFirestore.instance
          .collection('multiplayer')
          .where('adminid', isEqualTo: uid)
          .get()
          .then((value) {
        setState(() {
          model = MultiModel.fromMap(value.docs[0].data());
        });
      });
    });
  }

  Future findFriends() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      print('## uid = $uid');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('addroom')
          .where('name', isNotEqualTo: 'a')
          .get()
          .then((value) {
        for (var item in value.docs) {
          UserModel model = UserModel.fromMap(item.data());
          setState(() {
            modelFriends.add(model);
          });
        }
      });
    });
  }

  Widget listFriendss() {
    return Container(
      child: Column(
        children: modelFriends.map((e) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(uid)
                        .collection('addroom')
                        .where('name')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text("no data"),
                        );
                      }
                      final DocumentSnapshotList = snapshot.data!.docs;

                      return SizedBox(
                        height: 5,
                      );
                    }),
                Container(
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          minRadius: 0,
                          maxRadius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.network(
                                "${e.urlProfile}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            Text(e.name.toString()),
                            GestureDetector(
                              onTap: () async {
                                FirebaseFirestore.instance
                                    .collection('multiplayer')
                                    .doc(model!.idClass)
                                    .update({
                                  'idClass': model!.idClass,
                                  'nameClass': model!.nameClass,
                                  'nameplayer1': userModel!.name,
                                  'nameplayer2': e.name,
                                  'playgame': model!.playgame,
                                  'readyplayer': model!.readyplayer,
                                  'scoreplayer1': -1,
                                  'scoreplayer2': -1,
                                  'questions': model!.questions,
                                  'adminid': userModel!.uid,
                                  'userid': e.uid,
                                  'nameGame': model!.nameGame,
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(e.uid)
                                      .collection('multiroom')
                                      .doc('doc1')
                                      .update({
                                    'idClass': model!.idClass,
                                    'adminid': model!.adminid,
                                  });
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(uid)
                                      .collection('addroom')
                                      .doc(e.uid)
                                      .delete();
                                });
                                setState(() {
                                  modelFriends = [];
                                });
                              },
                              child: Container(
                                height: 40.0,
                                width: 100,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "ยืนยัน",
                                    style: TextStyle(
                                      fontSize: 14,
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
              ],
            ),
          ));
        }).toList(),
      ),
    );
  }

  Future movePage() async {
    while (_running) {
      await Future<void>.delayed(const Duration(seconds: 1));
      try {
        await FirebaseFirestore.instance
            .collection('multiplayer')
            .doc(model!.idClass)
            .get()
            .then((value) {
          setState(() {
            model = MultiModel.fromMap(value.data()!);
          });
        });
      } catch (e) {}
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        uid = event!.uid;
        print('## uid = $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .collection('addroom')
            .where('name', isNotEqualTo: 'a')
            .get()
            .then((value) {
          // ignore: unrelated_type_equality_checks
          if (value.size != modelFriends) {
            modelFriends.clear();
            for (var item in value.docs) {
              UserModel model = UserModel.fromMap(item.data());
              setState(() {
                modelFriends.add(model);
              });
            }
          }
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
        }).then((value) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('q_game')
              .doc('doc1')
              .update({
            'idClass': model!.idClass,
            'questions': model!.questions,
          });
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
      if (model!.readyplayer) {
        setState(() {
          isActive = true;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return model != null && userModel != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(model!.nameClass),
            ),
            body: Center(
                child: Container(
              child: Column(
                children: [
                  listFriendss(),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("เริ่มเกม", style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: isActive
                          ? () async {
                              FlameAudio.playLongAudio('bt1.mp3');
                              FirebaseFirestore.instance
                                  .collection('multiplayer')
                                  .doc(model!.idClass)
                                  .update({
                                'idClass': model!.idClass,
                                'nameClass': model!.nameClass,
                                'nameplayer1': userModel!.name,
                                'nameplayer2': model!.nameplayer2,
                                'playgame': true,
                                'readyplayer': model!.readyplayer,
                                'scoreplayer1': -1,
                                'scoreplayer2': -1,
                                'questions': model!.questions,
                                'adminid': userModel!.uid,
                                'userid': model!.userid,
                                'nameGame': model!.nameGame,
                              });
                            }
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        child:
                            Text("ออกจากห้อง", style: TextStyle(fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () async {
                          FlameAudio.playLongAudio('bt1.mp3');
                          setState(() {
                            _running = false;
                          });
                          FirebaseFirestore.instance
                              .collection('multiplayer')
                              .doc(model!.idClass)
                              .delete();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PageMenu();
                          }));
                        }),
                  ),
                ],
              ),
            )))
        : Scaffold(
            appBar: AppBar(),
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
