import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  LocationProvider() {
    _startLocationUpdates();
  }

  void _startLocationUpdates() async {
    LocationSettings settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      timeLimit: Duration(seconds: 5),  // Milliseconds, so 5000 = 5 seconds
    );

    Geolocator.getPositionStream(locationSettings: settings).listen((Position position) async {
      _currentPosition = position;
      notifyListeners();
    });
  }
}
