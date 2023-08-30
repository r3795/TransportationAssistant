import 'package:flutter/material.dart';
import '../models/model_itinerary.dart';
import '../models/model_leg.dart';
import 'route_bar.dart';
import 'package:fluter_tuto/widgets/route_line.dart';


// Widget buildRouteBox( //기존 루트박스
//   // 경로 박스 하나에 대한 위젯입니당 즉 하나의 itinerarity 인스턴스만 다루겠죵?
//   Itinerary itinerary,
//
// ) {
//   var totalFare = itinerary.totalFare;
//   var totalTime = itinerary.totalTime;
//   var totalWalkTime = itinerary.totalWalkTime;
//   List<Leg> legs = itinerary.legs;
//   List<int> sectionTimes = legs.map((leg) => leg.sectionTime).toList();
//   List<String?> routeColors = legs.map((leg) => leg.routeColor).toList();
//   List<String> modes = legs.map((leg) => leg.mode).toList();
//   List<String?> routes = legs.map((leg) => leg.route).toList();//간선:151, 수도권 4호선 등등
//
//   List<Color> colors = routeColors.map((colorString) {
//     if (colorString == '') {
//       return Colors.transparent;
//     } else {
//       return Color(int.parse(colorString!, radix: 16) + 0xFF000000);
//     }
//   }).toList();
//
//   return Container(
//     margin: EdgeInsets.symmetric(vertical: 3),
//     decoration: BoxDecoration(
//       color: Colors.white,
//     ),
//     child:Container(
//     // margin: const EdgeInsets.all(2),
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       color: Color(0xFFE9ECEF),
//       border: Border.all(color: Color(0xFFE9ECEF), width: 2.0),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Align(
//           alignment: Alignment(-1.00, -0.70), // Adjust the alignment values as needed
//           child: Text(
//             (totalTime ~/ 60) > 60
//                 ? '${(totalTime ~/ 60) ~/ 60} 시간 ${((totalTime ~/ 60) % 60)} 분'
//                 : '${totalTime ~/ 60} 분',
//             style: const TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10,),
//         Row(
//           children: [
//             Container(
//               margin: EdgeInsets.only(left: 1.0),
//               padding: EdgeInsets.all(4.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.white, // Change color to white
//                 border: Border.all( // Add black border
//                   color: Colors.black,
//                   width: 1.0,
//                 ),
//               ),
//               child: Text(
//                 '요금 : $totalFare 원 ',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   color: Colors.black, // Change color to black
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//
//             Container(
//               margin: EdgeInsets.only(left: 10.0),
//               padding: EdgeInsets.all(4.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.white, // Change color to white
//                 border: Border.all( // Add black border
//                   color: Colors.black,
//                   width: 1.0,
//                 ),
//               ),
//               child: Text(
//                 '도보거리 : ${totalWalkTime ~/ 60} 분',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   color: Colors.black, // Change color to black
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10,),
//         buildFlexibleContainers(sectionTimes, colors, modes),
//         const SizedBox(height: 20),
//         Container(
//           height: 1,
//           color: const Color(0x9F9F9FFF),
//         ),
//         buildRouteLine(legs,colors),
//       ],
//     ),
//   ),
//   );
// }
Widget buildRouteBox(
    // What do you think about your itinerarity?
    Itinerary itinerary,
    ) {
  var totalFare = itinerary.totalFare;
  var totalTime = itinerary.totalTime;
  var totalWalkTime = itinerary.totalWalkTime;
  List<Leg> legs = itinerary.legs;
  List<int> sectionTimes = legs.map((leg) => leg.sectionTime).toList();
  List<String?> routeColors = legs.map((legs) => legs.routeColor).toList();
  List<String> modes = legs.map((leg) => leg.mode).toList();
  List<String?> routes = legs.map((leg) => leg.route).toList();

  List<Color> colors = routeColors.map((colorString) {
    if (colorString == '') {
      return Colors.transparent;
    } else {
      return Color(int.parse(colorString!, radix: 16) + 0xFF000000);
    }
  }).toList();

  return Container(
    color: Color(0xFFE9ECEF), // Set the color of the outer container
    child: Container(
      margin: EdgeInsets.only(top: 2,bottom: 8), // Add margin to create space
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.grey, width: 2.0),
        // borderRadius: BorderRadius.circular(10),
      ),
      child: buildRouteBoxContent(totalFare, totalTime, totalWalkTime, sectionTimes, colors, modes, legs),
    ),
  );
}

Widget buildRouteBoxContent(
    int totalFare,
    int totalTime,
    int totalWalkTime,
    List<int> sectionTimes,
    List<Color> colors,
    List<String> modes,
    List<Leg> legs,
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Align(
        alignment: Alignment(-0.90, -0.70), // Adjust the alignment values ​​as needed
        child: Text(
          (totalTime ~/ 60) > 60
              ? '${(totalTime ~/ 60) ~/ 60} 시간 ${((totalTime ~/ 60) % 60)} 분'
              : '${totalTime ~/ 60} 분',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Container(
            margin: EdgeInsets.only( left: 10.0),
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Text(
              '요금 : $totalFare 원 ',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 5.0),
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: Text(
              '도보거리 : ${totalWalkTime ~/ 60} 분',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      // buildFlexibleContainers(sectionTimes, colors, modes),
      Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: buildFlexibleContainers(sectionTimes, colors, modes),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        height: 1,
        color: const Color(0x9F9F9FFF),
      ),
      //buildRouteLine(legs, colors),
      Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: buildRouteLine(legs, colors),
          ),
        ),
      ),
    ],
  );
}