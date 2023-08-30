import 'package:fluter_tuto/provider/provider_search_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model_location.dart';
import 'package:fluter_tuto/screens/route_screen.dart';
import 'package:fluter_tuto/models/model_itinerary.dart';
import 'package:fluter_tuto/Services/api_service.dart';
import 'package:fluter_tuto/provider/provider_recent_searches.dart';
import 'package:fluter_tuto/models/model_recent_search.dart';

import 'package:flutter/services.dart'; // Import the flutter/services.dart package

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class SearchScreen extends StatefulWidget {
  //source에서 장소를 지정했는지, destination에서 장소를 지정했는지 구분하기 위함
  final String searchType;

  //direction_screen_top에서 데이터를 내려받기 위한 변수 선언
  final double sourceX;
  final double sourceY;
  final double destinationX;
  final double destinationY;
  final bool isSourceSelected;
  final bool isDestinationSelected;

  // //객체를 넘겨주기 위한 선언
  // List<Itinerary> itineraries;

  //콜백함수를 위한 함수 선언(업데이트)
  final Function(double, double) onLocationSelected;
  final Function(String) updateSourcePlace;
  final Function(String) updateDestinationPlace;

  //const를 안 빼면 오류가 나는데..?
  SearchScreen({
    Key? key,
    required this.sourceX,
    required this.sourceY,
    required this.destinationX,
    required this.destinationY,
    required this.isSourceSelected,
    required this.isDestinationSelected,
    required this.searchType,
    required this.onLocationSelected,
    required this.updateDestinationPlace,
    required this.updateSourcePlace,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<ApiLocation>> _futureLocations = Future.value([]);
  String _lastSearchQuery = '';
  late SearchProvider searchProvider;
  final _apiService = ApiService();

  bool isLoading = false;

  void fetchDataLoading(double x,double y,bool isFirstApi,SearchProvider searchProvider) async {

    double param1, param2, param3, param4;

    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus(); // 키보드 창 닫기

    // if (isFirstApi) {
    //   param1 = x;
    //   param2 = y;
    //   param3 = widget.destinationX;
    //   param4 = widget.destinationY;
    // } else {
    //   param1 = widget.sourceX;
    //   param2 = widget.sourceY;
    //   param3 = x;
    //   param4 = y;
    // }
    if (isFirstApi) {
      param1 = x;
      param2 = y;
      param3 = searchProvider.destinationX;
      param4 = searchProvider.destinationY;
    } else {
      param1 = searchProvider.sourceX;
      param2 = searchProvider.sourceY;
      param3 = x;
      param4 = y;
    }

    // api 호출
    List<Itinerary>itineraries = await _apiService.routeSearchApi(param1,param2,param3,param4);

    setState(() {
      isLoading = false;
    });


    void navigateToNextScreen() {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RouteScreen(itineraries: itineraries,))
      );
    }
    navigateToNextScreen();
    // // Navigate to the next screen after API call is completed
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => RouteScreen(itineraries: itineraries,)),
    // );
  }


  @override
  void initState() {
    super.initState();
    _futureLocations = Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final recentSearchesProvider = Provider.of<RecentSearchesProvider>(context, listen: false);
    RecentSearch newSearch;

    final List<Widget> _items = [
      IconButton(
        icon: Icon(Icons.home),
        onPressed: () {
          print('Home button pressed');
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          print('Search button pressed');
        },
      ),
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          print('Settings button pressed');
        },
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30, right: 5, left: 5),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
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
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '장소나 지역을 입력해주세요.',
                        suffixIcon: IconButton(
                          onPressed: _searchController.clear,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ), // IconButton removed
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.2, // 경계선의 두께를 조정할 수 있습니다.
                  ),
                ),
              ),
              height: 80.0,
              // adjust this to suit your needs for the vertical size
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.my_location_outlined),
                        onPressed: () {
                          print('Home button pressed');
                        },
                      ),
                      Text('현위치'),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home_outlined),
                        onPressed: () {
                          print('Search button pressed');
                        },
                      ),
                      Text('집'),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.domain_outlined),
                        onPressed: () {
                          print('Settings button pressed');
                        },
                      ),
                      Text('학교/회사'),
                    ],
                  ),
                ],
              )
            ),
            if (isLoading)
              Expanded(
                child: Center(
                  child: LoadingAnimationWidget.prograssiveDots(
                    color: Colors.grey,
                    size: 60,
                  ),
                ),
              ),
            if(!isLoading)
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) {
                final searchQuery = value.text.trim();
                if (searchQuery.isNotEmpty && searchQuery != _lastSearchQuery) {
                  _lastSearchQuery = searchQuery;
                  _futureLocations = _apiService.fetchPlaces(searchQuery);

                }
                return Expanded(
                  child: _futureLocations == null
                      ? Container()
                      : FutureBuilder<List<ApiLocation>>(
                          future: _futureLocations,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ApiLocation>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              final locations = snapshot.data;
                              if (locations!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.search_off,
                                        color: Colors.grey,
                                        size: 50.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          '검색 결과가 없습니다..',
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return Container(
                                child: NotificationListener<
                                    OverscrollIndicatorNotification>(
                                  onNotification: (notification) {
                                    notification.disallowIndicator();
                                    return true;
                                  },
                                  child: ListView.builder(
                                    //padding: EdgeInsets.zero,
                                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                    key: UniqueKey(),
                                    itemCount: locations!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              height: 73,
                                              padding: EdgeInsets.only(top: 0),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey, // Choose the desired color for the border
                                                    width: 0.5, // Adjust the width of the border
                                                  ),
                                                ),
                                              ),
                                              child: ListTile(
                                                  leading: Transform.translate(
                                                    offset: Offset(5, 8), // Adjust the vertical offset as needed
                                                    child: Icon(Icons.location_on),
                                                  ),
                                                title: Text(
                                                  locations[index].placeName,
                                                  style: TextStyle(
                                                    fontSize: 16, // Adjust the font size as needed
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  locations[index].addressName,
                                                  style: TextStyle(
                                                    fontSize: 13, // Adjust the font size as needed
                                                  ),
                                                ),
                                                onTap: () async {
                                                  widget.onLocationSelected(locations[index].x, locations[index].y);
                                                  if (widget.searchType == "source") {
                                                    searchProvider.setSourceUpdatePlace(locations[index].placeName);
                                                    searchProvider.setSourceSelected(true);
                                                    searchProvider.setSourceX(locations[index].x);
                                                    searchProvider.setSourceY(locations[index].y);
                                                    widget.updateSourcePlace(locations[index].placeName);
                                                    if (widget.isDestinationSelected == true) {
                                                      newSearch = RecentSearch(
                                                          sourceName: searchProvider.sourcePlaceName,
                                                          destinationName: searchProvider.destinationPlaceName,
                                                          sourceX: searchProvider.sourceX,
                                                          sourceY: searchProvider.sourceY,
                                                          destinationX: searchProvider.destinationX,
                                                          destinationY: searchProvider.destinationY
                                                      );
                                                      recentSearchesProvider.addSearch(newSearch);
                                                      print(locations[index].x.toString() + "," + locations[index].y
                                                          .toString());
                                                      print(widget.destinationX.toString() + "," + widget.destinationY
                                                          .toString());
                                                      print("api 호출1");
                                                      _apiService.routeSearchApi(
                                                          locations[index].x, locations[index].y, widget.destinationX,
                                                          widget.destinationY);
                                                      // Itineraries 객체 리스트를 넘기기 위해서
                                                      // List<Itinerary>itineraries = await _apiService.routeSearchApi(locations[index].x, locations[index].y, widget.destinationX, widget.destinationY);
                                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => RouteScreen(itineraries: itineraries,),));
                                                      bool isFirst = true;
                                                      fetchDataLoading(locations[index].x, locations[index].y, isFirst,searchProvider);
                                                    } else {
                                                      //1개만 됐을 때는 pop하고 2개 다 됐을 때는 RouteScreen으로 보냄
                                                      Navigator.pop(context);
                                                    }
                                                  } else if (widget.searchType == "destination") {
                                                    searchProvider.setDestinationUpdatePlace(locations[index].placeName);
                                                    searchProvider.setDestinationSelected(true);
                                                    searchProvider.setDestinationX(locations[index].x);
                                                    searchProvider.setDestinationY(locations[index].y);
                                                    widget.updateDestinationPlace(locations[index].placeName);
                                                    if (widget.isSourceSelected == true) {
                                                      newSearch = RecentSearch(
                                                          sourceName: searchProvider.sourcePlaceName,
                                                          destinationName: searchProvider.destinationPlaceName,
                                                          sourceX: searchProvider.sourceX,
                                                          sourceY: searchProvider.sourceY,
                                                          destinationX: searchProvider.destinationX,
                                                          destinationY: searchProvider.destinationY
                                                      );
                                                      recentSearchesProvider.addSearch(newSearch);
                                                      print("${widget.sourceX},${widget.sourceY}");
                                                      print("${locations[index].x},${locations[index].y}");
                                                      print("api 호출2");
                                                      //로딩 위젯 띄우는 함수 (안에 API 호출 메서드 있음)
                                                      bool isFirst = false;
                                                      fetchDataLoading(locations[index].x, locations[index].y, isFirst,searchProvider);
                                                      // Itineraries 객체 리스트를 넘기기 위해서
                                                      // List<Itinerary>itineraries = await _apiService.routeSearchApi(widget.sourceX, widget.sourceY, locations[index].x, locations[index].y);
                                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => RouteScreen(itineraries: itineraries,),));
                                                    } else {
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                }),
                                            ),
                                          ),
                                           // Divider(color: Colors.grey, thickness: 0.5,),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
