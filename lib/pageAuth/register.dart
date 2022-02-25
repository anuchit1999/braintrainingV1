import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_game/model/profile.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(
      email: '',
      password: '',
      age: '',
      name: '',
      urlProfile:
          'https://firebasestorage.googleapis.com/v0/b/project-game-c7713.appspot.com/o/User%2Fuser.jpeg?alt=media&token=c83ebcb9-8d65-4b28-91c7-0623e62760d5');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference user = FirebaseFirestore.instance.collection('user');
  final auth = FirebaseAuth.instance;
  // ignore: avoid_init_to_null
  File? myFile;
  bool isActive = false;

  @override
  // ignore: override_on_non_overriding_member
  Widget showImage() {
    return Row(
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
                  : Image.file(myFile!, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('User/user$i.jpg');
    UploadTask uploadTask = reference.putFile(myFile!);
    profile.urlProfile =
        await uploadTask.then((res) => res.ref.getDownloadURL());
    print('## ${profile.urlProfile}');
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

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("สร้างบัญชีผู้ใช้"),
              ),
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('asset/images/bg1.png'),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showImage(),
                          shoeButton(),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: "กรุณาป้อนอีเมลด้วยครับ"),
                              EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? email) {
                              profile.email = email!;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{8}$');
                              if (value!.isEmpty) {
                                return ("กรุณากรอกชื่อผู้ใช้");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("กรุณากรอกรหัสผ่านมากกว่า 7 ตัวอักษร");
                              }
                              return null;
                            },
                            obscureText: true,
                            onSaved: (String? password) {
                              profile.password = password!;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{2,}$');
                              if (value!.isEmpty) {
                                return ("กรุณากรอกชื่อผู้ใช้");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("กรุณากรอกชื่อผู้ใช้มากกว่า 2 ตัวอักษร");
                              }
                              return null;
                            },
                            onSaved: (String? name) {
                              profile.name = name!;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณากรอกอายุ';
                              } else if (int.tryParse(value)! > 100 ||
                                  int.tryParse(value)! < 7) {
                                return 'กรุณากรอกอายุที่ถูกต้อง';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.number,
                            onSaved: (String? age) {
                              profile.age = age!;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Age",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("ลงทะเบียน",
                                  style: TextStyle(fontSize: 20)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: profile.email,
                                            password: profile.password)
                                        .then((value) {
                                      formKey.currentState!.reset();
                                      user.doc(auth.currentUser!.uid).set({
                                        'name': profile.name,
                                        'age': double.parse(profile.age),
                                        'urlProfile': profile.urlProfile,
                                      });
                                      FlameAudio.bgm.stop();
                                      FlameAudio.playLongAudio('bt3.mp3');
                                      Fluttertoast.showToast(
                                          msg: "สร้างบัญชีผู้ใช้เรียบร้อยแล้ว",
                                          gravity: ToastGravity.TOP);
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return HomeScreen();
                                      }));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    print(e.code);
                                    String message;
                                    if (e.code == 'email-already-in-use') {
                                      message =
                                          "มีอีเมลนี้ในระบบแล้วครับ โปรดใช้อีเมลอื่นแทน";
                                    } else if (e.code == 'weak-password') {
                                      message =
                                          "รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป";
                                    } else {
                                      message = e.message!;
                                    }
                                    Fluttertoast.showToast(
                                        msg: message,
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
