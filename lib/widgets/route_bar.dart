import 'dart:math';
import 'package:timelines/timelines.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildFlexibleContainers(
    List<int> sectionTimes,
    List<Color> colors,
    List<String> modes,
    ) {
  assert(sectionTimes.length == colors.length);

  final List<Widget> containers = [];

  List<int> flexTimes;

  for (int i = 0; i < sectionTimes.length; i++) {
    Widget icon;
    switch (modes[i]) {
      case 'WALK':
      case 'TRANSFER':
        icon = const Icon(
          Icons.directions_walk,
          color: Colors.white,
          size: 18,
        );
        break;
      case 'BUS':
        icon = const Icon(
          Icons.directions_bus,
          color: Colors.white,
          size: 18,
        );
        break;
      case 'SUBWAY':
        icon = const Icon(
          Icons.subway_outlined,
          color: Colors.white,
          size: 18,
        );
        break;
      case 'TRAIN':
        icon = const Icon(
          Icons.train,
          color: Colors.white,
          size: 18,
        );
        break;
      case 'AIRPLANE':
        icon = const Icon(
          Icons.airplanemode_active_outlined,
          color: Colors.white,
          size: 18,
        );
        break;
      default:
        icon = const SizedBox();
        break;
    }

    List<int> scaleSumToThousand(List<int> sectionTimes) {
      // Calculate the total sum of the array
      int totalSum = sectionTimes.reduce((a, b) => a + b);

      // Create a new list to store the scaled values
      List<int> scaledSectionTimes = List<int>.filled(sectionTimes.length, 0);

      // Calculate the scaled values
      for (int i = 0; i < sectionTimes.length; i++) {
        double scaledValue = sectionTimes[i] / totalSum * 1000;
        scaledSectionTimes[i] = scaledValue.round();
      }

      // Check if rounding errors have caused the sum to not equal 1000
      int sumDifference = 1000 - scaledSectionTimes.reduce((a, b) => a + b);

      // If the sum is not equal to 1000, adjust the largest value to make the sum equal to 1000
      if (sumDifference != 0) {
        int maxIndex = scaledSectionTimes.indexWhere((value) => value == scaledSectionTimes.reduce(max));
        scaledSectionTimes[maxIndex] += sumDifference;
      }

      return scaledSectionTimes;
    }

    flexTimes = scaleSumToThousand(sectionTimes);

    containers.add(

      Flexible(
        flex: modes[i] == 'WALK' || modes[i] == 'TRANSFER' ? sectionTimes[i]~/ 60 > 1 ? min(20,max(10,flexTimes[i])) : 1 : min(40,max(100,flexTimes[i])),
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 50,maxWidth: 260),
              decoration: BoxDecoration(
                color: colors[i],
                borderRadius: BorderRadius.circular(0),
              ),
              child: Center(
                child: Text(
                    (sectionTimes[i] ~/ 60) > 60
                        ? '${(sectionTimes[i] ~/ 60) ~/ 60} 시간 ${((sectionTimes[i] ~/ 60) % 60)} 분'
                        : '${sectionTimes[i] ~/ 60} 분',
                  style : TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
            ),
            if (colors[i] != Colors.transparent)
              Positioned(
                left: -5,
                top: (20 - 28) / 2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Center(child: icon),
                ),
              ),
          ],
        ),
      ),
    );
  }

  return ClipRect(
    child: SizedBox(
      width: 400,
      height: 20,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: containers,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
