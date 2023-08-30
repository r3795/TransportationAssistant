import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:animations/animations.dart';

class LostItemScreen extends StatefulWidget {
  const LostItemScreen({Key? key}) : super(key: key);

  // final String title;

  @override
  State<LostItemScreen> createState() => _LostItemScreenState();
}

class _LostItemScreenState extends State<LostItemScreen>
    with WidgetsBindingObserver {
  List<BusStation> _busStations = [];
  List<BusStation2> _busStations2 = [];
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
    final busStations2 = busStationList.map((node) {
      return BusStation2(
          companyId: node.findElements('companyId').single.text,
          companyName: node.findElements('companyName').single.text,
          companyTel: node.findElements('companyTel').single.text,
          districtCd: node.findElements('districtCd').single.text,
          startStationName: node.findElements('startStationName').single.text,
          endStationName: node.findElements('endStationName').single.text,
          routeName: node.findElements('routeName').single.text);
    }).toList();

    setState(() {
      _busStations2 = busStations2;
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
                      : _busStations2.length,
                  itemBuilder: (context, index) {
                    if (_routeId.isEmpty) {
                      final busStation = _busStations[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.directions_bus,
                              color: getColorForRouteType(
                                  _busStations[index].routeTypeName),
                              size: 40,
                            ),
                            title: Text(''),
                            subtitle: Column(
                              children: [
                                Text(
                                  busStation.routeName,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    // Adjust the font size as needed
                                    color: Colors
                                        .red, // Replace with your desired color
                                  ),
                                ),
                                Text(busStation.regionName),
                                Text(busStation.routeTypeName),
                              ],
                            ),
                            onTap: () async {
                              _routeId = busStation.routeId;
                              await _fetchBusStationData2();
                              if (_busStations2.isNotEmpty) {
                                await Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                        FadeThroughTransition(
                                          animation: animation,
                                          secondaryAnimation: secondaryAnimation,
                                          child: BusDetailsScreen(
                                              busStation: _busStations2[0]),
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

class BusDetailsScreen extends StatelessWidget {
  final BusStation2 busStation;

  BusDetailsScreen({required this.busStation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      busStation.startStationName,
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
                      busStation.endStationName,
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
                    Icon(Icons.business, color: Colors.purple, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      busStation.companyName,
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
                    Icon(Icons.phone, color: Colors.teal, size: 50),
                    SizedBox(width: 8.0),
                    Text(
                      busStation.companyTel,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
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

class BusStation2 {
  final String companyId;
  final String companyName;
  final String companyTel;
  final String districtCd;
  final String routeName;
  final String startStationName;
  final String endStationName;

  BusStation2({
    required this.companyId,
    required this.companyName,
    required this.companyTel,
    required this.districtCd,
    required this.routeName,
    required this.startStationName,
    required this.endStationName,
  });
}