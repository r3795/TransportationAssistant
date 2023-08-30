class StationInfo{
  final int index;
  final String stationName;
  final String lon;
  final String lat;
  final String stationID;

  const StationInfo({
    required this.index,
    required this.stationName,
    required this.lon,
    required this.lat,
    required this.stationID
  });

  @override
  String toString() {
    return 'StationInfo{Index: $index, Name: $stationName, Longitude: $lon, Latitude: $lat, ID: $stationID}';
  }

}