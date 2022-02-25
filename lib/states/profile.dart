// ignore_for_file: unused_field, must_call_super, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_navigator.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? userModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    findProfile();
  }

  Future findProfile() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      String uid = event!.uid;
      print('## uid = $uid');
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ประวัติส่วนตัว / กราฟ"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  MyConstant.routeEditProfile,
                );
                FlameAudio.playLongAudio('bt_m.mp3');
              },
              icon: Icon(
                Icons.edit,
                size: 30,
                color: Colors.white,
              ))
        ],
      ),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("asset/images/bg1.png"),
                      fit: BoxFit.cover)),
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildImage(),
                    SizedBox(height: 30),
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                "ชื่อผู้ใช้",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              // Expanded(child: Container(
                              // )),
                              Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${userModel!.name}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                "อายุ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 45,
                              ),
                              // Expanded(child: Container(
                              // )),
                              Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${userModel!.age.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 350, // constrain height
                            child: ListView(
                              padding: const EdgeInsets.all(7),
                              children: <Widget>[
                                Container(
                                  child: ShowNavigator(
                                    iconData: Icons.filter_1,
                                    label: 'Graph Rabbit Counting',
                                    routeState: MyConstant.routeGraphBird,
                                  ),
                                ),
                                Container(
                                  child: ShowNavigator(
                                      iconData: Icons.filter_2,
                                      label: 'Graph Box Counting',
                                      routeState: MyConstant.routeGraphBox),
                                ),
                                Container(
                                  child: ShowNavigator(
                                      iconData: Icons.filter_3,
                                      label: 'Graph Flag Raising',
                                      routeState: MyConstant.routeGraphFlag),
                                ),
                                Container(
                                  child: ShowNavigator(
                                      iconData: Icons.filter_4,
                                      label: 'Graph Finger Math',
                                      routeState:
                                          MyConstant.routeGraphFingermath),
                                ),
                                Container(
                                  child: ShowNavigator(
                                      iconData: Icons.filter_5,
                                      label: 'Graph Rock Paper Scissors',
                                      routeState: MyConstant.routeGraphRock),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Container buildImage() {
    return Container(
      child: CircleAvatar(
        minRadius: 0,
        maxRadius: 70,
        backgroundColor: Colors.blue.shade100,
        child: CircleAvatar(
          radius: 90,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Image.network(
              "${userModel!.urlProfile}",
              width: 130,
              height: 130,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
