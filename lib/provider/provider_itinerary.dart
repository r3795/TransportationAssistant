import 'package:flutter/foundation.dart';
import '../models/model_itinerary.dart';


class AlarmItineraryProvider extends ChangeNotifier {
  Itinerary _itinerary = Itinerary.empty();

  Itinerary get itinerary => _itinerary;

  bool _hasRequestTest = false ;

  bool get hasRequestTest => _hasRequestTest;

  void setItinerary(Itinerary value) {
    _itinerary = value;
    notifyListeners();
  }
  void setRequest(bool value){
    _hasRequestTest = value;
    notifyListeners();
  }
}