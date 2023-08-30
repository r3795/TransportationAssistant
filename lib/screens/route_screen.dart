import 'package:animations/animations.dart';
import 'package:fluter_tuto/screens/route_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../widgets/direction_screen_top.dart';
import '../models/model_stationInfo.dart';
import '../provider/provider_search_variable.dart';
import '../widgets/route_box.dart';
import 'package:animated_button_bar/animated_button_bar.dart';

//Itinerary객체를 위한 추가
import 'package:fluter_tuto/models/model_itinerary.dart';
import '../provider/provider_search_variable.dart';
import 'map_screen.dart';

class RouteScreen extends StatefulWidget {
  final List<Itinerary> itineraries;

  const RouteScreen({Key? key, required this.itineraries}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {

  String dropdownValue = '소요시간 순';
  String selectedRadioValue = '소요시간 순';

  void sortItineraries(String value, List<Itinerary> itineraries) {
    switch (value) {
      case '소요시간 순':
        itineraries.sort((a, b) => a.totalTime.compareTo(b.totalTime));
        break;
      case '도보거리 순':
        itineraries.sort((a, b) => a.totalWalkTime.compareTo(b.totalWalkTime));
        break;
      case '요금 순':
        itineraries.sort((a, b) => a.totalFare.compareTo(b.totalFare));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider =
        Provider.of<SearchProvider>(context, listen: false);

    List<Itinerary> sortedItineraries = List.from(widget.itineraries);

    sortItineraries(selectedRadioValue, sortedItineraries);

    List<List<StationInfo?>> itineraryTransTargetList = [];
    for (final itinerary in sortedItineraries) {
      List<StationInfo?> transTargetList = [];
      for (final leg in itinerary.legs) {
        if (leg.mode == "BUS" ||
            leg.mode == "SUBWAY" ||
            leg.mode == "EXPRESSBUS" ||
            leg.mode == "TRAIN") {
          // 경로에 최소 3개의 정류장이 있다면 마지막에서 2번째가 환승 타겟 리스트에 들어간다
          if (leg.stationList != null && leg.stationList!.length >= 3) {
            // print("Transtarget");
            transTargetList.add(leg.stationList![leg.stationList!.length - 2]);
            // print(leg.stationList?[leg.stationList!.length - 2]);
          }
          //경로에 정류장이 (2개,출발지는 강제포함 사실상 1개)밖에 없다면 그 정류장이 환승 타겟 리스트에 들어간다.
          else {
            if (leg.stationList!.length == 2) {
              //실제 환승지점을 환승 타겟 리스트(1정거장 전이 아님)
              // print("Transtarget");
              transTargetList
                  .add(leg.stationList![leg.stationList!.length - 1]);
              // print(leg.stationList?[leg.stationList!.length - 1]);
              // print("Only one station in leg.stationList last");
            } else {
              print(
                  "Unable to access the second-to-last value in leg.stationList.");
            }
          }
        }
      }
      //환승 타겟 리스트에 목적지 강제로 추가하기
      final destinationInfo = StationInfo(
          index: 999,
          lat: itinerary.endY.toString(),
          lon: itinerary.endX.toString(),
          stationID: "null",
          stationName: "Destination");
      transTargetList.add(destinationInfo);
      print("TranstargetList");
      transTargetList.forEach((station) {
        print(station.toString());
      });
      itineraryTransTargetList.add(transTargetList);
    }
    for (final element in itineraryTransTargetList) {
      print("Itinerary Trans");
      for (final elem in element) {
        print(elem.toString());
      }
    }

    return WillPopScope(
      onWillPop: () async {
        //초기화 시키기
        searchProvider.setSourceUpdatePlace("source");
        searchProvider.setDestinationUpdatePlace("destination");
        searchProvider.setSourceSelected(false);
        searchProvider.setDestinationSelected(false);

        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        body: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          // Set overscroll to false
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(       //윗부분을 길찾기 버튼으로 변경
                  alignment: Alignment.center,
                  child: DirectionTop(), // Replace the child widget with DirectionTop
                ),
                Container(
                    width: double.infinity, // Set the width to occupy the full available width
                    height: 50.0, // Set the desired height
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    AnimatedButtonBar(
                      radius: 8.0,
                      invertedSelection: true,
                      borderColor: Colors.grey.shade300,
                      borderWidth: 2,
                      backgroundColor: Colors.white70,
                      foregroundColor: Colors.blueGrey.shade200,
                      children: [
                        ButtonBarEntry(
                          onTap: () {
                            setState(() {
                              selectedRadioValue = '소요시간 순';
                              sortItineraries(selectedRadioValue, sortedItineraries);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.alarm),
                              SizedBox(width: 2), // Add some spacing between the icon and the text
                              Text('소요시간 순', style: TextStyle(
                                fontWeight: FontWeight.bold, // Change the font weight to bold
                                color: Colors.black, // Change the text color to red
                              )),
                            ],
                          ),
                        ),
                        ButtonBarEntry(
                          onTap: () {
                            setState(() {
                              selectedRadioValue = '도보거리 순';
                              sortItineraries(selectedRadioValue, sortedItineraries);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_walk),
                              SizedBox(width: 2), // Add some spacing between the icon and the text
                              Text('도보거리 순', style: TextStyle(
                                fontWeight: FontWeight.bold, // Change the font weight to bold
                                color: Colors.black, // Change the text color to red
                              )),
                            ],
                          ),
                        ),
                        ButtonBarEntry(
                          onTap: () {
                            setState(() {
                              selectedRadioValue = '요금 순';
                              sortItineraries(selectedRadioValue, sortedItineraries);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.attach_money),
                              SizedBox(width: 2), // Add some spacing between the icon and the text
                              Text('요금 순', style: TextStyle(
                                fontWeight: FontWeight.bold, // Change the font weight to bold
                                color: Colors.black, // Change the text color to red
                              )),
                            ],
                          ),
                        ),
                    ],
                  ),
                ]),
                //     child: Row(//라디오버튼 구현
                //       children: <Widget>[
                //       Radio<String>(
                //         value: '소요시간 순',
                //         groupValue: selectedRadioValue,
                //         onChanged: (value) {
                //           setState(() {
                //             selectedRadioValue = value!;
                //             sortItineraries(selectedRadioValue, sortedItineraries);
                //           });
                //         },
                //       ),
                //       Text('소요시간 순'),
                //       Radio<String>(
                //         value: '도보거리 순',
                //         groupValue: selectedRadioValue,
                //         onChanged: (value) {
                //           setState(() {
                //             selectedRadioValue = value!;
                //             sortItineraries(selectedRadioValue, sortedItineraries);
                //           });
                //         },
                //       ),
                //       Text('도보거리 순'),
                //       Radio<String>(
                //         value: '요금 순',
                //         groupValue: selectedRadioValue,
                //         onChanged: (value) {
                //           setState(() {
                //             selectedRadioValue = value!;
                //             sortItineraries(selectedRadioValue, sortedItineraries);
                //           });
                //         },
                //       ),
                //       Text('요금 순'),
                //   ],
                // ),
            ),
                // ...List.generate(sortedItineraries.length, (index) {
                //   return OpenContainer(
                //     closedBuilder: (_, openContainer) {
                //       return InkWell(
                //         onTap: openContainer,
                //         child: buildRouteBox(sortedItineraries[index]),
                //       );
                //     },
                //     openBuilder: (_, closeContainer) {
                //       return RouteDetailScreen(
                //           itinerary: sortedItineraries[index],
                //           transTargetList: itineraryTransTargetList[index]);
                //     },
                //   );
                // }),
                ...List.generate(sortedItineraries.length, (index) {
                  return OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough, // 애니메이션 타입 설정
                    transitionDuration: Duration(milliseconds: 950), // 애니메이션 지속 시간을 2초로 설정
                    closedBuilder: (_, openContainer) {
                      return InkWell(
                        onTap: openContainer,
                        child: buildRouteBox(sortedItineraries[index]),
                      );
                    },
                    openBuilder: (_, closeContainer) {
                      return RouteDetailScreen(
                        itinerary: sortedItineraries[index],
                        transTargetList: itineraryTransTargetList[index],
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


