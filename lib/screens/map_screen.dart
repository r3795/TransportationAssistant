import 'package:fluter_tuto/models/model_itinerary.dart';
import 'package:fluter_tuto/widgets/map_screen_default.dart';
import 'package:fluter_tuto/widgets/map_screen_kakao.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

import '../provider/provider_itinerary.dart';
import '../provider/provider_search_variable.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  @override
  Widget build(BuildContext context) {
    final alarmItineraryProvider = Provider.of<AlarmItineraryProvider>(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    bool hasRequest = false;
    String start = '설정된 알람이 ';
    String end = '없습니다.';

    Itinerary itinerary = alarmItineraryProvider.itinerary;
    hasRequest = alarmItineraryProvider.hasRequestTest;

    if (alarmItineraryProvider.hasRequestTest) {
      start = searchProvider.alarmSourcePlaceName;
      end = searchProvider.alarmDestinationPlaceName;
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: hasRequest
                  ? MapKakaoGen(
                      alarmItinerary: itinerary) //위젯폴더 안에 map_screen_kakao에 구현
                  : MapKakaoDefault()),
          hasRequest
              ? Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Text(
                      '$start → $end',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Text(
                      '설정된 알람이 없습니다...',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
