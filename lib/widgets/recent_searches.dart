import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluter_tuto/provider/provider_recent_searches.dart';
import 'package:fluter_tuto/provider/provider_favorites.dart';
import 'package:fluter_tuto/Services/api_service.dart';
import 'package:fluter_tuto/models/model_itinerary.dart';
import 'package:fluter_tuto/screens/route_screen.dart';
import 'package:fluter_tuto/provider/provider_search_variable.dart';
import 'package:fluter_tuto/models/model_favorite.dart';

class RecentSearches extends StatelessWidget {
  final BuildContext parentContext; // 부모 위젯의 BuildContext 변수
  final void Function(BuildContext context,bool value) apiLoadingCallback;
  //Const 지우면 오류가 안 나는데?
  RecentSearches({Key? key,required this.apiLoadingCallback,required this.parentContext}) : super(key: key);

  late SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final recentSearchesProvider = Provider.of<RecentSearchesProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final recentSearches = recentSearchesProvider.recentSearches;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final search = recentSearches[index];
        final isFavorite = favoritesProvider.favorites.any((favorite) =>
        favorite.sourceName == search.sourceName &&
            favorite.destinationName == search.destinationName &&
            favorite.sourceX == search.sourceX &&
            favorite.sourceY == search.sourceY &&
            favorite.destinationX == search.destinationX &&
            favorite.destinationY == search.destinationY);

        return ListTile(
          title: Text('${recentSearches[index].sourceName} -> ${recentSearches[index].destinationName}'),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.yellow : Colors.black,
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesProvider.removeFavorite(Favorite(
                  sourceName: search.sourceName,
                  destinationName: search.destinationName,
                  sourceX: search.sourceX,
                  sourceY: search.sourceY,
                  destinationX: search.destinationX,
                  destinationY: search.destinationY,
                ));
              } else {
                favoritesProvider.addFavorite(Favorite(
                  sourceName: search.sourceName,
                  destinationName: search.destinationName,
                  sourceX: search.sourceX,
                  sourceY: search.sourceY,
                  destinationX: search.destinationX,
                  destinationY: search.destinationY,
                ));
              }
            },
          ),
          onTap: () async {
            // Call your API here and navigate to RouteScreen.
            apiLoadingCallback(context,true);

            final apiService = ApiService();
            List<Itinerary> itineraries = await apiService.routeSearchApi(
              recentSearches[index].sourceX,
              recentSearches[index].sourceY,
              recentSearches[index].destinationX,
              recentSearches[index].destinationY,
            );
            searchProvider.setSourceUpdatePlace(recentSearches[index].sourceName);
            searchProvider.setDestinationUpdatePlace(recentSearches[index].destinationName);
            searchProvider.setSourceX(recentSearches[index].sourceX);
            searchProvider.setSourceY(recentSearches[index].sourceY);
            searchProvider.setDestinationX(recentSearches[index].destinationX);
            searchProvider.setDestinationY(recentSearches[index].destinationY);
            searchProvider.setSourceSelected(true);
            searchProvider.setDestinationSelected(true);

            apiLoadingCallback(context,false);

            Navigator.of(parentContext).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 1500), // 애니메이션 지속 시간 설정
                pageBuilder: (context, animation, secondaryAnimation) => RouteScreen(itineraries: itineraries),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0); // 시작 위치
                  var end = Offset.zero; // 종료 위치
                  var curve = Curves.elasticOut; // 애니메이션 커브

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => RouteScreen(itineraries: itineraries)),
            // );
          },
        );
      },
    );
  }
}
