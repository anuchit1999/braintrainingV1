// ignore_for_file: await_only_futures, must_call_super

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_game/model/user_model.dart';
import 'package:project_game/utility/my_constant.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? userModel;
  String? uid, nameM, urlM;
  double? ageM;
  File? myFile;
  final formKey = GlobalKey<FormState>();
  bool isActive = false;

  Future findProfile() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
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
      setState(() {
        urlM = userModel!.urlProfile;
      });
      print('${userModel == null ? '## null' : '## ${userModel!.urlProfile}'}');
    });
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('User/user$i.jpg');
    UploadTask uploadTask = reference.putFile(myFile!);
    urlM = await uploadTask.then((res) => res.ref.getDownloadURL());
    print('## ${urlM!}');
  }

  Future<void> selectImg(ImageSource imageSource) async {
    var myImg = await ImagePicker()
        .pickImage(source: imageSource, maxHeight: 500, maxWidth: 500);
    setState(() {
      myFile = File(myImg!.path);
    });
  }

  Widget shoeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {
              selectImg(ImageSource.camera);
              setState(() {
                isActive = true;
              });
            },
            icon: Icon(
              Icons.add_a_photo,
              size: 40,
              color: Colors.purple,
            )),
        IconButton(
            onPressed: () {
              selectImg(ImageSource.gallery);
              setState(() {
                isActive = true;
              });
            },
            icon: Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: Colors.purple,
            )),
        ElevatedButton(
          onPressed: isActive
              ? () {
                  setState(() {
                    isActive = false;
                  });
                  uploadPictureToStorage();
                }
              : null,
          child: Text('ยืนยันรูปภาพ'),
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    findProfile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลส่วนตัว"),
      ),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("asset/images/bg1.png"),
                      fit: BoxFit.cover)),
              padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: new SizedBox(
                                    width: 130,
                                    height: 130,
                                    child: myFile == null
                                        ? Image.asset(
                                            'asset/images/123.png',
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(myFile!,
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      shoeButton(),
                      SizedBox(height: 30),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "ชื่อผู้ใช้",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 35),
                                Container(
                                  alignment: Alignment.center,
                                  width: 180,
                                  height: 40,
                                  child: TextFormField(
                                    validator: (value) {
                                      RegExp regex = new RegExp(r'^.{2,}$');
                                      if (value!.isEmpty) {
                                        return ("กรุณากรอกชื่อผู้ใช้");
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return ("กรุณากรอกชื่อผู้ใช้มากกว่า 3 ตัวอักษร");
                                      }
                                      return null;
                                    },
                                    onSaved: (String? name) {
                                      nameM = name!;
                                    },
                                    initialValue: userModel!.name,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '${userModel!.name}',
                                        hintStyle: TextStyle(fontSize: 18),
                                        border: OutlineInputBorder()),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 60),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 40,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '${userModel!.age}';
                                      } else if (int.tryParse(value)! > 100 ||
                                          int.tryParse(value)! < 7) {
                                        return 'กรุณากรอกอายุที่ถูกต้อง';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (String? age) {
                                      ageM = double.tryParse(age!);
                                    },
                                    initialValue:
                                        '${userModel!.age.toStringAsFixed(0)}',
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '${userModel!.age}',
                                        hintStyle: TextStyle(fontSize: 18),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(uid)
                                      .update({
                                    'age': ageM,
                                    'name': nameM,
                                    'urlProfile': urlM,
                                  });
                                } catch (e) {}
                                FlameAudio.playLongAudio('bt_m.mp3');
                                FlameAudio.bgm.pause();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    MyConstant.routePagemenu, (route) => false);
                              }
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
                                  "ยืนยันการแก้ไข",
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
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
