//End 클래스는 각 이동마다 도착 지점의 이름과, GPS X좌표,Y좌표를 담고 있는 클래스
class End {
  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
  final String name;
  final double lon;
  final double lat;
  const End({
    required this.name,
    required this.lon,
    required this.lat
  });
}