class Favorite {
  final String sourceName;
  final String destinationName;
  final double sourceX;
  final double sourceY;
  final double destinationX;
  final double destinationY;
  bool isFavorite;

  Favorite({
    required this.sourceName,
    required this.destinationName,
    required this.sourceX,
    required this.sourceY,
    required this.destinationX,
    required this.destinationY,
    this.isFavorite = false,
  });
}
