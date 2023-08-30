import 'dart:ui';

import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'model_drawing_route_list.dart';
import 'model_leg.dart';
import 'model_stationInfo.dart';
class Itinerary {
  //총 요금
  final int totalFare;
  //총 걸린 시간
  final int totalTime;
  //총 도보 거리
  final int totalWalkDistance;
  //총 도보 시간
  final int totalWalkTime;
  //총 이동 거리
  final int totalDistance;
  //Leg를 담은 클래스
  final List<Leg> legs;
  //마커 표시를 위한 출발지점, 도착지점 X,Y좌표
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  @override
  String toString() {
    // TODO: implement toString
    return  'Itinerary{요금: $totalFare, 걸린 시간: $totalTime, 도보 거리:$totalWalkDistance, 총 도보 시간:$totalWalkTime, 이동거리: $totalDistance}';
    //아래는 startX,startY,endX,endY까지 출력하나 크게 필요없어 보여서.
    return  'Itinerary{요금: $totalFare, 걸린 시간: $totalTime, 도보 거리:$totalWalkDistance, 총 도보 시간:$totalWalkTime, 이동거리: $totalDistance, start X: $startX, start Y: $startY, end X:$endX,end Y:$endY}';
  }
  const Itinerary({
    required this.totalFare,
    required this.totalTime,
    required this.totalWalkDistance,
    required this.totalWalkTime,
    required this.totalDistance,
    required this.legs,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY
  });

  factory Itinerary.empty() {
    return Itinerary(
      totalFare: 0,
      totalTime: 0,
      totalWalkDistance: 0,
      totalWalkTime: 0,
      totalDistance: -999,
      legs: [],
      startX: 0.0,
      startY: 0.0,
      endX: 0.0,
      endY: 0.0,
    );
  }

  // 좌표 가공부
  List<String> splitPoint(String points) {
    List<String> pointList = points.split(' ');
    return pointList;
  }

  // 좌표 리스트 정리 및 반환부
  List<RouteSegment> getLngList() {

    List<RouteSegment> route = [];
    List<String> pointList = [];
    double latPoint;
    double longPoint;

    for (Leg leg in legs) {
      if (leg.mode == 'WALK') {
        pointList = splitPoint(
            leg.stepList.toString().replaceAll("[", "").replaceAll("]", ""));
      } else {
        pointList = splitPoint(
            leg.passShape.toString().replaceAll("[", "").replaceAll("]", ""));
      }

      if (leg.mode == 'WALK') {
        WalkingLngList walkingLngList = WalkingLngList([]);

        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          walkingLngList.path.add(LatLng(latPoint, longPoint));
        }
        route.add(walkingLngList);
      }

      else if (leg.mode == 'BUS') {
        BusLngList busLngList = BusLngList([]);

        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          busLngList.path.add(LatLng(latPoint, longPoint));
        }
        route.add(busLngList);
      }
      else if (leg.mode == 'TRAIN') {
        TrainLngList trainLngList = TrainLngList([]);

        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          trainLngList.path.add(LatLng(latPoint, longPoint));
        }
        route.add(trainLngList);
      }
      else if (leg.mode == 'SUBWAY') {
        SubwayLngList subwayLngList = SubwayLngList([]);

        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          subwayLngList.path.add(LatLng(latPoint, longPoint));
        }
        route.add(subwayLngList);
      }
      else if (leg.mode == 'EXPRESSBUS') {
        ExbusLngList exbusLngList = ExbusLngList([]);

        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          exbusLngList.path.add(LatLng(latPoint, longPoint));
        }
        route.add(exbusLngList);
      }
      else if (leg.mode == 'TRANSFER') {
        TransLngList transLngList = TransLngList([]);
        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          transLngList.path.add(LatLng(latPoint, longPoint));
        }
        route.add(transLngList);
      }
    }
    return route;
  }

  List<LatLng> getTransferList() {
    List<String> pointList = [];
    double latPoint;
    double longPoint;

    List<LatLng> startEnd = [];
    var count = 0;
    for (Leg leg in legs) {
      List<LatLng> transferList = [];
      if (leg.mode == 'TRANSFER') {
        pointList = splitPoint(
            leg.passShape.toString().replaceAll("[", "").replaceAll("]", ""));
        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          transferList.add(LatLng(latPoint, longPoint));
        }
        startEnd.add(transferList[0]);
        startEnd.add(transferList[transferList.length - 1]);
      } else if (leg.mode == 'WALK') {
        pointList = splitPoint(
            leg.stepList.toString().replaceAll("[", "").replaceAll("]", ""));
        for (String point in pointList) {
          latPoint = double.parse(point.split(',')[1]);
          longPoint = double.parse(point.split(',')[0]);

          transferList.add(LatLng(latPoint, longPoint));
        }
        if (count == 0) {
          startEnd.add(transferList[transferList.length - 1]);
          count++;
        } else {
          startEnd.add(transferList[0]);
        }
      } else {
        continue;
      }
    }
    return startEnd;
  }

  List<Color> getPassColorList() {
    List<Color> passColorList = [];
    for (Leg leg in legs) {
      if (leg.mode == 'WALK' || leg.mode == 'TRANSFER' || leg.routeColor == '') {
        passColorList.add(Color(0xA59E9E9E));
      }
      else if (leg.mode == 'BUS') {
        passColorList.add(Color(int.parse(leg.routeColor!, radix: 16) + 0xFF000000));
      }
      else if (leg.mode == 'TRAIN') {
        passColorList.add(Color(int.parse(leg.routeColor!, radix: 16) + 0xFF000000));
      }
      else if (leg.mode == 'SUBWAY') {
        passColorList.add(Color(int.parse(leg.routeColor!, radix: 16) + 0xFF000000));
      }
      else if (leg.mode == 'EXPRESSBUS') {
        passColorList.add(Color(int.parse(leg.routeColor!, radix: 16) + 0xFF000000));
      }
    }
    return passColorList;
  }
}