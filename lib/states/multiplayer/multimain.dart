// ignore_for_file: camel_case_types, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/multimodel.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/utility/my_constant.dart';

class multiMain extends StatefulWidget {
  multiMain({Key? key}) : super(key: key);

  @override
  State<multiMain> createState() => _multiMainState();
}

class _multiMainState extends State<multiMain> {
  String? uid;
  MultiModel? model;
  List<MultiModel> modelClass = [];

  UserModel? modelD;
  Future findDelete() async {
    print("## aaaa");
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('multiplayer')
          .where('adminid', isEqualTo: uid)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          setState(() {
            model = MultiModel.fromMap(item.data());
          });
          await FirebaseFirestore.instance
              .collection('multiplayer')
              .doc(model!.idClass)
              .delete();
          print("## bbbb");
        }
      });

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('addroom')
          .where('age', isNotEqualTo: 1)
          .get()
          .then((value) async {
        for (var item in value.docs) {
          setState(() {
            modelD = UserModel.fromMap(item.data());
          });
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .collection('addroom')
              .doc(modelD!.uid)
              .delete();
          print("## cccc");
        }
      });
    });
  }

  @override
  @override
  void initState() {
    super.initState();
    findDelete();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โหมดเล่น 2 คน'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text("สร้างห้อง", style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      FlameAudio.playLongAudio('bt1.mp3');
                      Navigator.pushNamed(
                        context,
                        MyConstant.routecreateRoom,
                      );
                    }),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    child: Text("ค้นหาห้อง", style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      FlameAudio.playLongAudio('bt1.mp3');
                      Navigator.pushNamed(
                        context,
                        MyConstant.routefindRoom,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
