import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project_game/model/profile.dart';
// ignore: unused_import
import 'package:project_game/pageAuth/pageMenu.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  Profile profile =
      Profile(email: '', password: '', age: '', name: '', urlProfile: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;
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
                title: Text("เปลี่ยนรหัสผ่าน"),
              ),
              body: Container(
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
                              EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
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
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                child: Text("ยืนยืนการเปลี่ยนรหัสผ่าน",
                                    style: TextStyle(fontSize: 20)),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    try {
                                      auth.sendPasswordResetEmail(
                                          email: profile.email);
                                      // ignore: unused_catch_clause
                                    } on FirebaseAuthException catch (e) {}
                                  }
                                  FlameAudio.playLongAudio('bt3.mp3');
                                  Navigator.of(context).pop();
                                }),
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
