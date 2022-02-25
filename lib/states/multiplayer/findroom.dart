// ignore_for_file: unused_import, camel_case_types, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/multimodel.dart';
import 'package:project_game/model/multiroom.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/pageAuth/pageMenu.dart';
import 'package:project_game/utility/my_constant.dart';

class findRoom extends StatefulWidget {
  findRoom({Key? key}) : super(key: key);

  @override
  State<findRoom> createState() => _findRoomState();
}

class _findRoomState extends State<findRoom> {
  final formKey = GlobalKey<FormState>();
  String? uid;
  int times = 0;
  bool stateAdd = true;
  UserModel? userModel;
  List<MultiModel> modelFriends = [];
  MultiModel? model, modelC;
  MultiRoom? multiRoom;
  String? nameF;
  bool _running = true, isActiveModel = false;

  Future finduid() async {
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
    });
  }

  Future findFriends() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('multiplayer')
          .where('nameClass', isEqualTo: nameF)
          .get()
          .then((value) {
        int i = 0;
        for (var item in value.docs) {
          model = MultiModel.fromMap(item.data());
          setState(() {
            modelFriends.add(model!);
            times = i;
            i++;
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
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
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
                                "${userModel!.urlProfile}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("ชื่อห้อง : ${e.nameClass.toString()}"),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(e.nameGame.toString()),
                            GestureDetector(
                              onTap: () async {
                                FlameAudio.playLongAudio('bt1.mp3');
                                await FirebaseFirestore.instance
                                    .collection('user')
                                    .doc(e.adminid.toString())
                                    .collection('addroom')
                                    .doc(uid)
                                    .set({
                                  'uid': uid,
                                  'name': userModel!.name,
                                  'age': userModel!.age,
                                  'urlProfile': userModel!.urlProfile,
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(uid)
                                      .collection('multiroom')
                                      .doc('doc1')
                                      .set({
                                    'idClass': 'space',
                                    'adminid': 'space',
                                  });
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(uid)
                                      .collection('multiroom')
                                      .doc('doc1')
                                      .update({
                                    'idClass': 'space',
                                    'adminid': e.adminid,
                                  });
                                  setState(() {
                                    modelFriends = [];
                                    stateAdd = false;
                                  });
                                  movePage();
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
                                    "ขอเข้าร่วม",
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
                    )
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
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('multiroom')
          .doc('doc1')
          .get()
          .then((value) {
        setState(() {
          multiRoom = MultiRoom.fromMap(value.data()!);
        });
      }).then((value) {
        FirebaseFirestore.instance
            .collection('multiplayer')
            .where('adminid', isEqualTo: multiRoom!.adminid)
            .get()
            .then((value) {
          setState(() {
            modelC = MultiModel.fromMap(value.docs[0].data());
          });
        });
      });
      if (modelC != null) {
        isActiveModel = true;
      }
      if (isActiveModel) {
        if (modelC!.userid == uid && multiRoom!.idClass != 'space') {
          setState(() {
            _running = false;
          });
          Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeroomUser, (route) => false);
        } else if (modelC!.idClass != multiRoom!.idClass &&
            modelC!.nameplayer2 != '') {
          setState(() {
            _running = false;
          });
          FirebaseFirestore.instance
              .collection('user')
              .doc(multiRoom!.adminid)
              .collection('addroom')
              .doc(uid)
              .delete();
          Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeProfile, (route) => false);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    finduid();
  }

  Widget build(BuildContext context) {
    return stateAdd
        ? Scaffold(
            appBar: AppBar(
              title: Text('ขอเข้าร่วม'),
            ),
            body: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onSaved: (String? name) {
                                nameF = name!;
                              },
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  hintText: "ค้นหาด้วยชื่อห้อง"),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search_rounded),
                            onPressed: () {
                              FlameAudio.playLongAudio('bt2.mp3');
                              formKey.currentState?.save();
                              findFriends();
                            },
                          ),
                        ],
                      ),
                    ),
                    listFriendss()
                  ]),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        child:
                            Text("ยกเลิกคำขอ", style: TextStyle(fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(multiRoom!.adminid)
                              .collection('addroom')
                              .doc(uid)
                              .delete();
                          setState(() {
                            stateAdd = true;
                          });
                        }),
                  ),
                ],
              ),
            ),
          );
  }
}
