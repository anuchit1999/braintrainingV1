// ignore_for_file: await_only_futures

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// ignore: camel_case_types
class createRoom extends StatefulWidget {
  createRoom({Key? key}) : super(key: key);

  @override
  State<createRoom> createState() => _createRoomState();
}

// ignore: camel_case_types
class _createRoomState extends State<createRoom> {
  final formKey = GlobalKey<FormState>();
  String? uid, nameClass;
  UserModel? userModel;
  List<int> questions = [];
  final List<String> genderItems = [
    'Rabbit Counting',
    'Box Counting',
  ];
  bool isActive = false;

  String? selectedValue;

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

  void initState() {
    super.initState();
    finduid();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สร้างห้อง'),
      ),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{2,8}$');
                              if (value!.isEmpty) {
                                return ("กรุณากรอกชื่อผู้ใช้");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("กรุณากรอกชื่อได้ 2-8 ตัวอักษร");
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? name) {
                              nameClass = name!;
                            },
                            decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.account_balance_outlined),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "ชื่อห้อง",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField2(
                            decoration: InputDecoration(
                              //Add isDense true and zero Padding.
                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              //Add more decoration as you want here
                              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                            ),
                            isExpanded: true,
                            hint: const Text(
                              'Select Your Game',
                              style: TextStyle(fontSize: 14),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                            buttonHeight: 55,
                            buttonPadding:
                                const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            items: genderItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select Game';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              //Do something when changing the item if you want.
                              setState(() {
                                isActive = true;
                              });
                            },
                            onSaved: (value) {
                              selectedValue = value.toString();
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("สร้างห้อง",
                                  style: TextStyle(fontSize: 20)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: isActive
                                  ? () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        for (var j = 0; j < 10; j++) {
                                          int x = Random().nextInt(15);
                                          questions.add(x);
                                        }
                                        int i = Random().nextInt(10000);
                                        await FirebaseFirestore.instance
                                            .collection('multiplayer')
                                            .doc('room$i')
                                            .set({
                                          'idClass': 'room$i',
                                          'nameClass': nameClass,
                                          'nameplayer1': userModel!.name,
                                          'nameplayer2': '',
                                          'playgame': false,
                                          'readyplayer': false,
                                          'scoreplayer1': -1,
                                          'scoreplayer2': -1,
                                          'questions': questions,
                                          'adminid': userModel!.uid,
                                          'userid': '',
                                          'nameGame': selectedValue,
                                        });
                                        FlameAudio.playLongAudio('bt1.mp3');
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            MyConstant.routeroomGame,
                                            (route) => false);
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
