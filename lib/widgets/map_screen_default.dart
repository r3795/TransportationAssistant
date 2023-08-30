import 'package:fluter_tuto/provider/provider_my_location.dart';
import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

class MapKakaoDefault extends StatefulWidget {
  const MapKakaoDefault({Key? key}) : super(key: key);

  @override
  State<MapKakaoDefault> createState() => _MapKakaoDefault();
}

class _MapKakaoDefault extends State<MapKakaoDefault> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          // Check if currentPosition is not null
          if (locationProvider.currentPosition != null) {
            // Use the locationProvider to get the current position
            var currentPosition = locationProvider.currentPosition;
            LatLng currentLocation =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);

            // Remove the old marker
            markers.removeWhere((marker) =>
            marker.markerId == 'currentLocation');

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
                      setState(() {});
                    }),
                    markers: markers.toList(),
                    center: currentLocation,
                  ),
                ],
              ),
              floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 20, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
            // Return a temporary widget (e.g. a loading spinner) while waiting for the position to be initialized
            return CircularProgressIndicator();
          }
        });

  }
}
