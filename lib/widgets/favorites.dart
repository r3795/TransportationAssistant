import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluter_tuto/provider/provider_favorites.dart';
import 'package:fluter_tuto/Services/api_service.dart';
import 'package:fluter_tuto/models/model_itinerary.dart';
import 'package:fluter_tuto/screens/route_screen.dart';
import 'package:fluter_tuto/provider/provider_search_variable.dart';
import 'package:fluter_tuto/models/model_favorite.dart';

class Favorites extends StatelessWidget {
  final BuildContext parentContext; // 부모 위젯의 BuildContext 변수
  final void Function(BuildContext context,bool value) apiLoadingCallback;
  Favorites({Key? key,required this.apiLoadingCallback,required this.parentContext}) : super(key: key);

  late SearchProvider searchProvider;

  @override
  Widget build(BuildContext context) {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favorites = favoritesProvider.favorites;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return ListTile(
          title: Text('${favorite.sourceName} -> ${favorite.destinationName}'),
          trailing: IconButton(
            icon: Icon(Icons.star, color: Colors.yellow),  // The star is always yellow.
            onPressed: () {
              favoritesProvider.toggleFavoriteStatus(favorite);
            },
          ),
          onTap: () async {
            apiLoadingCallback(context,true);

            final apiService = ApiService();
            List<Itinerary> itineraries = await apiService.routeSearchApi(
              favorite.sourceX,
              favorite.sourceY,
              favorite.destinationX,
              favorite.destinationY,
            );
            searchProvider.setSourceUpdatePlace(favorite.sourceName);
            searchProvider.setDestinationUpdatePlace(favorite.destinationName);
            searchProvider.setSourceX(favorite.sourceX);
            searchProvider.setSourceY(favorite.sourceY);
            searchProvider.setDestinationX(favorite.destinationX);
            searchProvider.setDestinationY(favorite.destinationY);
            searchProvider.setSourceSelected(true);
            searchProvider.setDestinationSelected(true);

            apiLoadingCallback(context,false);

            Navigator.of(parentContext).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 1200), // 애니메이션 지속 시간 설정
                pageBuilder: (context, animation, secondaryAnimation) => RouteScreen(itineraries: itineraries),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0); // 시작 위치
                  var end = Offset.zero; // 종료 위치
                  var curve = Curves.ease; // 애니메이션 커브

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
