import 'package:flutter/material.dart';

class DirectionBot extends StatefulWidget {
  const DirectionBot({Key? key}) : super(key: key);

  @override
  State<DirectionBot> createState() => _DirectionBotState();
}

class _DirectionBotState extends State<DirectionBot> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            title: Text('Item 1'),
          ),
          ListTile(
            title: Text('Item 2'),
          ),
          // add more ListTiles as needed
        ],
      ),
    );
  }
}
