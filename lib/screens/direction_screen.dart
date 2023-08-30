import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluter_tuto/widgets/direction_screen_top.dart';
import 'package:fluter_tuto/widgets/recent_searches.dart';
import 'package:fluter_tuto/widgets/favorites.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({Key? key}) : super(key: key);

  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  bool isLoading = false;
  void apiLoadingCallBack(){

  }
  @override
  void initState() {
    super.initState();
  }

  void setLoading(BuildContext context,bool value) {
    setState(() {
      isLoading = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DirectionTop(),
          if (isLoading) ...[
            Expanded(
              child: Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  color: Colors.blueGrey.shade200,
                  size: 60,
                ),
              ),
            ),
          ],
          if (!isLoading) ...[
            Divider(color: Colors.grey, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(4.5),
              child: Text("최근 검색", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: RecentSearches(apiLoadingCallback:setLoading,parentContext: context), // parentContext 변수에 부모 BuildContext 전달
              ),
            ),
            Divider(color: Colors.grey, thickness: 1),
            Padding(
              padding: const EdgeInsets.all(4.5),
              child: Text("즐겨찾기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Favorites(apiLoadingCallback:setLoading,parentContext: context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
