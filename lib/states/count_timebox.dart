import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/utility/my_constant.dart';

class CountTimeBox extends StatefulWidget {
  const CountTimeBox({Key? key}) : super(key: key);

  @override
  _CountTimeBoxState createState() => _CountTimeBoxState();
}

class _CountTimeBoxState extends State<CountTimeBox> {
  int count = 3;

  @override
  void initState() {
    super.initState();
    autoCount();
    FlameAudio.bgm.pause();
  }

  Future<void> autoCount() async {
    Duration duration = Duration(seconds: 1);
    // ignore: await_only_futures
    await Timer(duration, () {
      if (count == 0) {
        FlameAudio.playLongAudio('cd2.mp3');
        Navigator.pushNamedAndRemoveUntil(
            context, MyConstant.routeGameBox, (route) => false);
      } else {
        FlameAudio.playLongAudio('cd1.mp3');
        setState(() {
          count--;
        });
        autoCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShowTitle(
          title: count.toString(),
          textStyle: MyConstant().h0Style(),
        ),
      ),
    );
  }
}
