class MyRoute{
  final String start;
  final String dest;
  final bool bookMark;

  MyRoute.fromMap(Map<String, dynamic> map)
  : start = map['start'],
    dest = map['dest'],
    bookMark = map['bookMark'];

  @override
  String toString() => "MyRoute<$start:$dest>";
}