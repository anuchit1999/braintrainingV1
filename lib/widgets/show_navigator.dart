import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/utility/my_constant.dart';

class ShowNavigator extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String routeState;
  const ShowNavigator({
    Key? key,
    required this.iconData,
    required this.label,
    required this.routeState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeState);
        FlameAudio.playLongAudio('bt1.mp3');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                iconData,
                color: MyConstant.dart,
              ),
              title: ShowTitle(
                title: label,
                textStyle: MyConstant().h2Style(),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: MyConstant.dart,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
