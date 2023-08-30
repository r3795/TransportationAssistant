import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../models/model_leg.dart';
import '../models/model_stationInfo.dart';

Widget buildRouteLine(
  List<Leg> legs,
  List<Color> colors,
) {
  List<String> modes = legs.map((leg) => leg.mode).toList();
  List<String?> routes =
      legs.map((leg) => leg.route).toList(); //간선:151, 수도권 4호선 등등

  List<List<StationInfo>?> startStations =
      legs.map((leg) => leg.stationList).toList();

  modes.removeWhere((mode) => mode == "WALK" || mode == "TRANSFER");
  colors.removeWhere((color) => color == const Color(0x00000000));
  modes.add("WALK");
  colors.add(const Color(0xff5f5f5f));
  routes.removeWhere((item) => item == null || item.isEmpty);

  List<String> stationName = [];

  for (int i = 0; i < startStations.length - 1; i++) {
    var stationList = startStations[i];
    if (stationList != null && stationList.isNotEmpty) {
      stationName.add(stationList[0].stationName);
      if (i == startStations.length - 2) {
        stationName.add(stationList[stationList.length - 1].stationName);
      }
    }
  }

  print('modesmodesmodesmodesmodesmodesmodesmodesmodesmodesmodesmodes: $modes');

  int itemCount = modes.length; // dot 개수
  double space = 32.0; //dot 끼리 간격

  return SizedBox(
    height: (space + 10) * itemCount,
    child: Timeline.tileBuilder(
      physics: const NeverScrollableScrollPhysics(), // 스크롤 막기
      theme: TimelineThemeData(
        nodePosition: 0, //노드 좌측인지 우측인지
        connectorTheme: const ConnectorThemeData(
          thickness: 3.5,
          color: Color(0xffff0000), //기본 커넥터 색
        ),
        indicatorTheme: const IndicatorThemeData(
          size: 20.0, //점 크기
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),

      builder: TimelineTileBuilder.connected(
        contentsBuilder: (_, index) => Contents(
            route: index < routes.length ? routes[index] : null,
            color: index < colors.length ? colors[index] : Colors.transparent,
            stationName: index < stationName.length ? stationName[index] : ''),
        connectorBuilder: (_, index, __) {
          return SolidLineConnector(color: index < colors.length ? colors[index] : Colors.transparent);
        },
        indicatorBuilder: (_, index) {
          //인디케이터 빌더 하나는 하나의 인디케이터만 만든다
          switch (modes[index]) {
            case "WALK":
              return DotIndicator(
                color: colors[index],
                child: const Icon(
                  Icons.directions_walk,
                  color: Colors.white,
                  size: 14.0,
                ),
              );
            case "BUS":
              return DotIndicator(
                color: colors[index],
                child: const Icon(
                  Icons.directions_bus,
                  size: 14.0,
                  color: Colors.white,
                ),
              );
            case "SUBWAY":
              return DotIndicator(
                color: colors[index],
                child: const Icon(
                  Icons.subway_outlined,
                  size: 14.0,
                  color: Colors.white,
                ),
              );
            case "TRANSFER":
              return DotIndicator(
                color: colors[index],
                child: const Icon(
                  Icons.directions_walk,
                  color: Colors.white,
                  size: 14.0,
                ),
              );
            case "TRAIN":
              return DotIndicator(
                color: colors[index],
                child: const Icon(
                  Icons.train,
                  color: Colors.white,
                  size: 14.0,
                ),
              );
            case "AIRPLANE":
              return DotIndicator(
                color: colors[index],
                child: const Icon(
                  Icons.airplanemode_active_outlined,
                  color: Colors.white,
                  size: 14.0,
                ),
              );
            default:
              return const OutlinedDotIndicator(
                color: Color(0xffbabdc0),
                backgroundColor: Color(0xffe6e7e9),
              );
          }
        },
        itemExtentBuilder: (_, __) => space,
        itemCount: modes.length,
      ),
    ),
  );
}

class Contents extends StatelessWidget {
  final String? route;
  final Color color;
  final String stationName;

  const Contents(
      {Key? key, this.route, required this.color, required this.stationName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        margin: EdgeInsets.only(left: 10.0),
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: color,
        ),
        child: Text(
          route ?? '하차',
          style: TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      Spacer(), // Add Spacer between the containers
      Container(
        margin: EdgeInsets.only(right: 10.0),
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Text(
          (stationName != null && stationName.length > 17) ? '${stationName.substring(0, 17)}..' : stationName ?? '',
          style: TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    ]);

  }
}
