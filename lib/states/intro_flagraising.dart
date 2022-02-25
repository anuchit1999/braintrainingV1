import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:project_game/model/show_title.dart';
import 'package:project_game/utility/my_constant.dart';
import 'package:project_game/widgets/show_progress.dart';

class IntroFlagraising extends StatefulWidget {
  const IntroFlagraising({Key? key}) : super(key: key);

  @override
  _IntroFlagraisingState createState() => _IntroFlagraisingState();
}

class _IntroFlagraisingState extends State<IntroFlagraising> {
  List<String> images = [
    'asset/images/flat.jpg',
    'asset/images/flatD.png',
    'asset/images/submit.jpg',
  ];
  List<String> titles = [
    'กติกาการเล่น',
    'รายละเอียด',
    'รายละเอียด',
  ];
  List<String> bodys = [
    'จงจำทิศทางที่แสดงในรูปภาพ โจทย์มีทั้งหมด 5 ข้อ โดยแต่ละข้อจะเก็บค่าของข้อโจทย์ก่อนหน้าไว้ด้วย เช่น ข้อ 2 จะต้องกดตอบในทิศของข้อ 1 ก่อน และตามด้วยก็ที่ 2',
    'การกำหนดค่าการตอบจะเป็นการหมุนโทรศัพท์ไปยังทิศต่างq เช่น เมื่อเจอโจทย์ลูกขึ้นให้ตั้งโทรศัพท์ 90 องศาจะเห็นคำว่า UP แสดงบนหน้าจอ จากนั้นกดปุ่ม Submit',
    'ปุ่ม Submit มีไว้สำหรับกดเพื่อตอบและไปยังโจทย์ข้อต่อไปเมื่อครบ 5 ข้อ การกดจะเปลี่ยนไปเป็นการไปยังหน้าสรุปผลทันที',
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
                  MyConstant.routeCountTimeFlagraising, (route) => false),
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
