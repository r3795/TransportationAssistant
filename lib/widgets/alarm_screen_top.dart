import 'package:fluter_tuto/provider/provider_itinerary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/model_itinerary.dart';
import '../provider/provider_search_variable.dart';

class AlarmTop extends StatefulWidget {
  const AlarmTop({Key? key}) : super(key: key);

  @override
  State<AlarmTop> createState() => _AlarmTopState();
}

class _AlarmTopState extends State<AlarmTop> {
  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final alarmitineraryProvider = Provider.of<AlarmItineraryProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3F4250),
        border: Border.all(color: Color(0xFFE9ECEF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFE9ECEF)),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        (alarmitineraryProvider.itinerary.totalTime ~/ 60) > 60
                            ? '${(alarmitineraryProvider.itinerary.totalTime ~/ 60) ~/ 60} 시간 ${((alarmitineraryProvider.itinerary.totalTime ~/ 60) % 60)} 분'
                            : '${alarmitineraryProvider.itinerary.totalTime ~/ 60} 분',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '총 요금 : ${alarmitineraryProvider.itinerary.totalFare}원',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        // '경기대학교(수원캠퍼스) → 수원역'
                        searchProvider.alarmSourcePlaceName+" → "+searchProvider.alarmDestinationPlaceName,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.alarm_on_outlined,
                                    color: Colors.black),
                                Text('하차 알림을 종료하겠습니까?'),
                              ],
                            ),
                            content: Text('네, 혹은 아니요를 눌러주세요'),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: Text(
                                      '네',
                                      style: TextStyle(
                                        color: Colors
                                            .black, // Setting the text color to black
                                      ),
                                    ),
                                    onPressed: () {
                                      alarmitineraryProvider.setRequest(false);
                                      alarmitineraryProvider.setItinerary(Itinerary.empty());
                                      currentTargetIndex = 0;
                                      isFirstTimerStart = true;
                                      ttimer?.cancel();
                                      Navigator.of(context)
                                          .pop(); // It works the same as pressing the back button
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      '아니요',
                                      style: TextStyle(
                                        color: Colors
                                            .red, // Setting the text color to red
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // It works the same as pressing the back button
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );


                      // 버튼이 눌렸을 때 실행될 함수
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('알림 종료',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
