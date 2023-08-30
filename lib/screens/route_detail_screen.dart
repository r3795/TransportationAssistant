import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:fluter_tuto/screens/alarm_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../Services/notifi_service.dart';
import '../main.dart';
import '../models/model_itinerary.dart';
import '../models/model_leg.dart';
import '../models/model_stationInfo.dart';
import '../provider/provider_itinerary.dart';
import '../provider/provider_search_variable.dart';
import '../provider/provider_tap_index.dart';
import '../widgets/route_bar.dart';

// int currentTargetIndex = 0;

class RouteDetailScreen extends StatelessWidget {
  //const 없애야 오류가 안 뜨네?
  RouteDetailScreen(
      {Key? key,
      required this.itinerary,
      required this.transTargetList,
      })
      : super(key: key);
  final Itinerary itinerary;
  final List<StationInfo?> transTargetList;
  // Timer? timer;
  bool isFirstTimerStart = true;
  final player = AudioPlayer();



  //
  // @override
  // void initState() {
  //   super.initState();
  //   startTimer();
  //   testLocation();
  //   // getLocation();
  // }
  // @override
  // void dispose() {
  //   super.dispose();
  //   timer?.cancel(); // 타이머 중지
  // }



  //
  late SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    final alarmitineraryProvider = Provider.of<AlarmItineraryProvider>(context);
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    bool hasRequestTest = alarmitineraryProvider.hasRequestTest;

    void testLocation() async {

      LocationPermission permission =
      await Geolocator.requestPermission(); //오류 해결 코드
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double lat = double.parse(transTargetList[currentTargetIndex]!.lat);
      double lon = double.parse(transTargetList[currentTargetIndex]!.lon);

      double distanceInMeters = Geolocator.distanceBetween(
          position.latitude, position.longitude, lat, lon);
      print(position);
      print('환승타겟 x: $lat, y:$lon');
      print(distanceInMeters);
      if (distanceInMeters <= 1000) {
        // print("lat: "+transTargetList[currentTargetIndex]!.lat+","+"lon: "+transTargetList[currentTargetIndex]!.lon);
        // print("환승 타겟에 도달했습니다. 타겟을 변경합니다.");
        if (currentTargetIndex < transTargetList.length - 1) {
          NotificationService().showNotification(
            title: '환승 지점 주변 도달!',
            body: '하차를 준비해주세요!',
          );
          player.play(AssetSource('transit.mp3'));
          Vibration.vibrate(duration: 2000);
          currentTargetIndex++;
          // 마지막 목적지 도착 전까지의 알람 형식
          // print("환승 지점 ㅇㅇ 주변 도달!");
          // print("다음 환승지는 xx 입니다!");
        } else {
          // Last element reached, exit the app
          NotificationService().showNotification(
            title: '목적지 주변에 도달하였습니다!',
            body: '하차 알림 종료!',
          );
          player.play(AssetSource('destination.mp3'));
          Vibration.vibrate(duration: 2000);
          print("목적지 주변에 도달!");
          print("하차 알림 종료!");
          //환승 지점이 가르키는 포인터가 다시 맨 처음을 가리키도록
          currentTargetIndex = 0;
          //timer가 처음인 것 처럼 바꿔준다 -> 처음 알림 시작 시 시작 알림은 조금 다르기때문
          isFirstTimerStart = true;
          ttimer?.cancel();
          //알람탭에 있는 알람도 삭제
          alarmitineraryProvider.setRequest(false);
          alarmitineraryProvider.setItinerary(Itinerary.empty());


        }
        print("lat: " +
            transTargetList[currentTargetIndex]!.lat +
            "," +
            "lon: " +
            transTargetList[currentTargetIndex]!.lon);
      }
    }
    void startTimer() {
      // 10초마다 실행되는 콜백 함수
      if (isFirstTimerStart) {
        isFirstTimerStart = false;
        NotificationService().showNotification(
          title: '하차 알림 서비스 시작!',
          body: '편안한 운행 되세요!',
        );
        player.play(AssetSource('notification.mp3'));
        Vibration.vibrate(duration: 2000);
      }
      void callback(Timer timer) {
        testLocation();
      }

      // 타이머 시작
      ttimer = Timer.periodic(const Duration(seconds: 10), callback);
    }



    List<Leg> legs = itinerary.legs;
    List<Color> routeColors = legs.map((leg) {
      if (leg.routeColor == null || leg.routeColor!.isEmpty) {
        return Colors.transparent;
      } else {
        return Color(int.parse('FF${leg.routeColor!}', radix: 16));
      }
    }).toList();

    List<List<StationInfo>?> stationList =
        legs.map((leg) => leg.stationList).toList();

    List<List> stationNames = stationList.map((stationInfoList) {
      return stationInfoList!.map((stationInfo) {
        return stationInfo.stationName;
      }).toList();
    }).toList();

    List<String?> routes =
        legs.map((leg) => leg.route).toList(); //간선:151, 수도권 4호선 등등

