import 'package:fluter_tuto/widgets/alarm_screen_bot.dart';
import 'package:fluter_tuto/widgets/alarm_screen_top.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_itinerary.dart';
import '../provider/provider_search_variable.dart';



class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  //알람을 삭제할 때는 false, 알람을 설정할 때는 true로 바꾸기
  //알람은 1개만 가능하도록..
  //없을 때는 안 보여줘야 하니까!
  late bool hasRequestTest;

  @override
  Widget build(BuildContext context) {
    bool hasRequestTest = Provider.of<AlarmItineraryProvider>(context).hasRequestTest;
    return Scaffold(
      // 이 부분 hasRequest -> hasRequestTest로 일단은 바꿔서 해보는 중
      body: hasRequestTest
          ? Column(
              children: [
                AlarmTop(), //위젯폴더 안에 alarm_screen_top에 구현
                AlarmBot(), //위젯폴더 안에 alarm_screen_bot에 구현
              ],
            )
          : Center(
              child: Text(
                '실행 중인 알람이 없습니다.',
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
    );
  }
}
