import 'package:flutter/material.dart';

class Credit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yata - Public Transportation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: YataScreen(),
    );
  }
}

class YataScreen extends StatefulWidget {
  @override
  _YataScreenState createState() => _YataScreenState();
}

class _YataScreenState extends State<YataScreen> {
  // TODO: Add necessary state variables and API integration

  @override
  void initState() {
    super.initState();
    // TODO: Initialize necessary data and API calls
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(80.0),
          color: Colors.black, // Set the background color to black
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Credit\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                Text(
                  'Leader:\nGeon Choi\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                Text(
                  'Team members:\nJaehyeon Kim\nJunhyeok Yu\nJeonggyu Lim\nJaewon Jin\nJongwon Choi\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Public Transportation App:\nYata\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                Text(
                  'Used editor:\nFlutter\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                Text(
                  'Used APIs:\nT Map Public Transportation\nKakao Map\nGyeonggi Bus Information\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}