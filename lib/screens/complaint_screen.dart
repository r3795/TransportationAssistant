import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int columnCount = 3;
    return Scaffold(
      body: MyGridView(),
    );
  }
}

class MyGridView extends StatelessWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> grids = [
      _buildGridItem("Text 1", Colors.blue),
      _buildGridItem("Text 2", Colors.red),
      _buildGridItem("Text 3", Colors.green),
      _buildGridItem("Text 4", Colors.yellow),
      _buildGridItem("Text 5", Colors.orange),
      _buildGridItem("Text 6", Colors.pink),
      _buildGridItem("Text 7", Colors.purple),
      _buildGridItem("Text 8", Colors.brown),
      _buildGridItem("Text 9", Colors.teal),
    ];

    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: 3,
        children: grids,
      ),
    );
  }

  Widget _buildGridItem(String text, Color color) {
    return AnimationConfiguration.staggeredGrid(
      position: 0,
      duration: const Duration(milliseconds: 1000),
      columnCount: 3,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: Container(
            color: color,
            margin: EdgeInsets.all(30.0),
            height: 200.0,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
