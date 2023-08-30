import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluter_tuto/models/model_itinerary.dart';
import 'package:fluter_tuto/models/model_location.dart';
import 'package:fluter_tuto/models/model_leg.dart';

class ApiService {
  Future<List<ApiLocation>> fetchPlaces(String searchWord) async {
    String searching = searchWord;
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=$searching';
    Map<String, String> headers = {
      "Authorization": "KakaoAK 962bb781f2d49d633254c7810526d0d7"
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    final places = json.decode(response.body)['documents'];
    List<ApiLocation> locations = [];
    for (var place in places) {
      ApiLocation location = ApiLocation(
        placeName: place['place_name'],
        addressName: place['address_name'],
        roadAddressName: place['road_address_name'],
        categoryGroupName: place['category_group_name'],
        x: double.parse(place['x']),
        y: double.parse(place['y']),
      );
      locations.add(location);
    }
    return locations;
  }

  Future<List<Itinerary>> routeSearchApi(
      double startX, double startY, double endX, double endY) async {
    final String url = 'https://apis.openapi.sk.com/transit/routes';
    final String appKey =
        '0I6XxTdQc94Tzk5lGmkOb6rMomDOADL45jQUwJcQ'; // 발급 받은 Appkey를 입력해주세요.

    final Map<String, String> headers = {
      'accept': 'application/json',
      'appKey': appKey,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      "startX": startX,
      "startY": startY,
      "endX": endX,
      "endY": endY,
      "count": 10,
      "lang": 0,
      "format": "json",
      //대중 교통 길찾기 경로 검색할 기준 시간
      "searchDttm": "202303101500"
    };
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));
    final decodedResponse = utf8.decode(response.bodyBytes);
    final data = json.decode(decodedResponse);

    if (response.statusCode == 200) {
      //API response 데이터를 파싱해서 미리 만들어놓은 클래스에 데이터를 삽입.
      final List<dynamic> itinerariesData =
      data['metaData']['plan']['itineraries'];

      List<Itinerary> itineraries = [];

      for (final itineraryData in itinerariesData) {
        final List<dynamic> legsData = itineraryData['legs'];

        List<Leg> legs = [];
        for (final legData in legsData) {
          //fromJson 함수는 그냥 매개변수 안에 있는 값을 클래스 객체에 넣어주는 함수.
          //생성자랑 비슷하지만 fromJson은 객체를 리턴함
          legs.add(Leg.fromJson(legData));
        }

        final Itinerary itinerary = Itinerary(
            totalFare: itineraryData['fare']['regular']['totalFare'],
            totalTime: itineraryData['totalTime'],
            totalWalkDistance: itineraryData['totalWalkDistance'],
            totalWalkTime: itineraryData['totalWalkTime'],
            totalDistance: itineraryData['totalDistance'],
            legs: legs,
            startX: startX,
            startY: startY,
            endX: endX,
            endY: endY);

        itineraries.add(itinerary);
      }
      itineraries.forEach((element) {
        print(
            "=====================================================================");
        print(element.toString());
        for (final leg in element.legs) {
          print(leg.toString());
        }
        print(
            "=====================================================================");
      });
      return itineraries;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }
}
