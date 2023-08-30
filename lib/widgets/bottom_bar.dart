import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Container(
        height: 50,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(
              icon: Icon(
                Icons.home,
                size: 18,
              ),
              child: Text('나이땅',style: TextStyle(fontFamily: 'GmarketSansTTF',fontSize: 9),),
            ),
            Tab(
              icon: Icon(
                Icons.home,
                size: 18,
              ),
              child: Text('나이땅',style: TextStyle(fontFamily: 'GmarketSansTTF',fontSize: 9),),
            ),
            Tab(
              icon: Icon(
                Icons.home,
                size: 18,
              ),
              child: Text('나이땅',style: TextStyle(fontFamily: 'GmarketSansTTF',fontSize: 9),),
            ),
            Tab(
              icon: Icon(
                Icons.home,
                size: 18,
              ),
              child: Text('나이땅',style: TextStyle(fontFamily: 'GmarketSansTTF',fontSize: 9),),
            ),
          ],
        ),
      ),
    );
  }
}
