import 'model_start.dart';
import 'model_end.dart';
import 'model_stationInfo.dart';
import 'model_step.dart';
class Leg {
  @override
  String toString() {
    // TODO: implement toString
    String stationListString = stationList?.map((s) => s.toString())?.join('\n\t') ?? '';
    //step을 1,2,3으로 보기 좋게 출력하기 위해서
    String stepListString = stepList?.asMap()?.entries?.map((entry) => 'STEP ${entry.key + 1}: ${entry.value.toString()}')?.join('\n') ?? '';
    // String stepListString = stepList?.map((s) => s.toString())?.join('\n\t') ?? '';
    // 이거는 StationList가 null일 때는 출력 안하게 한 코드
    // return 'Leg{출발지: $start, 도착지: $end, 이동수단: $mode, 노선: $route, 노선 color : $routeColor 이동 시간: $sectionTime'+(stationListString.isNotEmpty ? ', Station list: [\n\t$stationListString\n]' : '');
    //passShape 제외한 출력
    // return 'Leg{From: $start, To: $end, Transportation: $mode, Route: $route, Route color: $routeColor, Travel time: $sectionTime, Station list: [\n\t$stationListString\n], Step List :[\n\t$stepListString\n] }';
    // 주석에서 긴 것들 지움(passShape, StationList, step)
    // return 'Leg{From: $start, To: $end, Transportation: $mode, Route: $route, Route color: $routeColor, Travel time: $sectionTime}';
    return 'Leg{From: $start, To: $end, Transportation: $mode, Route: $route, Route color: $routeColor, Travel time: $sectionTime, passShape: $passShape, Station list: [\n\t$stationListString\n], Step List :[\n\t$stepListString\n] }';
  }
  //n개의 이동에서의 출발지
  final Start start;
  //n번의 이동에서의 도착지
  final End end;
  //WALK,BUS,TRAIN 등등 이동 수단
  final String mode;
  //버스라면 버스 노선 번호, SUBWAY라면 수도권 1호선 이런 식..
  final String? route;
  //각 이동 간에 걸린 시간
  final int sectionTime;
  //각 이동 간에 이동 거리
  final int distance;
  final String? routeColor;
  //버스,지하철,좌석버스등의 이동 경로 마크를 찍기 위한 String
  final String? passShape;
  //도보 이동 경로 마크를 찍기 위한 String
  final List<Step>? stepList;
  final List<StationInfo>? stationList;

  const Leg({
    required this.start,
    required this.end,
    required this.mode,
    this.route,
    this.routeColor,
    required this.sectionTime,
    required this.distance,
    this.stationList,
    this.passShape,
    this.stepList

  });

  factory Leg.fromJson(Map<String,dynamic> json){
    final Map<String, dynamic> startData = json['start'];
    final Map<String, dynamic> endData = json['end'];
    String? passShape="";
    //담을 리스트 선언
    List<StationInfo>? stationList = [] ;
    List<Step>? stepList = [];
    //도보일 때는 Steps가 존재한다.
    if(json['mode'] == 'WALK'){
      for(final step in json['steps']){
        final stepInfo = Step(
          linestring:step['linestring']
        );
        stepList.add(stepInfo);
      }
    }
    //버스,TRAIN,지하철일 때는 정류장 정보들이 존재
    if (json['mode'] == 'TRAIN' || json['mode'] == 'BUS' || json['mode']=='SUBWAY' || json['mode']=='EXPRESSBUS') {
      //  getStationInfoElement는 그냥 api에서 get한 정류장 정보를 담은 것임
      passShape= json['passShape']['linestring'];
      for(final getStationInfoElement in json['passStopList']['stationList']){
        final stationInfo = StationInfo(
            index:getStationInfoElement['index'],
            stationName:getStationInfoElement['stationName'],
            lon:getStationInfoElement['lon'],
            lat:getStationInfoElement['lat'],
            stationID:getStationInfoElement['stationID']
        );
        stationList.add(stationInfo);
      }
    }

    if (json['mode']=='TRANSFER') {
      passShape= json['passShape']['linestring'];
    }

    return Leg(
        start: Start(
          name: startData['name'],
          lon: startData['lon'],
          lat: startData['lat'],
        ),
        end: End(
          name: endData['name'],
          lon: endData['lon'],
          lat: endData['lat'],
        ),
        mode: json['mode']??'',
        route : json['route']??'',
        sectionTime: json['sectionTime']??0,
        distance: json['distance']??'',
        routeColor: json['routeColor']??'',
        stationList: stationList??[],
        passShape: passShape??'',
        stepList: stepList??[]
    );
  }
}