    stationNames.removeWhere((stationInfoList) => stationInfoList.isEmpty);
    routeColors.removeWhere((color) => color == Color(0x00000000));

    routeColors.add(Color(0x88565656));

    routes.removeWhere((route) => route == '');

    // print('**************************');
    // print(routes);

    return Scaffold(
      backgroundColor: Colors.white,
      //전체 위젯
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        // Set overscroll to false
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 25.0),
          itemCount: 1,
          itemBuilder: (context, index) {
            final data = _data(stationNames);
            return Card(
            //각 프로세스에 대한 ui 구성
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                detailRouteBox(itinerary),
                const Divider(height: 1.0),
                _DeliveryProcesses(
                  processes: data.deliveryProcesses,
                  routeColors: routeColors,
                  routes: routes,
                ),
                const Divider(height: 1.0),
                Container(
                  height: 1,
                  color: const Color(0xFF000000),
                ),
                const Divider(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    if (!hasRequestTest) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.alarm_on_outlined,
                                    color: Colors.black),
                                Text('  하차 알림을 시작합니다.'),
                              ],
                            ),
                            content: Text('네, 혹은 취소를 눌러주세요'),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: Text(
                                      '네!',
                                      style: TextStyle(
                                        color: Colors
                                            .black, // Setting the text color to black
                                      ),
                                    ),
                                    onPressed: () {
                                      startTimer();
                                      alarmitineraryProvider.setItinerary(
                                          itinerary);
                                      //알람 탭에서 알람을 보여줘야 하니까..
                                      alarmitineraryProvider.setRequest(true);
                                      searchProvider.setAlarm();

                                      //뒤로 가는 거니까 search를 초기화 해야지
                                      searchProvider.setSourceUpdatePlace("source");
                                      searchProvider.setDestinationUpdatePlace("destination");
                                      searchProvider.setSourceSelected(false);
                                      searchProvider.setDestinationSelected(false);

                                      Provider.of<TabIndexProvider>(context, listen: false)
                                          .setTabIndex(1);

                                      //맨 처음 화면으로 보내버리기
                                      Navigator.pushNamed(context, '/home');

                                      // Navigator.pushReplacementNamed(context, '/home');
                                      // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

                                      // 둘 중 하나 쓰면 될 듯
                                      // Navigator.of(context).popUntil((route) => route.isFirst);




                                      // 시도하다가 안 된 코드들
                                      //

                                      // void navigateToAlarmTab() {
                                      //   if (appContext != null) {
                                      //     final tabController = DefaultTabController.of(appContext!);
                                      //     tabController!.index = 1; // Navigate to Alarm tab
                                      //   }
                                      // }
                                      // navigateToAlarmTab();


                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => AlarmScreen()));
                                      // //알람 탭을 이동하기
                                      // Get the TabController instance
                                      // final TabController? tabController = DefaultTabController.of(context);
                                      // Set the index of the TabController to the 'Alarm' tab index
                                      // tabController?.index = 1;
                                      // final TabController? tabController = DefaultTabController.of(context);
                                      // if (tabController != null) {
                                      //   //tapBarView에서 alarmScreen()의 인덱스가 1이어서
                                      //   tabController.index = 1;
                                      // }
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      '취소',
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
                    }else{
                      // hasRequestTest가 True (알람이 이미 설정되어 있을 때)
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('이미 하차 알람이 설정됨'),
                              content: Text('기존 하차 알람 취소 후 \n하차 알람을 새로 설정하시겠습니까?'),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      child: Text('네'),
                                      onPressed: () {
                                        // 기존 알람 취소
                                        alarmitineraryProvider.setRequest(false);
                                        alarmitineraryProvider.setItinerary(Itinerary.empty());
                                        currentTargetIndex = 0;
                                        isFirstTimerStart = true;
                                        ttimer?.cancel();

                                        // 새 알람 설정
                                        startTimer();
                                        alarmitineraryProvider.setItinerary(
                                            itinerary);
                                        //알람 탭에서 알람을 보여줘야 하니까..
                                        alarmitineraryProvider.setRequest(true);
                                        searchProvider.setAlarm();

                                        //뒤로 가는 거니까 search를 초기화 해야지
                                        searchProvider.setSourceUpdatePlace("source");
                                        searchProvider.setDestinationUpdatePlace("destination");
                                        searchProvider.setSourceSelected(false);
                                        searchProvider.setDestinationSelected(false);

                                        Provider.of<TabIndexProvider>(context, listen: false)
                                            .setTabIndex(1);

                                        //맨 처음 화면으로 보내버리기
                                        Navigator.pushNamed(context, '/home');

                                      },
                                    ),
                                    TextButton(
                                      child: Text('아니오'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                      },
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // Button color
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.black), // Text color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black))),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.notifications_active_outlined,
                          color: Colors.black), // Clock icon
                      SizedBox(width: 5), // Space between icon and text
                      Text('하차 알림 시작!'), // Button text
                    ],
                  ),
                ),
              ],
            ),
            );
          },
        ),
      ),
    );
  }
}

