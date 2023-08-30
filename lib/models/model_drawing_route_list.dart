import 'package:kakao_map_plugin/kakao_map_plugin.dart';

abstract class RouteSegment {
  List<LatLng> path;
  RouteSegment(this.path);
}

// 도보
class WalkingLngList extends RouteSegment {
  WalkingLngList(List<LatLng> path) : super(path);
}

// 버스
class BusLngList extends RouteSegment {
  BusLngList(List<LatLng> path) : super(path);
}

// 지하철
class SubwayLngList extends RouteSegment {
  SubwayLngList(List<LatLng> path) : super(path);
}

// 기차
class TrainLngList extends RouteSegment {
  TrainLngList(List<LatLng> path) : super(path);
}

// 고속버스
class ExbusLngList extends RouteSegment {
  ExbusLngList(List<LatLng> path) : super(path);
}

// 환승경로
class TransLngList extends RouteSegment {
  TransLngList(List<LatLng> path) : super(path);
}

