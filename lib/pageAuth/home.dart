import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/pageAuth/login.dart';
import 'package:project_game/pageAuth/register.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FlameAudio.bgm.pause();
    FlameAudio.bgm.play('bg_main.mp3');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mobile Application for BrainTraining",
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('asset/images/bg1.png'), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Image.asset("asset/images/123.png"),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    label: Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      FlameAudio.playLongAudio('bt3.mp3');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.app_registration),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    label: Text(
                      "สร้างบัญชีผู้ใช้",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      FlameAudio.playLongAudio('bt3.mp3');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RegisterPage();
                      }));
                    },
                  ),
                ),
                SizedBox(
                  height: 400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
