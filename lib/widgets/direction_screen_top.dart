import 'package:fluter_tuto/screens/location_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import '../provider/provider_search_variable.dart';

class DirectionTop extends StatefulWidget {
  const DirectionTop({Key? key}) : super(key: key);

  @override
  State<DirectionTop> createState() => _DirectionTopState();
}

class _DirectionTopState extends State<DirectionTop> {
  late SearchProvider searchProvider;
  late String sourceText;
  late String destinationText;

  //출발지와 목적지 둘 다 선택되었을 때 api 호출을 해야 한다
  bool isSourceSelected=false;
  bool isDestinationSelected=false;

  double sourceX = 0.0;
  double sourceY = 0.0;

  double destinationX = 0.0;
  double destinationY = 0.0;



  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    //sourceText,destinationText  등등이 항상 provider의 변수 값이랑 같게 최신화(빌드시에 넣어서)
    String sourceText = Provider.of<SearchProvider>(context).sourcePlaceName;
    String destinationText = Provider.of<SearchProvider>(context).destinationPlaceName;
    bool isSourceSelected = Provider.of<SearchProvider>(context).isSourceSelected;
    bool isDestinationSelected = Provider.of<SearchProvider>(context).isDestinationSelected;
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          width: MediaQuery.of(context).size.width - 8,

          height: 132.1,
          child: Column(
              children: [
                OpenContainer(
                  transitionDuration: Duration(milliseconds: 450),
                  closedBuilder: (_, openContainer) {
                  return GestureDetector(
                    onTap: openContainer,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.near_me),
                          Text(
                            sourceText != "source" ? sourceText : "출발지를 입력하세요.",
                            style: TextStyle(
                              color:
                                  sourceText != "source" ? null : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  );
                },
                openBuilder: (_, closeContainer) {
                  return SearchScreen(
                    searchType: "source",
                    onLocationSelected: (x, y) => _updateSource(x, y),
                    updateSourcePlace: (text) => changeSourceText(text),
                    updateDestinationPlace: (text) =>
                        changeDestinationText(text),
                    sourceX: sourceX,
                    sourceY: sourceY,
                    destinationX: destinationX,
                    destinationY: destinationY,
                    isSourceSelected: isSourceSelected,
                    isDestinationSelected: isDestinationSelected,
                  );
                },
              ),
              OpenContainer(
                transitionDuration: Duration(milliseconds: 450),
                closedBuilder: (_, openContainer) {
                  return GestureDetector(
                    onTap: openContainer,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.emoji_flags),
                          Text(
                            destinationText != "destination"
                                ? destinationText
                                : "도착지를 입력하세요.",
                            style: TextStyle(
                              color: destinationText != "destination"
                                  ? null
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  );
                },
                openBuilder: (_, closeContainer) {
                  return SearchScreen(
                    searchType: "destination",
                    onLocationSelected: (x, y) => _updateDestination(x, y),
                    updateSourcePlace: (text) => changeSourceText(text),
                    updateDestinationPlace: (text) =>
                        changeDestinationText(text),
                    sourceX: sourceX,
                    sourceY: sourceY,
                    destinationX: destinationX,
                    destinationY: destinationY,
                    isSourceSelected: isSourceSelected,
                    isDestinationSelected: isDestinationSelected,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //출발지는 선택되어 있을 경우
  void _updateDestination(double x, double y) {
    setState(() {
      destinationX = x;
      destinationY = y;
      isDestinationSelected = true;
      if (isSourceSelected) {
        _callApi();
      }
    });
  }

  // 도착지는 선택되어 있을 경우
  void _updateSource(double x, double y) {
    setState(() {
      sourceX = x;
      sourceY = y;
      isSourceSelected = true;
      if (isDestinationSelected) {
        _callApi();
      }
    });
  }

  //api를 호출합니다
  void _callApi() {
    // Call API with sourceX, sourceY, destinationX, and destinationY
    print("둘 다 선택되어있습니다!");
  }

  void changeSourceText(String text) {
    setState(() {
      sourceText = text;
    });
  }

  void changeDestinationText(String text) {
    setState(() {
      destinationText = text;
    });
  }
}