Widget detailRouteBox(
  Itinerary itinerary,
) {
  var totalFare = itinerary.totalFare;
  var totalTime = itinerary.totalTime;
  var totalWalkTime = itinerary.totalWalkTime;
  List<Leg> legs = itinerary.legs;
  List<int> sectionTimes = legs.map((leg) => leg.sectionTime).toList();
  List<String?> routeColors = legs.map((leg) => leg.routeColor).toList();
  List<String> modes = legs.map((leg) => leg.mode).toList();

  List<Color> colors = routeColors.map((colorString) {
    if (colorString == '') {
      return Colors.transparent;
    } else {
      return Color(int.parse(colorString!, radix: 16) + 0xFF000000);
    }
  }).toList();

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (totalTime ~/ 60) > 60
              ? '${(totalTime ~/ 60) ~/ 60} 시간 ${((totalTime ~/ 60) % 60)} 분'
              : '${totalTime ~/ 60} 분',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            Container(
              // margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white, // Change color to white
                border: Border.all( // Add black border
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Text(
                '요금 : $totalFare 원 ',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black, // Change color to black
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white, // Change color to white
                border: Border.all( // Add black border
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Text(
                '도보거리 : ${totalWalkTime ~/ 60} 분',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black, // Change color to black
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        buildFlexibleContainers(sectionTimes, colors, modes),
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: const Color(0xFF000000),
        ),
      ],
    ),
  );
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
    required this.index,
    required this.routeColors,
  });

  final List<_DeliveryMessage> messages;
  final int index;
  final List<Color> routeColors;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: ConnectorThemeData(
            color: routeColors[index], // Use the route color here
            thickness: 2.5, // Thickness between indicators
          ),
          indicatorTheme: IndicatorThemeData(
            color: routeColors[index], // indicator color
            position: 0.1,
            size: 9.0, // indicator dot size
          ),
        ),

        //커스텀 타임라인 빌더 사용
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1) : null,
          //이너 타임라인 인디케이터 점 굵기
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                messages[index - 1].toString(),
                style: TextStyle(
                  fontWeight: index == messages.length ? FontWeight.bold : FontWeight.normal,
                  color: index == messages.length ? Colors.black : Colors.grey,
                ),
              ),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 15.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 1,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatefulWidget {
  const _DeliveryProcesses({
    Key? key,
    required this.processes,
    required this.routeColors,
    required this.routes,
  }) : super(key: key);

  final List<_DeliveryProcess> processes;
  final List<Color> routeColors;
  final List<String?> routes;

  @override
  __DeliveryProcessesState createState() => __DeliveryProcessesState();
}

class __DeliveryProcessesState extends State<_DeliveryProcesses> {
  late List<bool> _innerTimelineVisibility;

  @override
  void initState() {
    super.initState();
    _innerTimelineVisibility = List.filled(widget.processes.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Color(0xff9b9b9b), //The color of the message
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            indicatorTheme: const IndicatorThemeData(
              position: 0,
              size: 20.0, // indicator dot size
            ),
            connectorTheme: const ConnectorThemeData(
              // color: Colors.red, //Indicator line color
              thickness: 2.5, // Thickness between indicators
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.after,
            itemCount: widget.processes.length,
            contentsBuilder: (_, index) {
              if (widget.processes[index].isCompleted) return null;

              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18.0,
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: widget.routeColors[index],
                        // You can change this to any color you prefer
                        borderRadius: BorderRadius.circular(
                            5), // Change this to adjust the roundness of the corners
                      ),
                      child: Text(
                        widget.routes[index]!,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        setState(() {
                          _innerTimelineVisibility[index] =
                              !_innerTimelineVisibility[index];
                        });
                      },
                      child: const Text(
                        '상세 경로 보기 ▼',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    if (_innerTimelineVisibility[index])
                      _InnerTimeline(
                          messages: widget.processes[index].messages,
                          index: index,
                          routeColors: widget.routeColors),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (widget.processes[index].isCompleted) {
                return DotIndicator(
                  color: widget.routeColors[index],
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                  color: widget.routeColors[index],
                  borderWidth: 2.5,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: widget.routeColors[index],
            ),
          ),
        ),
      ),
    );
  }
}

_OrderInfo _data(List<List> names) {
  List<_DeliveryProcess> deliveryProcesses = names.map((nameList) {
    String title = nameList.first;
    List<_DeliveryMessage> messages =
        nameList.sublist(1).map((name) => _DeliveryMessage(name)).toList();
    return _DeliveryProcess(title, messages: messages);
  }).toList();

  deliveryProcesses.add(const _DeliveryProcess.complete());

  return _OrderInfo(deliveryProcesses: deliveryProcesses);
}

class _OrderInfo {
  const _OrderInfo({
    required this.deliveryProcesses,
  });

  final List<_DeliveryProcess> deliveryProcesses;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  const _DeliveryProcess.complete()
      : name = 'Done',
        messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
