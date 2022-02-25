import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_game/pageAuth/home.dart';
import 'package:project_game/pageAuth/pageMenu.dart';
import 'package:project_game/states/count_timebird.dart';
import 'package:project_game/states/count_timebox.dart';
import 'package:project_game/states/count_timefingermaths.dart';
import 'package:project_game/states/count_timeflagraising.dart';
import 'package:project_game/states/count_timerock.dart';
import 'package:project_game/states/edit_profile.dart';
import 'package:project_game/states/game_bird.dart';
import 'package:project_game/states/game_box.dart';
import 'package:project_game/states/game_flagraising.dart';
import 'package:project_game/states/graph_bird.dart';
import 'package:project_game/states/graph_box.dart';
import 'package:project_game/states/graph_fingermath.dart';
import 'package:project_game/states/graph_flag.dart';
import 'package:project_game/states/graph_rock.dart';
import 'package:project_game/states/intro_fingermaths.dart';
import 'package:project_game/states/intro_bird.dart';
import 'package:project_game/states/intro_box.dart';
import 'package:project_game/states/intro_flagraising.dart';
import 'package:project_game/states/intro_rock.dart';
import 'package:project_game/states/multiplayer/createroom.dart';
import 'package:project_game/states/multiplayer/findroom.dart';
import 'package:project_game/states/multiplayer/multigame_bird.dart';
import 'package:project_game/states/multiplayer/multigame_box.dart';
import 'package:project_game/states/multiplayer/multimain.dart';
import 'package:project_game/states/multiplayer/prebird.dart';
import 'package:project_game/states/multiplayer/prebox.dart';
import 'package:project_game/states/multiplayer/result_game.dart';
import 'package:project_game/states/multiplayer/room.dart';
import 'package:project_game/states/multiplayer/roomuser.dart';
import 'package:project_game/states/profile.dart';
import 'package:project_game/states/realtime_camera/live_Rock.dart';
import 'package:project_game/states/realtime_camera/live_finger.dart';
import 'package:project_game/states/result_bird.dart';
import 'package:project_game/states/result_box.dart';
import 'package:project_game/states/result_fingermaths.dart';
import 'package:project_game/states/result_flagraising.dart';
import 'package:project_game/states/result_rock.dart';
import 'package:project_game/utility/my_constant.dart';

List<CameraDescription>? cameras;
Map<String, WidgetBuilder> map = {
  MyConstant.routeHome: (BuildContext context) => HomeScreen(),
  MyConstant.routePagemenu: (BuildContext context) => PageMenu(),
  MyConstant.routeIntroBird: (BuildContext context) => IntroBird(),
  MyConstant.routeCountTimeBird: (BuildContext context) => CountTimeBird(),
  MyConstant.routeGameBird: (BuildContext context) => GameBird(),
  MyConstant.routeResultBird: (BuildContext context) => ResultBird(),
  MyConstant.routeIntroBox: (BuildContext context) => IntroBox(),
  MyConstant.routeCountTimeBox: (BuildContext context) => CountTimeBox(),
  MyConstant.routeGameBox: (BuildContext context) => GameBox(),
  MyConstant.routeResultBox: (BuildContext context) => ResultBox(),
  MyConstant.routeIntroFlagraising: (BuildContext context) =>
      IntroFlagraising(),
  MyConstant.routeCountTimeFlagraising: (BuildContext context) =>
      CountTimeFlagraising(),
  MyConstant.routeGameFlagraising: (BuildContext context) => GameFlagraising(),
  MyConstant.routeResultFlagraising: (BuildContext context) =>
      ResultFlagraising(),
  MyConstant.routeIntroFingermath: (BuildContext context) => IntroFingermath(),
  MyConstant.routeCountTimeFingermath: (BuildContext context) =>
      CountTimeFingermath(),
  MyConstant.routeLiveFeedFingermaths: (BuildContext context) =>
      LiveFeedFingermaths(cameras!),
  MyConstant.routeResultFingermaths: (BuildContext context) =>
      ResultFingermath(),
  MyConstant.routeIntroRock: (BuildContext context) => IntroRock(),
  MyConstant.routeCountTimeRock: (BuildContext context) => CountTimeRock(),
  MyConstant.routeLiveFeedRock: (BuildContext context) =>
      LiveFeedRock(cameras!),
  MyConstant.routeResultRock: (BuildContext context) => ResultRock(),
  MyConstant.routeProfile: (BuildContext context) => Profile(),
  MyConstant.routeEditProfile: (BuildContext context) => EditProfile(),
  MyConstant.routeGraphBird: (BuildContext context) => GraphBird(),
  MyConstant.routeGraphBox: (BuildContext context) => GraphBox(),
  MyConstant.routeGraphFlag: (BuildContext context) => GraphFlag(),
  MyConstant.routeGraphFingermath: (BuildContext context) => GraphFingermath(),
  MyConstant.routeGraphRock: (BuildContext context) => GraphRock(),
  MyConstant.routecreateRoom: (BuildContext context) => createRoom(),
  MyConstant.routefindRoom: (BuildContext context) => findRoom(),
  MyConstant.routeroomGame: (BuildContext context) => roomGame(),
  MyConstant.routeroomUser: (BuildContext context) => roomUser(),
  MyConstant.routemultiMain: (BuildContext context) => multiMain(),
  MyConstant.routeMulti_GameBird: (BuildContext context) => Multi_GameBird(),
  MyConstant.routeMulti_GameBox: (BuildContext context) => Multi_GameBox(),
  MyConstant.routePreBird: (BuildContext context) => PreBird(),
  MyConstant.routePreBox: (BuildContext context) => PreBox(),
  MyConstant.routeResultMultiGame: (BuildContext context) => ResultMultiGame(),
};

String? firstState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp().then((value) async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        firstState = MyConstant.routeHome;
        runApp(MyApp());
      } else {
        firstState = MyConstant.routePagemenu;
        runApp(MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: map,
      initialRoute: firstState,
    );
  }
}
