import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_game/model/profile.dart';
import 'package:project_game/pageAuth/pageMenu.dart';
import 'package:project_game/pageAuth/repassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  Profile profile =
      Profile(email: '', password: '', age: '', name: '', urlProfile: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
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
                title: Text("เข้าสู่ระบบ"),
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
                          TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "กรุณาป้อนอีเมลด้วยครับ"),
                                EmailValidator(
                                    errorText: "รูปแบบอีเมลไม่ถูกต้อง")
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String? email) {
                                profile.email = email!;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ))),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"),
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("ลงชื่อเข้าใช้",
                                  style: TextStyle(fontSize: 20)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    FlameAudio.bgm.stop();
                                    FlameAudio.playLongAudio('st_main.mp3');
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: profile.email,
                                            password: profile.password)
                                        .then((value) {
                                      formKey.currentState!.reset();
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return PageMenu();
                                      }));
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    Fluttertoast.showToast(
                                        msg: e.message!,
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("เปลี่ยนแปลงรหัสผ่าน",
                                  style: TextStyle(fontSize: 20)),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () async {
                                FlameAudio.playLongAudio('bt3.mp3');
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ResetPassword();
                                }));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 500,
                          )
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
