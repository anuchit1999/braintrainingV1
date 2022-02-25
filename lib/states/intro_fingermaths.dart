import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_progress.dart';

class IntroFingermath extends StatefulWidget {
  const IntroFingermath({Key? key}) : super(key: key);

  @override
  _IntroFingermathState createState() => _IntroFingermathState();
}

class _IntroFingermathState extends State<IntroFingermath> {
  List<String> images = [
    'asset/images/finger.jpg',
    'asset/images/fingerD.jpg',
    'asset/images/submit.jpg',
  ];
  List<String> titles = [
    'กติกาการเล่น',
    'รายละเอียด',
    'รายละเอียด',
  ];
  List<String> bodys = [
    'จงคำนวณโจทย์ที่ได้รับ ซึ่งสามารถดูได้จากแถบด้านบน โจทย์มีทั้งหมด 10 ข้อ',
    'การตอบนั้นคำตอบจะอยู่ในช่วง 0-5 ซึ่งโทรศัพท์จะทำการเปิดกล้องไว้ เมื่อนำมือเข้าไปในกล้อง จะเกิดกรอบการทำนายผลขึ้นเมื่อตรงตามที่ต้องการให้กดปุ่ม Submit',
    'ปุ่ม Submit มีไว้สำหรับกดเพื่อตอบและไปยังโจทย์ข้อต่อไปเมื่อครบ 10 ข้อ การกดจะเปลี่ยนไปเป็นการไปยังหน้าสรุปผลทันที',
  ];
  List<PageViewModel> pageViewModels = [];

  @override
  void initState() {
    super.initState();
    int index = 0;
    for (var item in titles) {
      setState(() {
        pageViewModels.add(
          createPageViewModel(
            item,
            bodys[index],
            images[index],
          ),
        );
      });
      index++;
    }
  }

  PageViewModel createPageViewModel(
    String title,
    String body,
    String pathImage,
  ) =>
      PageViewModel(
        titleWidget: ShowTitle(
          title: title,
          textStyle: MyConstant().h1Style(),
        ),
        body: body,
        image: Container(
          width: 300,
          height: 300,
          child: Image.asset(pathImage),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แนะนำเกม'),
      ),
      body: pageViewModels.isEmpty
          ? ShowProgress()
          : IntroductionScreen(
              pages: pageViewModels,
              onDone: () => Navigator.pushNamedAndRemoveUntil(context,
                  MyConstant.routeCountTimeFingermath, (route) => false),
              done: Icon(Icons.forward),
              skip: ShowTitle(
                title: 'ข้าม',
                textStyle: MyConstant().h3Style(),
              ),
              showSkipButton: true,
              showNextButton: true,
              next: Icon(Icons.forward),
            ),
    );
  }
}
