import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lost_item_screen.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen>
    with WidgetsBindingObserver {
  List<BusStation> _busStations = [];
  List<BusStation3> _busStations3 = [];
  String _keyword = '';
  String _routeId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_routeId.isNotEmpty) {
        setState(() {
          _routeId = '';
        });
      }
    }
  }

  Future<void> _fetchBusStationData() async {
    final url = Uri.parse(
        'https://apis.data.go.kr/6410000/busrouteservice/getBusRouteList?serviceKey=w2Ey6KRxEn3sbFQolnJVyHfUgJaK1dVY2r5UXf9IjjhJEvRjegN5i62jgZHT%2FGf8HR7OoWgb4wTMXWhxlkGUCg%3D%3D&keyword=$_keyword');
    final response = await http.get(url);
    final body = response.body;
    final document = XmlDocument.parse(body);

    final busStationList = document.findAllElements('busRouteList');
    final busStations = busStationList.map((node) {
      return BusStation(
          districtCd: node.findElements('districtCd').single.text,
          regionName: node.findElements('regionName').single.text,
          routeId: node.findElements('routeId').single.text,
          routeName: node.findElements('routeName').single.text,
          routeTypeCd: node.findElements('routeTypeCd').single.text,
          routeTypeName: node.findElements('routeTypeName').single.text);
    }).toList();

    // Sort the busStations list in ascending order by routeName
    busStations.sort((a, b) => a.routeName.compareTo(b.routeName));

    // Filter the list to only include buses that match the exact number
    // or those that start with the number followed by a hyphen
    final filteredBusStations = busStations.where((busStation) {
      return busStation.routeName == _keyword ||
          busStation.routeName.startsWith('$_keyword-');
    }).toList();

    setState(() {
      _busStations = filteredBusStations;
    });
  }
  Future<void> _fetchBusStationData2() async {
    final url = Uri.parse(
        'https://apis.data.go.kr/6410000/busrouteservice/getBusRouteInfoItem?serviceKey=w2Ey6KRxEn3sbFQolnJVyHfUgJaK1dVY2r5UXf9IjjhJEvRjegN5i62jgZHT%2FGf8HR7OoWgb4wTMXWhxlkGUCg%3D%3D&routeId=$_routeId');
    final response = await http.get(url);
    final body = response.body;
    final document = XmlDocument.parse(body);

    final busStationList = document.findAllElements('busRouteInfoItem');
    final busStations3 = busStationList.map((node) {
      return BusStation3(

          downFirstTime: node.findElements('downFirstTime').single.text,
          downLastTime: node.findElements('downLastTime').single.text,
          peekAlloc: node.findElements('peekAlloc').single.text,
          upFirstTime: node.findElements('upFirstTime').single.text,
          upLastTime: node.findElements('upLastTime').single.text,
          nPeekAlloc: node.findElements('nPeekAlloc').single.text,
          routeName: node.findElements('routeName').single.text,
          regionName: node.findElements('regionName').single.text,
          companyName: node.findElements('companyName').single.text);
    }).toList();

    setState(() {
      _busStations3 = busStations3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              // Set border color
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              // Set the focus color
              focusColor: Colors.black,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '버스 번호를 입력하세요 ',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _fetchBusStationData,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _keyword = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _routeId.isEmpty
                      ? _busStations.length
                      : _busStations3.length,
                  itemBuilder: (context, index) {
                    if (_routeId.isEmpty) {
                      final busStation = _busStations[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.directions_bus,
                              color: getColorForRouteType(
                                  _busStations[index].routeTypeName),size: 40,),
                            title: Text(''),
                            subtitle: Column(
                              children: [
                                Text(
                                  busStation.routeName,
                                  style: TextStyle(
                                    fontSize: 24.0, // Adjust the font size as needed
                                    color: Colors.red, // Replace with your desired color
                                  ),
                                ),
                                Text(busStation.regionName),
                                Text(busStation.routeTypeName),
                              ],
                            ),
                            onTap: () async {
                              _routeId = busStation.routeId;
                              await _fetchBusStationData2();
                              if (_busStations3.isNotEmpty) {
                                await Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                        FadeThroughTransition(
                                          animation: animation,
                                          secondaryAnimation: secondaryAnimation,
                                          child: BusDetailsScreen2(
                                              busStation: _busStations3[0]),
                                        ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return Transform.scale(
                                        scale: animation.value,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                                // Reset _routeId to empty after navigation
                                setState(() {
                                  _routeId = '';
                                });
                              }
                            },
                          ),
                          Divider(
                            thickness: 3,
                          ), // This will create a line
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BusDetailsScreen2 extends StatelessWidget {
  final BusStation3 busStation;

  BusDetailsScreen2({required this.busStation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.outlined_flag, color: Colors.blue, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      '기점',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      busStation.upFirstTime,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_off, color: Colors.green, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      busStation.upLastTime,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.flag, color: Colors.red, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      '종점',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      busStation.downFirstTime,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.location_off, color: Colors.green, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      busStation.downLastTime,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.schedule, color: Colors.teal, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      '${busStation.peekAlloc}분 ~ ${busStation.nPeekAlloc}분',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 3),
                busStation.regionName.contains('이천')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.icheon.go.kr/depart/selectBbsNttList.do?bbsNo=150&key=2192');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '이천버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('수원')
                    ? GestureDetector(
                  onTap: () {
                    launch('http://its.suwon.go.kr/_lmth/03_businfo/bus_0101.jsp');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '수원버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('성남')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.seongnam.go.kr/city/1000357/11447/contents.do');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '성남버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('구리')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.guri.go.kr/www/contents.do?key=710');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '구리버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('광명')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.gm.go.kr/pt/user/bbs/BD_selectBbsList.do?q_bbsCode=2177');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '광명버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('과천')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.gccity.go.kr/dept/contents.do?mId=0404070000');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '과천버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('고양')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.goyang.go.kr/www/www03/www03_5/www03_5_4/www03_5_4_tab1.jsp');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '고양버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('용인')
                    ? GestureDetector(
                  onTap: () {
                    launch('http://knyongintr.co.kr/board/bus_city.html');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '용인버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('화성')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.hsuco.or.kr/user/bbs/BD_selectBbsList.do?q_bbsCode=1041');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '화성버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('여주')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.yeoju.go.kr/www/jsp/project/traffic/bus.jsp');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '여주버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('평택')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.pyeongtaek.go.kr/pyeongtaek/bbs/list.do?ptIdx=57&mId=1101000000');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '평택버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('가평')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.gp.go.kr/portal/contents.do?key=2172');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '가평버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('양평')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.yp21.go.kr/www/contents.do?key=1500');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '양평버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('광주')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.gjcity.go.kr/depart/bbs/list.do?ptIdx=174&mId=0402010000&token=1682952161607');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '광주버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
                busStation.regionName.contains('시흥')
                    ? GestureDetector(
                  onTap: () {
                    launch('https://www.siheung.go.kr/portal/contents.do?mId=0511060000');
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: [
                        Text(
                          '시흥버스시간표',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        Divider(thickness: 3),
                      ],
                    ),
                  ),
                )
                    : Container(),
              ],
            ),
          ),

        ),
      ),
    );
  }
}

Color getColorForRouteType(String routeTypeName) {
  switch (routeTypeName) {
    case '일반형시내버스':
      return Colors.green;
    case '직행좌석형시외버스':
      return Colors.red;
    case '일반형농어촌버스':
      return Colors.yellow;
    case '직행좌석형시내버스':
      return Colors.blue;
    default:
      return Colors.black;
  }
}

class BusStation {
  final String districtCd;
  final String regionName;
  final String routeId;
  final String routeName;
  final String routeTypeCd;
  final String routeTypeName;

  BusStation({
    required this.districtCd,
    required this.regionName,
    required this.routeId,
    required this.routeName,
    required this.routeTypeCd,
    required this.routeTypeName,
  });
}

class BusStation3 {
  final String downFirstTime;
  final String downLastTime;
  final String peekAlloc;
  final String upFirstTime;
  final String upLastTime;
  final String nPeekAlloc;
  final String routeName;
  final String regionName;
  final String companyName;

  BusStation3({
    required this.downFirstTime,
    required this.downLastTime,
    required this.peekAlloc,
    required this.upFirstTime,
    required this.upLastTime,
    required this.nPeekAlloc,
    required this.routeName,
    required this.regionName,
    required this.companyName,
  });
}