import 'package:fluter_tuto/provider/provider_my_location.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import '../models/model_drawing_route_list.dart';
import '../models/model_itinerary.dart';

class MapKakaoGen extends StatefulWidget {
  final Itinerary alarmItinerary;

  const MapKakaoGen({Key? key, required this.alarmItinerary}) : super(key: key);

  @override
  State<MapKakaoGen> createState() => _MapKakaoGenState();
}

class _MapKakaoGenState extends State<MapKakaoGen> {
  late KakaoMapController mapController;
  late Itinerary alarmItinerary;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    alarmItinerary = widget.alarmItinerary; // 생성자에서 값을 할당
  }

  @override
  Widget build(BuildContext context) {
    List<RouteSegment> totalPath = alarmItinerary.getLngList();
    List<LatLng> transferList = alarmItinerary.getTransferList();
    LatLng startLocation = LatLng(alarmItinerary.startY, alarmItinerary.startX);
    LatLng endLocation = LatLng(alarmItinerary.endY, alarmItinerary.endX);
    List<Color> passColor = alarmItinerary.getPassColorList();

    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
      if (locationProvider.currentPosition != null) {
        // Use the locationProvider to get the current position
        var currentPosition = locationProvider.currentPosition;
        LatLng currentLocation =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);

        // Remove the old marker
        markers.removeWhere((marker) => marker.markerId == 'currentLocation');

        // Add the new marker
        markers.add(Marker(
            markerId: 'currentLocation',
            latLng: currentLocation,
            width: 25,
            height: 25,
            markerImageSrc: 'https://ifh.cc/g/Xx7ZPo.png'));

        return Scaffold(
          body: Stack(
            children: [
              KakaoMap(
                onMapCreated: ((controller) async {
                  mapController = controller;
                  var num = 0;
                  for (var segment in totalPath) {
                    Color color; // 선의 색상을 지정할 변수
                    color = passColor[num++];
                    // Polyline 추가
                    polylines.add(
                      Polyline(
                        polylineId: 'polyline_${polylines.length}',
                        points: segment.path, // segment에 따른 경로
                        strokeColor: color, // 선의 색상
                        strokeWidth: 4,
                      ),
                    );
                  }

                  // 출발지 마커
                  markers.add(Marker(
                    markerId: markers.length.toString(),
                    latLng: startLocation,
                    width: 44,
                    height: 44,
                    offsetX: 20,
                    offsetY: 44,
                    markerImageSrc: 'https://ifh.cc/g/WTLBmp.png',
                  ));

                  // 탑승지, 환승지, 하차지 마커
                  for (LatLng point in transferList) {
                    markers.add(Marker(
                      markerId: markers.length.toString(),
                      latLng: point,
                      width: 44,
                      height: 44,
                      offsetX: 20,
                      offsetY: 44,
                      markerImageSrc: 'https://ifh.cc/g/mM3aYk.png',
                    ));
                  }

                  // 도착지 마커
                  markers.add(Marker(
                    markerId: markers.length.toString(),
                    latLng: endLocation,
                    width: 44,
                    height: 44,
                    offsetX: 20,
                    offsetY: 44,
                    markerImageSrc: 'https://ifh.cc/g/6V3qwx.png',
                  ));

                  setState(() {});
                }),
                polylines: polylines.toList(),
                markers: markers.toList(),
                center: startLocation,
              ),
            ],
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: 20, right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // FloatingActionButton(
                //   onPressed: () =>
                //       mapController.setCenter(startLocation), // 북쪽 버튼
                //   heroTag: null,
                //   backgroundColor: Color(0xFF3F4250),
                //   child: Icon(Icons.navigation),
                // ),
                // SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () => mapController.setCenter(currentLocation),
                  //현재 위치
                  heroTag: null,
                  backgroundColor: Color(0xFF3F4250),
                  child: Icon(
                    Icons.my_location_sharp,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return CircularProgressIndicator();
      }
    });
  }
}
