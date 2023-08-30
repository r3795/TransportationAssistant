import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../models/model_leg.dart';
import '../models/model_stationInfo.dart';
import '../provider/provider_itinerary.dart';
import '../provider/provider_search_variable.dart';

class AlarmBot extends StatefulWidget {
  const AlarmBot({Key? key}) : super(key: key);

  @override
  State<AlarmBot> createState() => _AlarmBotState();
}

class _AlarmBotState extends State<AlarmBot> {
  @override
  Widget build(BuildContext context) {
    final alarmitineraryProvider = Provider.of<AlarmItineraryProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    bool hasRequestTest = alarmitineraryProvider.hasRequestTest;

    List<Leg> legs = alarmitineraryProvider.itinerary.legs;
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

    return Expanded(
      //전체 위젯
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: true),
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
                  _DeliveryProcesses(
                    processes: data.deliveryProcesses,
                    routeColors: routeColors,
                    routes: routes,
                  ),
                  const Divider(height: 1.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
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



