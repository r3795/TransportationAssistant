import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SearchProvider extends ChangeNotifier {

  String _sourcePlaceName = "출발지를 입력하세요.";
  String _destinationPlaceName = "도착지를 입력하세요.";
  String _alarmSourcePlaceName = '설정된 값이';
  String _alarmDestinationPlaceName = ' 없습니다.';
  double _sourceX = 0.0;
  double _sourceY = 0.0;
  double _destinationX = 0.0;
  double _destinationY = 0.0;
  bool _isSourceSelected=false;
  bool _isDestinationSelected=false;


  String get destinationPlaceName => _destinationPlaceName;
  String get sourcePlaceName => _sourcePlaceName;
  bool get  isSourceSelected =>_isSourceSelected;
  bool get  isDestinationSelected =>_isDestinationSelected;
  double get sourceX => _sourceX;
  double get sourceY => _sourceY;
  double get destinationX => _destinationX;
  double get destinationY => _destinationY;
  String get alarmSourcePlaceName => _alarmSourcePlaceName;
  String get alarmDestinationPlaceName => _alarmDestinationPlaceName;

  void setSourceUpdatePlace(String value) {
    _sourcePlaceName = value;
    notifyListeners();
  }
  void setDestinationUpdatePlace(String value) {
    _destinationPlaceName = value;
    notifyListeners();
  }
  void setSourceX(double value){
    _sourceX = value;
    notifyListeners();
  }
  void setSourceY(double value){
    _sourceY = value;
    notifyListeners();
  }
  void setDestinationX(double value){
    _destinationX = value;
    notifyListeners();
  }
  void setDestinationY(double value){
    _destinationY = value;
    notifyListeners();
  }
  void setSourceSelected(bool value){
    _isSourceSelected = value;
    notifyListeners();
  }
  void setDestinationSelected(bool value){
    _isDestinationSelected = value;
    notifyListeners();
  }
  // 하차 알림에 대한 출발지 목적지 이름 설정 (디테일 스크린 버튼액션에 들어갈것)
  void setAlarm() {
    _alarmSourcePlaceName = _sourcePlaceName;
    _alarmDestinationPlaceName = _destinationPlaceName;
    notifyListeners();
  }
}
